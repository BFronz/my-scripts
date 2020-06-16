#!/usr/bin/perl
#
# Loads sate heading by coverage table
# run ./scheduler-counts.pl YYMM

$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
require "/usr/wt/trd-reload.ph";

$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);       
               
open(wf,  ">scheduler_cad_counts.txt")  || die (print "Could not open scheduler_cad_counts.txt\n"); 
$query  = "SELECT date, acct, count(*) FROM thomtnetlogCADDET$yy WHERE acct>0 GROUP BY date, acct ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {      
  $date = $$row[0];
  $acct = $$row[1];
  $cnt  = $$row[2];
  print wf "$date\t$acct\t$cnt\n";
 }
$sth->finish;   
close(wf);
system("mysqlimport -iL tgrams $DIR/scheduler_cad_counts.txt"); 


open(wf,  ">scheduler_hd_counts.txt")  || die (print "Could not open scheduler_hd_counts.txt\n"); 
$query  = "SELECT date, q.acct, count(*) FROM thomqlog".$yy."Y AS q LEFT JOIN tgrams.main AS m ON q.acct=m.acct ";
$query .= "WHERE adv>'' AND date>'' AND q.acct>0 AND heading>0 AND covflag='t' ";
$query .= "GROUP BY date, q.acct ";
#print "$query "; exit;
my $sth = $dbh->prepare($query);  
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {      
  $date = $$row[0];
  $acct = $$row[1];
  $cnt  = $$row[2];
  print wf "$date\t$acct\t$cnt\n";
 }
$sth->finish;   
close(wf);
system("mysqlimport -iL tgrams scheduler_hd_counts.txt"); 


open(wf,  ">scheduler_counts.txt")  || die (print "Could not open scheduler_counts.txt\n");
$query  = "select count(distinct date) as n from tgrams.scheduler_cad_counts ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
if (my $row = $sth->fetchrow_arrayref)
 {
  $datecount = $$row[0];
 }
$sth->finish;
print "\nDate Count: $datecount\n";

$query  = "select acct,sum(cnt)/11 as n, 'CAD' from tgrams.scheduler_cad_counts group by acct ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  print wf "$$row[0]\t$$row[1]\t$$row[2]\n";
 }
$sth->finish;

$query  = "select acct,sum(cnt)/11 as n, 'HD' from tgrams.scheduler_hd_counts group by acct ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  print wf "$$row[0]\t$$row[1]\t$$row[2]\n";
 }
$sth->finish;

close(wf);

system("mysqlimport -diL tgrams $DIR/scheduler_counts.txt");
  
$rc = $dbh->disconnect;


