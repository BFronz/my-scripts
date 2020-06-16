#!/usr/bin/perl
#
# update orgs that have been not flaged as isps
# isp like is 'xxx%'
# run as ./orgs-flag-like.pl YY
   

$year     = $ARGV[0];
#$isp="africa online";
if($year eq "") {print "\n\nForgot to add isp and or Year YY\n\n"; exit;}
$outfile="orgs-flag.log";
  
$ADDDATE="  date>''  "; 
 
# Connect to mysql database
use DBI;
$dbh      = DBI->connect("", "", "");

$unixtime    = time();
$z           = 1;  
$i           = 0;

sub updateTable
{  
  $q = $_[0];
  print "$q\n"; 
  print "-----------\n";
  my $sth = $dbh->prepare($q);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
  $sth->finish;
  sleep(1);
}   
 
$ORGS =" ( org like '1 800%' ||
 org like '1 dupont%' ||
 org like '1 source%' ||
 org like '1001%' ||
 org like '101%' ||
 org like '10th%' ||
 org like '93 FINANCIAL GROUP%' ||
 org like '1st%' ||
 org like '2nd%' ||
 org like '4th%' ||
 org like '5th%' ||
 org like '6th%' ||
 org like '7th%' ||
 org like '8th%' ||
 org like '9th%' ||
 org like '5 star%' ||
 org like '4 H%' ||
 org like '2m%' ||
 org like '21st%' ||
 org like '754th electronic systems%' ||
 org like '202488 - tr fastenings%' ||
 org like '15b 53 55%' ||
 org like '18-3226946_imperial appliance%' ||
 org like '18-3260990_rcll trading corporation%' ||
 org like '220 conover st resturant%' ||
 org like '84 lumber company%' ||
 org like '502-5431-duke-energy%' ||
 org like '2c Design Studio%' ||
 org like '220 Labs%' ||
 org like '4c technologies%' ||
 org like 'world tech. corporation%' ||
 org like '2-5162926_thermopower%' ||
 org like '2-8361155_lucky dragon gaming station%' ||
 org like '23rd century marketing group%' ||
 org like '8-3398084_best electronics co%'
) ";

$ORGS2 =" ( co like '1 800%' ||
 co like '1 dupont%' ||
 co like '1 source%' ||
 co like '1001%' ||
 co like '101%' ||
 co like '10th%' ||
 co like '93 FINANCIAL GROUP%' ||
 co like '1st%' ||
 co like '2nd%' ||
 co like '4th%' ||
 co like '5th%' ||
 co like '6th%' ||
 co like '7th%' ||
 co like '8th%' ||
 co like '9th%' ||
 co like '5 star%' ||
 co like '4 H%' ||
 co like '2m%' ||
 co like '21st%' ||
 co like '754th electronic systems%' ||
 co like '202488 - tr fastenings%' ||
 co like '15b 53 55%' ||
 co like '18-3226946_imperial appliance%' ||
 co like '18-3260990_rcll trading corporation%' ||
 co like '220 conover st resturant%' ||
 co like '84 lumber company%' ||
 co like '502-5431-duke-energy%' ||
 co like '2c Design Studio%' ||
 co like '220 Labs%' ||
 co like '4c technologies%' ||
 co like 'world tech. corporation%' ||
 co like '2-5162926_thermopower%' ||
 co like '2-8361155_lucky dragon gaming station%' ||
 co like '23rd century marketing group%' ||
 co like '8-3398084_best electronics co%'
) ";

            
$i=0;
open(wf, ">>$outfile")  || die (print "Could not open $outfile\n");

  $isp =~ s/^\s+//;
  $isp =~ s/\s+$//;
  $isp =~ tr/[A-Z]/[a-z]/; 
  print "\n\n$isp\n\n";
 

  # CATNAV
  updateTable("update catnav_ipn$year set isp='N' where $ORGS2 ");
 
  # NEWS
  updateTable("update newsORGSITED$year    set isp='N' where $ORGS  and  $ADDDATE and oid>''");
  updateTable("update newsORGD$year        set isp='N' where $ORGS  and  $ADDDATE and acct>0    and oid>''");
  
  # TNET  
  updateTable("update  tnetlogORGSITED".$year."_01   set isp='N' where $ORGS  and  oid>''");
  updateTable("update  tnetlogORGSITED".$year."_02   set isp='N' where $ORGS  and  oid>''");
  updateTable("update  tnetlogORGSITED".$year."_03   set isp='N' where $ORGS  and  oid>''");
  updateTable("update  tnetlogORGSITED".$year."_04   set isp='N' where $ORGS  and  oid>''");
  updateTable("update  tnetlogORGSITED".$year."_05   set isp='N' where $ORGS  and  oid>''");
  updateTable("update  tnetlogORGSITED".$year."_06   set isp='N' where $ORGS  and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_07   set isp='N' where $ORGS  and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_08   set isp='N' where $ORGS  and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_09   set isp='N' where $ORGS  and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_10   set isp='N' where $ORGS  and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_11   set isp='N' where $ORGS  and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_12   set isp='N' where $ORGS  and  oid>''"); 
   
                                               
  updateTable("update  tnetlogORGD".$year."_01  set isp='N' where $ORGS  and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_02  set isp='N' where $ORGS  and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_03  set isp='N' where $ORGS  and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_04  set isp='N' where $ORGS  and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_05  set isp='N' where $ORGS  and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_06  set isp='N' where $ORGS  and   $ADDDATE and acct>0    and oid>''");  
  updateTable("update  tnetlogORGD".$year."_07  set isp='N' where $ORGS  and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_08  set isp='N' where $ORGS  and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_09  set isp='N' where $ORGS  and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_10  set isp='N' where $ORGS  and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_11  set isp='N' where $ORGS  and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_12  set isp='N' where $ORGS  and   $ADDDATE and acct>0    and oid>''");    
 

  updateTable("update tnetlogORGCATD".$year."_01    set isp='N' where $ORGS  and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_02    set isp='N' where $ORGS  and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_03    set isp='N' where $ORGS  and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_04    set isp='N' where $ORGS  and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_05    set isp='N' where $ORGS  and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_06    set isp='N' where $ORGS  and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_07    set isp='N' where $ORGS  and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_08    set isp='N' where $ORGS  and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_09    set isp='N' where $ORGS  and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_10    set isp='N' where $ORGS  and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_11    set isp='N' where $ORGS  and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_12    set isp='N' where $ORGS  and   $ADDDATE and heading>0 and oid>''");
  
  updateTable("update tnetlogORGN$year  set isp='N' where $ORGS  and   $ADDDATE ");
  updateTable("update tnetlogORGCATN$year  set isp='N' where $ORGS  and   $ADDDATE ");
 
   # Reach local
  updateTable("update Campaign_IP set isp='N' where co like $ORGS2 and universal_id >''");
 
   # visitor daily
  updateTable("update tnetlogORGdaily set isp='N'  where $ORGS");
 
  

  

    
close(wf);
  



 



