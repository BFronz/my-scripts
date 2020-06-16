#!/usr/bin/perl
#
# loads news_flag
# ./update_news_flag.pl YYMM

$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
require "/usr/wt/trd-reload.ph";

$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);             
  
# Load news_flag table used for scheduler
$outfile3 = "news_flag.txt";
open(wf,  ">$outfile3")  || die (print "Could not open $outfile2\n");
$query = " select distinct(acct) from thomnews_conversions$yy where date='$fdate' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
  print wf "$$row[0]\tC\n";
 }
$sth->finish;

$query = " select distinct(AdvertiserCid) from thomnews_ad_cat$yy where date='$fdate' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
  print wf "$$row[0]\tI\n";
 }
$sth->finish;
close(wf);
system("mysqlimport -iL thomas $DIR/newsxml/$outfile3");

$rc = $dbh->disconnect;

