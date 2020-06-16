#!/usr/bin/perl
#  

         
if($ARGV[0] eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}
 
$year    = substr($ARGV[0], 0, 2);
$yy      = $year;
$month   = substr($ARGV[0], 2, 2);
$logtime = $year . $month ;
$month   =~ s/^0//g;
$year    = "20" . $year ;

use DBI;
use POSIX;

# Connect to tgrams database
$db   = "tgrams";
$data_source = "";
$user = "";
$auth = "";
$dbh  = DBI->connect($data_source, $user, $auth);
 
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


# Get prod catalog counts   
$query = "  select sum(pc) from thomtnetlogARTU$yy   where acct>0 and date='$logtime' and covflag='t'  ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
  $prodcat_count = $$row[0];     
 } 
$sth->finish; 

 
$query = " update thomtnetlogSITEN set cv='$prodcat_count'  where date='$logtime' "; 
print "CHECK THEN RUN THIS MANUALLY:";
print "\n\nQUERY: $query\n\n";   
#my $sth = $dbh->prepare($query); 
#if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
#$sth->finish;
  
## Disconnect from thomas database
$rc = $dbh->disconnect;


 

