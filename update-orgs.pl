#!/usr/bin/perl
#
#

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

require "trd-reload.ph";

$outfile  = "tnetlogORGflag.qu";
system("rm -f $outfile");
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
  
# Get  orgs
$query  = "select trim(org) as org from thomtnetlogORGflag where (isp='N' ) and org not like '%\\'%' order by org";  
my $sth = $dbh->prepare($query);  
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {                                  
  #print "$$row[0]\n";    
  $org = $$row[0]; 
  $org =~ tr/[A-Z]/[a-z]/; 

  $isp="";
  if($org =~ /.net/ || $org =~ /pool/ || $org =~ /pppox/ || $org =~ /internet/)                     { $isp="Y"; }
  if($org =~ /broadband/ || $org =~ /network/ || $org =~ /telecom/ || $org =~ /telephone/)          { $isp="Y"; }
  if($org =~ /communications/ || $org =~ /cable/ || $org =~ /adsl/ || $org =~ /telecommunications/) { $isp="Y"; }
  if($org =~ /isp/ || $org =~ /dsl/ || $org =~ /chinanet/ || $org =~ /cablevision/)                 { $isp="Y"; }
  if($org =~ /verizon/ || $org =~ /sprint/ || $org =~ /telenet/ || $org =~ /telecomunicaciones/)    { $isp="Y"; }
  if($org =~ /wireless/ || $org =~ /skynet/ || $org =~ /vodaphone/ || $org =~ /att/)                { $isp="Y"; }
  if($org =~ /comcast/ || $org =~ /cablenet/ || $org =~ /ethernet/ || $org =~ /at&t/)               { $isp="Y"; }
  if($org =~ /qwest/  || $org =~ /service provider/  || $org =~/aol/ || $org=~ /t-mobile/)          { $isp="Y"; }
  if($org =~ /whirlpool/ )               { $isp="N"; }
   
  if ($isp eq "Y" && $org ne "") {print wf "UPDATE tnetlogORGflag SET isp='Y' WHERE org='$$row[0]' ;\n"; }

  $isp="";
 } 
$sth->finish;
   
close(wf);
 
$rc = $dbh->disconnect;

system("mysql thomas < $outfile");


