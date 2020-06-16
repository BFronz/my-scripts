#!/usr/bin/perl
#
#

use DBI;
use POSIX;
require "/usr/wt/trd-reload.ph";

$fdate   = $ARGV[0];
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

$outfile = "multiloc" .  $fdate  . ".txt";
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
 
  
$i=0;                                                                             
$query  = "SELECT multiloc  FROM  tgrams.main   WHERE acct=multiloc GROUP BY multiloc ";
#$query .= " limit 25 ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $record[$i]=$$row[0];
  #print "$i\t$record[$i]\n";
  $i++;
 }
$sth->finish;

 
$z=1;
foreach $record (@record)
 {
  #print "$z.\t$record\n";
      
 $query  = "SELECT acct  FROM  tgrams.main   WHERE multiloc=$record  ";
 #print "\n\n$query\n\n"; 
 my $sth = $dbh->prepare($query); 
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {
  if($record == $$row[0]) {$masterrec="Y";} else {$masterrec="";}
  print wf "$record\t$$row[0]\t$masterrec\n";
 }
 $sth->finish;
 
 $z++;
}

close(wf);

$dbh->disconnect;

system("mysqlimport -dL tgrams $outfile");

print "\nDone...";
