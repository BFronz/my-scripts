#!/usr/bin/perl
#
#
 
use DBI;
 
$dbh = DBI->connect("dbi:mysql:tgrams:localhost", "", "");
    
# Put fips stuff into array
$i=0;
$query  = "select zip, state  from fips group by zip; "; 
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
  {
    $z = $$row[0];
    $s = $$row[1];
    $state{$z} = $s;
    $i++; 
   }
$sth->finish;  
print "\n\nTotal zip codes/states: $i\n\n";



# Get count
$i=0;
$query = "SELECT  count(*) ";
$query .= "FROM mt_profile_history LEFT JOIN mt_ringer ON mt_profile_history.tinid=mt_ringer.tinid ";
$query .= "WHERE mt_ringer.tinid  is null  AND company>'' AND company not in ('>','<','*','******','-','---','.','?','????','.....') ";
$query .= " and created <1112331600 ";
$query .= "ORDER BY company ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
if (my $row = $sth->fetchrow_arrayref)
  { 
    $total = $$row[0];
    $half  = $total/2;
   }
$sth->finish;  
print "\n\nTotal: $total $half\n\n";


 
# First file       
$outfile = "tnetRegistry1.csv";
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
print wf "\"Company,Industry\",\"Job Function\",\"State,Zip\",\"Country\"\n";      
$query = "SELECT  trim(company), trim(industry) as Industry, trim(jobfunction) as JobFunction, trim(zip) as Zip, trim(country) as Country ";
$query .= "FROM mt_profile_history LEFT JOIN mt_ringer ON mt_profile_history.tinid=mt_ringer.tinid ";
$query .= "WHERE mt_ringer.tinid  is null  AND company>'' AND company not in ('>','<','*','******','-','---','.','?','????','.....') ";
$query .= " and created <1112331600 ";
$query .= "ORDER BY company ";
$query .= "limit $half ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
   $$row[0]=~ s/\"//g;     
   $$row[1]=~ s/\"//g;     
   $$row[2]=~ s/\"//g;     
   $$row[3]=~ s/\"//g;     
   $$row[4]=~ s/\"//g;     
   print wf "\"$$row[0]\",\"$$row[1]\",\"$$row[2]\",\"$state{$$row[3]}\",\"$$row[3]\",\"$$row[4]\"\n";  

 }  
$sth->finish;
close(wf); 
system("rm -f /usr/pdf/csv/$outfile");
system("mv $outfile /usr/pdf/csv/");

 


# First file       
$outfile = "tnetRegistry2.csv";
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
print wf "\"Company,Industry\",\"Job Function\",\"State,Zip\",\"Country\"\n";      
$query = "SELECT  trim(company), trim(industry) as Industry, trim(jobfunction) as JobFunction, trim(zip) as Zip, trim(country) as Country ";
$query .= "FROM mt_profile_history LEFT JOIN mt_ringer ON mt_profile_history.tinid=mt_ringer.tinid ";
$query .= "WHERE mt_ringer.tinid  is null  AND company>'' AND company not in ('>','<','*','******','-','---','.','?','????','.....') ";
$query .= " and created <1112331600 ";
$query .= "ORDER BY company ";
$query .= "limit $half,1000000 ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
   $$row[0]=~ s/\"//g;     
   $$row[1]=~ s/\"//g;     
   $$row[2]=~ s/\"//g;     
   $$row[3]=~ s/\"//g;     
   $$row[4]=~ s/\"//g;     
   print wf "\"$$row[0]\",\"$$row[1]\",\"$$row[2]\",\"$state{$$row[3]}\",\"$$row[3]\",\"$$row[4]\"\n";  
 
 }  
$sth->finish;
close(wf); 
system("rm -f /usr/pdf/csv/$outfile");
system("mv $outfile /usr/pdf/csv/");

 
$rc = $dbh->disconnect;


 
  
