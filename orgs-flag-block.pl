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
  my $sth = $dbh->prepare($q);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
  $sth->finish;
  sleep(1);
}   

            
$i=0;
open(wf, ">>$outfile")  || die (print "Could not open $outfile\n");

  $isp =~ s/^\s+//;
  $isp =~ s/\s+$//;
  $isp =~ tr/[A-Z]/[a-z]/; 
  print "\n\n$isp\n\n";

$ORGS =" ( org = 'Industrial Quick Search' ) ";
$ORGS2 =" ( co = 'Industrial Quick Search' ) ";


$ORGS  ="  org in ('Thomas Publishing Company LLC') ";
$ORGS2 ="  co in ('Thomas Publishing Company LLC')  ";     
  
  # CATNAV 
  updateTable("update catnav_ipn".$year."_01  set block='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_02  set block='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_03  set block='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_04  set block='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_05  set block='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_06  set block='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_07  set block='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_08  set block='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_09  set block='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_10  set block='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_11  set block='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_12  set block='Y' where  $ORGS2   ");
 
 
  # NEWS 
  updateTable("update newsORGSITED$year    set block='Y' where  $ORGS   and  $ADDDATE and oid>''");
  updateTable("update newsORGD$year        set block='Y' where  $ORGS    and  $ADDDATE and acct>0    and oid>''");
  
  # TNET  
  updateTable("update  tnetlogORGSITED".$year."_01   set block='Y' where  $ORGS    and  oid>''");
  updateTable("update  tnetlogORGSITED".$year."_02   set block='Y' where  $ORGS    and  oid>''");
  updateTable("update  tnetlogORGSITED".$year."_03   set block='Y' where  $ORGS    and  oid>''");
  updateTable("update  tnetlogORGSITED".$year."_04   set block='Y' where  $ORGS    and  oid>''");
  updateTable("update  tnetlogORGSITED".$year."_05   set block='Y' where  $ORGS    and  oid>''");
  updateTable("update  tnetlogORGSITED".$year."_06   set block='Y' where  $ORGS    and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_07   set block='Y' where  $ORGS    and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_08   set block='Y' where  $ORGS    and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_09   set block='Y' where  $ORGS    and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_10   set block='Y' where  $ORGS    and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_11   set block='Y' where  $ORGS    and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_12   set block='Y' where  $ORGS    and  oid>''"); 
   
                                               
  updateTable("update  tnetlogORGD".$year."_01  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_02  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_03  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_04  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_05  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_06  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");  
  updateTable("update  tnetlogORGD".$year."_07  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_08  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_09  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_10  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_11  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_12  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");    
 

  updateTable("update tnetlogORGCATD".$year."_01    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_02    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_03    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_04    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_05    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_06    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_07    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_08    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_09    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_10    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_11    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_12    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  
  updateTable("update tnetlogORGN$year  set block='Y' where  $ORGS    and   $ADDDATE ");
  updateTable("update tnetlogORGCATN$year  set block='Y' where  $ORGS    and   $ADDDATE ");
  updateTable("delete from tnetlogADviewsServerOrg$year  where  $ORGS   ");
 
  # Reach local
  updateTable("update Campaign_IP set block='Y' where  $ORGS2   and universal_id >''");

  # news image
  updateTable("delete from adcvmaster where  $ORGS   ");

  # visitor daily
  #updateTable("update tnetlogORGdaily set block='Y'  where  $ORGS   ");
 
 
  # Visitor Tool
  #  updateTable("update visitor_tool     set block='Y' where  $ORGS     and oid>''");
  #  updateTable("update visitor_cat_tool set block='Y' where  $ORGS     and oid>''");
  

  

    
close(wf);
  

print "\nDone...\n";

 



