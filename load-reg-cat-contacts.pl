#!/usr/bin/perl
#
# Run as ./load-reg-contacts yymm 
# This adds "Email to Supplier" counts (ca) to tnetlogREG{YY}

if($ARGV[0] eq "" ){ print "\nMissing date yymm\n";  exit; }

use DBI;
use POSIX;
require "/usr/wt/trd-reload.ph";


$year    =  substr($ARGV[0], 0, 2);
$month   =  substr($ARGV[0], 2, 2);
$log     = "thomtnetlogREGCAT" . $year ;  
$outfile =  $log . ".txt";   
$logtime = $year . $month ;
$month   =~ s/^0//g;
$year    = "20" . $year ;

system("rm -f  $outfile");

 
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
 
 
# Set counts to 0
$query = "update $log set ca=0 where date='$logtime'  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

# Get contact counts and print out updates for coverage
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
$query  = " select acct, tinid, heading, count(*) from tgrams.contacts ";
$query .= " where (created>=$start and created<=$end) and id>0 and acct>0 and notsent<1 and tinid>'' and heading>0 and test_msg!=1 and other!=50 and sell!=50  ";
$query .= " group by acct, tinid, heading"; 
my $sth = $dbh->prepare($query);  
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {   
    $$row[0] =~ s/\s+$//;
    $$row[0]=~ s/^\s+//;
    $$row[1] =~ s/\s+$//;
    $$row[1]=~ s/^\s+//;

    $act   = $$row[0];
    $tinid = $$row[1];
    $hd    = $$row[2]; 
    $cnt   = $$row[3];
  
  
    print wf "update $log set ca='$cnt' where date='$logtime' and acct='$act' and tinid='$tinid' and heading='$hd' ;\n";    
    $act = $tinid = $cnt = "";
    $j++;
 } 
$sth->finish; 
 
close(wf);
 
# Disconnect from tgrams database
$rc = $dbh->disconnect;
  
system("mysql thomas < $outfile");

 
#print "\n\nTotal Contact Updates: $j\n\n";
