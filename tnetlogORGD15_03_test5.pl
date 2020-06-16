#!/usr/bin/perl
#
#

use DBI;
use POSIX;
 

require "/usr/wt/trd-reload.ph";

$outfile = "pre-post-processing-all.txt";
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
  
print "\t\tPreprocessing\t\t\t\t\t\tPost processing\n";
print wf "acct\tvisitor\tadv\tisp\tblock\ttinid\t \tacct\tvisitor\tadv\tisp\tblock\ttinid\n";	
   
$i=0;                                                                             
$query  = "SELECT acct FROM tnetlogORGD15_03_test_accts WHERE acct>0 ORDER BY acct";
$query .= " limit 25 ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $record[$i]="$$row[0]|$$row[1]";
  print "$record[$i]\n";
  $i++;
 } 
$sth->finish;
  
 
 
$z=1;
foreach $record (@record)
 {
 print "$z.\t$record\n";
   
 ###  Pre
 $query  = "SELECT acct, org, adv, isp, block, tinid FROM thomtnetlogORGD15_03_test WHERE acct='$record' ORDER org";
 #print "\n\n$query\n\n";
 $check=0; 
 my $sth = $dbh->prepare($query);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 if (my $row = $sth->fetchrow_arrayref)
  {                    
   print wf "$$row[0]\t$$row[1]\t"
   print wf "$$row[2]\t$$row[3]\t"
   print wf "$$row[4]\t$$row[5]\t"
  }  
 $sth->finish;
 
 print 

 ###  Post
 $query  = "SELECT acct, org, adv, isp, block, tinid FROM thomtnetlogORGD15_03_test2 WHERE acct='$record' ORDER org";
 #print "\n\n$query\n\n";
 $check=0; 
 my $sth = $dbh->prepare($query);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 if (my $rrow = $sth->fetchrow_arrayref)
  {                     
   print wf "$$rrow[0]\t$$rrow[1]\t"
   print wf "$$rrow[2]\t$$rrow[3]\t"
   print wf "$$rrow[4]\t$$rrow[5]\n"
  }  
 $sth->finish;

 $z++;
}

close(wf);

$dbh->disconnect;

print "\nDone...";
