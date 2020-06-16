#!/usr/bin/perl
#
# 
 
$infile="webcross.txt";
$outfile="irdata_new.txt";
  
use DBI;
$dbh      = DBI->connect("", "", "");

# Get bad and isp orgs 
$query  = "SELECT trim(org) AS org, isp, block FROM thomtnetlogORGflag WHERE ( isp='Y' || block='Y' ) AND org>'' ORDER BY org ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $$row[0] =~ s/^\s+//;
  $$row[0] =~ s/\s+$//;
  $$row[0] =~ tr/[A-Z]/[a-z]/; 
  if($$row[1] eq "Y") { $isporg{$$row[0]} = $$row[0]; }
  if($$row[2] eq "Y") { $badorg{$$row[0]} = $$row[0]; }
 }
$sth->finish;
     
open(wf, ">$outfile") || die (print "Could not open $outfile\n");
open(rf, "$infile")   || die (print "Could not open $infile\n");
while (!eof(rf))
  {
    $instr = <rf>;
    chop($instr);  
    ($ProfileSiteKey,$yearmonth,$cid,$cust_name,$org,$city,$state,$country,$HeadingName,$LinkType,$clickthroughtime,$InitialVisitTime) = split(/\t/, $instr);
 
    $org =~ s/^\s+//;
    $org =~ s/\s+$//; 
    $org =~ tr/[A-Z]/[a-z]/;
    $isp="N";
    $block="N";
    if($isporg{$org} ne "" ){ $isp="Y"; } 
    if($badorg{$org} ne "" ){ $block="Y"; } 

    if($org =~ /.net/ || $org =~ /pool/ || $org =~ /pppox/ || $org =~ /internet/)                     { $isp="Y"; }
    if($org =~ /broadband/ || $org =~ /network/ || $org =~ /telecom/ || $org =~ /telephone/)          { $isp="Y"; }
    if($org =~ /communications/ || $org =~ /cable/ || $org =~ /adsl/ || $org =~ /telecommunications/) { $isp="Y"; }
    if($org =~ /isp/ || $org =~ /dsl/ || $org =~ /chinanet/ || $org =~ /cablevision/)                 { $isp="Y"; }
    if($org =~ /verizon/ || $org =~ /sprint/ || $org =~ /telenet/ || $org =~ /telecomunicaciones/)    { $isp="Y"; }
    if($org =~ /wireless/ || $org =~ /skynet/ || $org =~ /vodaphone/ || $org =~ /att/)                { $isp="Y"; }
    if($org =~ /comcast/ || $org =~ /cablenet/ || $org =~ /ethernet/ || $org =~ /at&t/)               { $isp="Y"; }
    if($org =~ /qwest/  || $org =~ /service provider/ )                                               { $isp="Y"; }
    if($org =~ /whirlpool/ )                                                                          { $isp="N"; }

  
    if($isp ne "Y" && block ne "Y"){
    print wf "$ProfileSiteKey\t$yearmonth\t$cid\t$cust_name\t$org\t$city\t$state\t$country\t$HeadingName\t$LinkType\t$clickthroughtime\t$InitialVisitTime\n";
    } 
 
  }   
close(rf);
close(wf);
#system("mysql thomas < tnetlogORGSITED_temp.txt");   
   
print "\n\nDone...\n\n";

exit;
 




