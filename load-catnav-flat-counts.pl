#!/usr/bin/perl
#
#  Updates  E-mail Sent to You in flat catnav table
 
  
$fdate = $ARGV[0];

if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI; 
use POSIX;
require "/usr/wt/trd-reload.ph";

$year    = substr($fdate, 0, 2);
$yy      = $year  ;
$month   = substr($fdate, 2, 2);
$outfile = "catnav-flat-contacts-update.txt"; 

$month =~ s/^0//g;
$year  = "20" . $year ;


#print "$year, $yy, $month";
 
# Set counts to 0
$query = "update thomflat_catnav_summmary$yy set totalinq=0 where date='$fdate'  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

 
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
print "$start\n";
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
print "$end\n";
#$readable_time = localtime($end);
#print "$readable_time\n";
 

### get accounts and counts (total)
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
$query = "select acct, count(*) as n from tgrams.contacts where (created>=$start and created<=$end) and  notsent < 1 and test_msg!=1 and other!=50 and sell!=50 
and  origin='catnav' group by acct  ";
print "\n$query\n\n";
$i=0;
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {    
     $acct   = $$row[0]; 
     $cnt    = $$row[1];  
     print wf "update thomflat_catnav_summmary$yy  set  totalinq=$cnt where tgramsid=$acct and date='$fdate' ;\n";
 }  
$sth->finish; 
close(wf);




  
# Update
system("mysql thomas < $DIR/$outfile");
  
$rc = $dbh->disconnect;
 



