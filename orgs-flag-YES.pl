#!/usr/bin/perl
#
# update orgs that have been flaged as isps
# file just should have orgs 
# run as ./orgs-flag-YES.pl file YY

# nohup ./orgs-flag.pl  ispsnetupdate.txt 08 & 
 
$infile   = $ARGV[0];
$year     = $ARGV[1];
if($infile eq "" || $year eq "") {print "\n\nForgot to add file and or Year YY\n\n"; exit;}
$outfile="orgs-flag.log";
 
$ADDDATE="  date>''  "; 
$ADDDATE="  date in ('0801','0802','0803','0804','0805','0806','0807')   "; 
  
# Connect to mysql database
use DBI;  
use URI::Escape;
$db          = "thomas";
$data_source = "dbi:mysql:$db:localhost";
$user        = "";
$auth        = "";  
$dbh         = DBI->connect($data_source, $user, $auth);
$unixtime    = time();
$z           = 1;  
$i           = 0;

sub updateTable
{  
  $q = $_[0];
  #print "$q\n";
  my $sth = $dbh->prepare($q);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
  $sth->finish;
  sleep(1);
}   

            
$i=0;
open(rf, "$infile")  || die (print "Could not open $infile\n");
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
while (!eof(rf))
 {
  $org = <rf>;
  chop($org);
  $org =~ s/^\s+//;
  $org =~ s/\s+$//;
  $org =~ tr/[A-Z]/[a-z]/; 
  print "$org\n";
  print wf "$org\n";
 
   # Flag table
  #  updateTable("update thomtnetlogORGflag set isp='Y' where org='$org'");
  
  # NEWS
  updateTable("update newsORGSITED$year    set isp='Y' where org='$org' and  $ADDDATE and oid>''");
  updateTable("update newsORGD$year        set isp='Y' where org='$org' and  $ADDDATE and acct>0    and oid>''");


  # TGR
  updateTable("update tgr.tgrORGSITED$year set isp='Y' where org='$org' and  $ADDDATE and oid>''");
  updateTable("update tgr.tgrORGD$year     set isp='Y' where org='$org' and  $ADDDATE and acct>0    and oid>''");
  updateTable("update tgr.tgrORGCATD$year  set isp='Y' where org='$org' and  $ADDDATE and heading>0 and oid>''");

  # NEWS
  updateTable("update newsORGSITED$year    set isp='Y' where org='$org' and  $ADDDATE and oid>''");
  updateTable("update newsORGD$year        set isp='Y' where org='$org' and  $ADDDATE and acct>0    and oid>''");
 
  # TNET
  updateTable("update tnetlogORGSITED$year set isp='Y' where org='$org' and   $ADDDATE and oid>''");
  updateTable("update tnetlogORGD$year     set isp='Y' where org='$org' and   $ADDDATE and acct>0    and oid>''");
  updateTable("update tnetlogORGCATD$year  set isp='Y' where org='$org' and   $ADDDATE and heading>0 and oid>''");

  # Visitor Tool
  updateTable("update visitor_tool set isp='Y' where org='$org'  and oid>''");
  updateTable("update visitor_cat_tool set isp='Y' where org='$org'  and oid>''");

  # Reach local
  updateTable("update Campaign_IP set isp='Y' where co='$org' and universal_id >''");

  # CATNAV
  updateTable("update catnav_ipn$year set isp='Y' where co='$org' ");

 }   
close(rf);
close(wf);
 



 



