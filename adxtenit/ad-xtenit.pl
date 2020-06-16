#!/usr/bin/perl
#
# Pulls all records from Xtenit 
# Run this first

$sd   = $ARGV[0];
$ed   = $ARGV[1];
if($sd eq "" || $ed eq "") {print "\n\nMissing dates!!!\n\n"; exit;}

use DBI;
use POSIX;
#use strict;
#use warnings;
use Text::ParseWords;

require "/usr/wt/trd-reload.ph";

$objectlass = 'person';
$suffix     = 'dc=my organization, dc=com'; 
$xmluname   = "inr-admin\@tnt.com";
$xmlpw      = "a9xjbV7h";
$host       = "https://tnet.m.xtenit.com/webaccess/AdReport";
$curl_extra = " --insecure  ";

$outfile    = "ad_xtenit_data.txt";
$outfile    = "ad_xtenit_data.xml";
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");

my $readable_time = localtime(time());
#print "\nStart: $readable_time\n";

# gets all active records
$data  = "<request >";
$data .= "<type>Active</type>";
$data .= "</request>"; 
#$data="";

# gets all records
$data  = "<request >";
$data .= "<type>All</type>";
$data .= "</request>";
  
$cmd = " $curl_extra -s -d \"username=$xmluname\" ";
$cmd .= "-d \"passwd=$xmlpw\"  ";
$cmd .= "-d \"xml=$data\" ";
$cmd .= "-d \"appid=334\" ";
$cmd .= "-d \"subscriberswhoclicked=true\" ";
$cmd .= "-d \"userclickdata=true\" ";
$cmd .= "-d \"resulttype=xml\" ";
$cmd .= "-d \"sd=$sd\" ";
$cmd .= "-d \"ed=$ed\" ";

$cmd .= "-d \"showemails=true\" ";
$cmd .= "-d \"showemailsbyplc=true\" "; 

$cmd .= "-d \"submit=submit\"  ";
$cmd .= "$host";   
#$cmd .= "-d \"email=\" ";
#$cmd .= "-d \"code=\"99 ";
#$cmd .= "-d \"evlcnts=\"true ";
#$cmd .= "-d \"raw=on\" ";
#$cmd .= "-d \"resulttype=CSV\" ";
 
print "\nCMD: curl $cmd\n\n";
  
@lines = `curl  $cmd`;
foreach $lines (@lines) { 
   print wf "$lines";      
   $i++; 
   #if ($i % 100 == 0) { print "$i\r"; }
}
undef(@lines);
 
close(wf);

my $readable_time = localtime(time());
#print "\nEnd: $readable_time\n";
 
