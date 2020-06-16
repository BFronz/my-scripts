#!/usr/bin/perl
#
# Run as ./load-site-new.pl yymm
# This adds "Email to Supplier" counts (ea) in tnetlogSITEN
# Also News stories, press rel, email colleague, links, news contacts, product catalog 
         
if($ARGV[0] eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
use POSIX;
require "/usr/wt/trd-reload.ph";
 
$year    = substr($ARGV[0], 0, 2);
$yy      = $year;
$month   = substr($ARGV[0], 2, 2);
$logtime = $year . $month ;
$month   =~ s/^0//g;
$year    = "20" . $year ;

 
# Get unixtime for begin of month
$sec   =  0;
$min   =  0;
$hour  =  0;
$day   =  1;
$mon   = $month   - 1;
$yyear = $year - 1900;
$wday  = 0;
$yday  = 0;
$start =  mktime($sec, $min, $hour, $day, $mon, $yyear, $wday,0,-1);
#print "$start\n";
#$readable_time = localtime($start);
#print "$readable_time\n";

# Get unixtime for end of month
$day=31;
if($month==9 || $month==4 || $month==6 || $month==11  ) {   $day = 30; }
if ($month==2) {$day=28; }
$sec   =  59;
$min   =  59;
$hour  =  23;
$mon   = $month   - 1;
$yyear = $year - 1900;
$wday  = 0;
$yday  = 0; 
$end   =  mktime($sec, $min, $hour, $day, $mon, $yyear, $wday,0,-1);
#print "$end\n";
#$readable_time = localtime($end);
#print "$readable_time\n";

# Get contact counts  
$query = " select count(*) from tgrams.contacts where (created>=$start and created<=$end) and  notsent < 1 and test_msg!=1 and other!=50 and sell!=50   ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {   $contact_count = $$row[0];     }
$sth->finish; 
 

 
#new 
$query = " update thomtnetlogSITEN set ea='$contact_count' ";
$query .= "where date='$logtime' "; 
  

   
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
$sth->finish;
  
## Disconnect from thomas database
$rc = $dbh->disconnect;


 

