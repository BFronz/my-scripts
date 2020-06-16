#!/usr/bin/perl
# 
# Loads Tnet, TGR & News Org  data w/o geo
# run as  ./load-org-extra.pl YYMM
# run last of all org scripts    
# may have to run this more than once per month if they add more isp & blocks to tnetlogORGflag


$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);             
$mm       =  substr($fdate, 2, 2);
if($ARGV[1] eq "DELETE") {$delete = 1 ;}
 
use DBI;
$dbh      = DBI->connect("", "", "");
 

 
# TNET HEADING
$query = "DELETE FROM tnetlogORGCATN$yy WHERE date='$fdate'";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

$outfile = "tnetlogORGCATN$yy.txt"; 
$table   = "tnetlogORGCATD" . $yy . "_" . $mm;
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");       
$query   = "SELECT heading, sum(cnt), org, domain, isp, block, ip FROM $table  ";
$query  .= "WHERE date='$fdate' AND heading>0 AND orgid>''GROUP BY heading, org "; 
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {                
  print wf "$fdate\t$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$$row[5]\t$$row[6]\n";
 }  
$sth->finish;

close(wf);
system("mysqlimport thomas $outfile");   

print "\n\nProcessing complete.\nCheck for errors.\n\n";   
 
$rc = $dbh->disconnect;


 




