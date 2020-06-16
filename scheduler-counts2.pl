#!/usr/bin/perl
#
# Loads sate heading by coverage table
# run ./scheduler-counts.pl YYMM

$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
$dbh      = DBI->connect("dbi:mysql:tgrams:localhost", "", "");
$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);       
               
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

system("mysqlimport -i tgrams scheduler_counts.txt");

close(wf);


  
$rc = $dbh->disconnect;


