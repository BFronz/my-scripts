#!/usr/bin/perl
#
#

use DBI;
use POSIX;
$dbh = DBI->connect("", "", "");

$rdate = " '1212', '1301','1302','1303','1304','1305','1306','1307','1308','1309','1310','1311' ";
 
sub PrintQ
{
 $q = $_[0];
# print "\n$q\n";
}

$outfile = "call-tracking-data-1212-1311.txt";
system("rm -f $outfile");
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
 
print wf "Account #\t";
print wf "Company\t";
  
print wf "December-2012\t";
print wf "January-2013\t";
print wf "February-2013\t";
print wf "March-2013\t";
print wf "April-2013\t";
print wf "May-2013\t";
print wf "June-2013\t";
print wf "July-2013\t";
print wf "August-2013\t";
print wf "September-2013\t";
print wf "October-2013\t";
print wf "November-2013\n";

$i=0;                   
$query  = "SELECT m.company, m.acct FROM thomestara AS e, tgrams.main AS m WHERE e.acct>0 AND e.acct=m.acct AND date in ($rdate) GROUP BY m.acct  ";
$query  .= "ORDER BY company "; 
# $query  .= "LIMIT 10 "; # for testing
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $record[$i]="$$row[0]|$$row[1]";
  $i++;
 }
$sth->finish;

$z=1;
foreach $record (@record)
{
 print "$z) $record\n";
 ($comp,$acct) = split(/\|/,$record);

 print wf "$acct\t";                                
 print wf "$comp\t";                              
  
 $q = "SELECT   
 sum(if(date ='1212',1,0)),
 sum(if(date ='1301',1,0)),
 sum(if(date ='1302',1,0)),
 sum(if(date ='1303',1,0)),
 sum(if(date ='1304',1,0)),
 sum(if(date ='1305',1,0)),
 sum(if(date ='1306',1,0)),
 sum(if(date ='1307',1,0)),
 sum(if(date ='1308',1,0)),
 sum(if(date ='1309',1,0)),
 sum(if(date ='1310',1,0)),
 sum(if(date ='1311',1,0))
 FROM thomestara 
 WHERE date IN ($rdate) AND acct='$acct' ";  
 PrintQ($q); 
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 if (my $row = $sth->fetchrow_arrayref)
  {  
   print wf "$$row[0]\t";      #   1212 
   print wf "$$row[1]\t";      #   1301 
   print wf "$$row[2]\t";      #   1302 
   print wf "$$row[3]\t";      #   1303 
   print wf "$$row[4]\t";      #   1304 
   print wf "$$row[5]\t";      #   1305 
   print wf "$$row[6]\t";      #   1306 
   print wf "$$row[7]\t";      #   1307 
   print wf "$$row[8]\t";      #   1308 
   print wf "$$row[9]\t";      #   1309 
   print wf "$$row[10]\t";     #   1310 
   print wf "$$row[11]\n";     #   1311 
  }
 $sth->finish;
 $acctmap .= $acct;
  
 $z++;
}

close(wf);

$dbh->disconnect;

print "\n\nDone...\n\n";
