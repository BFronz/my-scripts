#!/usr/bin/perl
#
# update orgs that have been not flaged as isps
# isp like is 'xxx%'
# run as ./orgs-flag.pl isp YY
  
$isp      = $ARGV[0];
if($isp eq "") {print "\n\nForgot to add isp \n\n"; exit;}
$outfile="orgs-flag.log";
  
$ADDDATE="  date>''  "; 
 
# Connect to mysql database
use DBI;
$dbh     = DBI->connect("", "", "");

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
 

  # CATNAV
  updateTable("update catnav_ipn11 set isp='Y' where co = '$isp' ");
 
  # NEWS
  updateTable("update  tnetlogORGN11      set isp='Y' where org = '$isp'  and  $ADDDATE and acct>0  ");
  updateTable("update  tnetlogORGCATN11   set isp='Y' where org = '$isp'  and  $ADDDATE ");
         
  # TNET             
  
  updateTable("update tnetlogORGD11_01     set isp='Y' where org = '$isp'  and    acct>0 and  $ADDDATE and oid>''");
  updateTable("update tnetlogORGD11_02     set isp='Y' where org = '$isp'  and    acct>0 and  $ADDDATE and oid>''");
 
  updateTable("update tnetlogORGSITED11_01 set isp='Y' where org = '$isp'  and   $ADDDATE and oid>''");
  updateTable("update tnetlogORGSITED11_02 set isp='Y' where org = '$isp'  and   $ADDDATE and oid>''");                                        

  updateTable("update tnetlogORGCATD11_01  set isp='Y' where org = '$isp'  and   $ADDDATE and oid>''");
  updateTable("update tnetlogORGCATD11_02  set isp='Y' where org = '$isp'  and   $ADDDATE and oid>''");    


  updateTable("update tnetlogORGCATN11   set isp='Y' where org = '$isp'  and   $ADDDATE ");
  updateTable("update  tnetlogORGN11     set isp='Y' where org = '$isp'  and   $ADDDATE ");
  
 
  # Reach local
  updateTable("update Campaign_IP set isp='Y' where co = '$isp' and universal_id >''");

   

    
close(wf);
  



 



