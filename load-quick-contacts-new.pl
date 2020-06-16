#!/usr/bin/perl
#
# Run as ./load-quick-contacts.pl yymm 
# This adds "Email to Supplier" counts (ea) in quick log

if($ARGV[0] eq "" ){
print "\nMissing date yymm\n";
exit;
}

use DBI;
use POSIX;
require "/usr/wt/trd-reload.ph";

$year    =  substr($ARGV[0], 0, 2);
$month   =  substr($ARGV[0], 2, 2);
$log     = "thom" . "qlog" . $year . "Y";  
   
if($month==1  || $month==2  || $month==3) { $table = "quicklog" . $year . "Q" . 1; }
if($month==4  || $month==5  || $month==6) { $table = "quicklog" . $year . "Q" . 2; }
if($month==7  || $month==8  || $month==9) { $table = "quicklog" . $year . "Q" . 3; }
if($month==10 || $month==11 || $month==12){ $table = "quicklog" . $year . "Q" . 4; }

$outfile =  "qlog" . $year . "Y" . ".txt";

system("rm -f  $DIR/$outfile");

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
 
 
# Update contact table
$query = " update tgrams.contacts set ccovarea='NA' where ccovarea='' "; 
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
$sth->finish;
  
## Set email counts in qlog{yy}Y to 0 
$query = " update $log set em=0 where date='$logtime' and acct>0 and heading>0 and covflag>'' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish; 

 
# Get contact counts and print out updates for coverage
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
$query = " select acct, heading,ccovarea, count(*) from tgrams.contacts where (created>=$start and created<=$end) and  notsent < 1 and test_msg!=1 and other!=50 and  sell!=50 ";
$query .= " and heading>0  and ccovarea>'' group by acct,heading, ccovarea";

my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {  
    $act=""; $hd=""; $cov=""; $cnt="";
    $$row[0] =~ s/\s+$//;
    $$row[0]=~ s/^\s+//;
    $$row[1] =~ s/\s+$//;
    $$row[1]=~ s/^\s+//;
    $$row[2] =~ s/\s+$//;
    $$row[2]=~ s/^\s+//;
    $$row[3] =~ s/\s+$//;
    $$row[3]=~ s/^\s+//;
    $act = $$row[0];
    $hd  = $$row[1];
    $cov = $$row[2];
    $cnt = $$row[3];
    if($cov eq "NA"){$cov="n";}
    print wf "update $log set em=$cnt where date='$logtime' and acct=$act and heading=$hd and covflag='$cov';\n";    
 }  
$sth->finish; 
 
# Get contact counts and print out updates for total (t)
$query = " select acct, heading, count(*) from tgrams.contacts where (created>=$start and created<=$end) and  notsent < 1 and test_msg!=1 and other!=50 and sell!=50 ";
$query .= " and heading>0  and ccovarea>'' group by acct, heading ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {  
    $act=""; $hd=""; $cov=""; $cnt="";
    $$row[0] =~ s/\s+$//;
    $$row[0]=~ s/^\s+//;
    $$row[1] =~ s/\s+$//;
    $$row[1]=~ s/^\s+//;
    $$row[2] =~ s/\s+$//;
    $$row[2]=~ s/^\s+//;
    $act = $$row[0];
    $hd  = $$row[1];
    $cnt = $$row[2];
    $cov = "t"; 
    print wf "update $log set em=$cnt where date='$logtime' and acct=$act and heading=$hd and covflag='$cov';\n";    
 }
$sth->finish; 

close(wf);
 
# Disconnect from tgrams database
$rc = $dbh->disconnect;
 
system("mysql thomas < $DIR/$outfile");

 

