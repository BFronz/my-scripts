#!/usr/bin/perl
# 
# Creates file of cid heading, cov and pop based on a given position table
# run each new rank
# run as ./cidcatpop.pl YY Q
# post this file to IR 
# CID, Category, Pop Points and quarter.

if($ARGV[0] eq "" || $ARGV[1] eq "") {print "\n\nForgot to add  YY or Q\n\n"; exit;}
$yy = $ARGV[0];
$q  = $ARGV[1];
$recdate = $yy . "0" . $q; 
 
use DBI;
require "/usr/wt/trd-reload.ph";
          
$outfile  = "cidcatpop.txt"; 
$table    = "cidcatpop";
$sql      = $table . ".sql"; 
$outfile  = $table . ".txt"; 
$postable = "thomposition" . $yy . "Q" .  $q ;
print "\nRecdate: $recdate \nOutfile: $outfile\nPosition Table: $postable\n\n";
            
$i=0;                                     
open(wf, ">$outfile")  || die (print "Could not open $outfile\n"); 
$query  = "SELECT p.acct, heading, p.cov, pop ";
$query .= "FROM $postable AS p LEFT JOIN tgrams.main AS m ON p.acct=m.acct ";
$query .= "WHERE m.adv>'' AND pop>0 ";
$query .= "ORDER BY p.acct, heading, p.cov ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {            
   $acct = $$row[0];
   $hd   = $$row[1];
   $cov  = $$row[2];
   $pop  = $$row[3]; 
   #print wf "$acct\t$hd\t$cov\t$pop\t$recdate\n";
   if($cov eq "NA") { print wf "$acct\t$hd\t$pop\t$recdate\n"; }
   $acct = $hd = $cov = $pop = 0;
 }   
$sth->finish;

system("mysqlimport -dL thomas $DIR/$outfile");
system("nice gzip $outfile");

close(wf);
$dbh->disconnect;
 
print "\nDone\n";  

 
