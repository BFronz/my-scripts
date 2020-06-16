#!/usr/bin/perl
#
#
 
$outfile = "catreg_history.txt";

use DBI;
 
$dbh = DBI->connect("dbi:mysql:tgrams:localhost", "", "");
   
# Get distinct cookie from catreglog and put into array
$i=0;
$query  = " select distinct(cookie) from catreglog where  origin='TNET' "; 
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
  { 
    $record[$i] = $$row[0];
    $i++; 
   }
$sth->finish;  
print "\n\nTotal cookies: $i\n\n";

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
      
# Run through each record checking the TNET
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
foreach $record (@record)
 { 
    $record =~ s/\s//g; 
      
    $tnetq  = " select * from mt_profile_history where tinid='$record' ";
    my $sth = $dbh->prepare($tnetq);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    if (my $row = $sth->fetchrow_arrayref)
      { 
       $$row[16] =~ s/\s+$//; $$row[16]=~ s/^\s+//;
       if($$row[16] ne ""){ $$row[14] =  $state{$$row[16]} ; }

       $$row[23]="TNET";

       print wf "$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$$row[5]\t$$row[6]\t$$row[7]\t$$row[8]\t$$row[9]\t$$row[10]\t";
       print wf "$$row[11]\t$$row[12]\t$$row[13]\t$$row[14]\t$$row[15]\t$$row[16]\t$$row[17]\t$$row[18]\t$$row[19]\t$$row[20]\t$$row[21]\t$$row[22]\t$$row[23]\t$$row[24]\n"; 
       $TNET++;
      } 
     $sth->finish;
    
  }  
close(wf);

$rc = $dbh->disconnect;
system("mysqlimport -r tgrams $outfile"); 


