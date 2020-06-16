#!/usr/bin/perl
#
#
   
use DBI; 
require "/usr/wt/trd-reload.ph";

# Change these vars

# Q1 2016
$outfile = "tnetRegistry46.csv";
$START=1451624400;
$END=1459483200;
 
# Q2 2016
$outfile = "tnetRegistry47.csv";
$START=1459483200;
$END=1467345600;


# Q3 2016
$outfile = "tnetRegistry48.csv";
$START=1467345600;
$END=1475294400;

# Q4 2016
$outfile = "tnetRegistry49.csv";
$START=1475294400;
$END=1483246800;

 
# Put fips stuff into array
$i=0;
$query  = "select zip, state  from tgrams.fips group by zip "; 
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



        

open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
print wf "\"Company\",\"Industry\",\"Job Function\",\"State\",\"Zip\",\"Country\"\n";
$query = "SELECT  trim(company), trim(industry) as Industry, trim(jobfunction) as JobFunction, trim(zip) as Zip, trim(country) as Country ";
$query .= "FROM tgrams.sso_profile  AS h LEFT JOIN tgrams.mt_ringer as r ON h.tinid=r.tinid ";
$query .= "WHERE r.tinid  is null  AND company>'' AND company not in ('>','<','*','******','-','---','.','?','????','.....') ";
$query .= " and (created >=$START  and created<$END) and email like '%@%.%' and length(company)<200  and length(company)>1 and company not like '%-----%' and company not like '%******%' ";
$query .= "ORDER BY company "; 


$query = "SELECT  trim(company), trim(industry) as Industry, trim(jobfunction) as JobFunction, trim(zip) as Zip, trim(country) as Country ";
$query .= "FROM tgrams.sso_profile  ";
$query .= "WHERE (created >=$START AND created<$END) AND company>'' AND company not in ('>','<','*','******','-','---','.','?','????','.....') AND email like '%@%.%' ";
$query .= "ORDER BY company ";  
 
#print "\n\n$query\n\n"; exit;
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
   $j++;
 }  
$sth->finish;
close(wf);
print "Total Records: $j in $outfile\n\n"; 
#system("rm -f /usr/pdf/csv/catreg/$outfile");
#system("cp -f $outfile /usr/pdf/csv/catreg/");

 

