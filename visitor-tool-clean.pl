#!/usr/bin/perl
#

use DBI;
$dbh      = DBI->connect("", "", "");
 
$infile = "visitor_tool.bak";
   
$outfilen = "visitor_tool";
$outfile  =  $outfilen . "1.txt";
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");

$query  = "SELECT trim(org) AS org FROM thomtnetlogORGflag WHERE ( isp='Y' || block='Y' ) ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {  
  $$row[0] =~ s/^\s+//;
  $$row[0] =~ s/\s+$//;
  $$row[0] =~ tr/[A-Z]/[a-z]/;
  $badorg{$$row[0]} = $$row[0];
 }
$sth->finish;

$query  = "SELECT trim(org)  FROM thomtnetlogORGflagExtra WHERE org>''  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $$row[0] =~ s/^\s+//;
  $$row[0] =~ s/\s+$//;
  $$row[0] =~ tr/[A-Z]/[a-z]/;
  $badorg{$$row[0]} = $$row[0];
 }
$sth->finish;

   
$ip = $naics = $primary_sic = $countrycode = $country = ""; 
$i = 1;
open(rf, "$infile")  || die (print "Could not open $infile\n");
while (!eof(rf))
{
 $line = <rf>;
 chop($line);
 ($org,$domain,$city,$state,$zip,$isp,$block,$ocleanname,$dcleanname,$orgid,$oid,$checked) = split(/\t/, $line); 
  
 if($i eq 1000000)  { close(wf);  $outfile = $outfilen . $i . ".txt";  open(wf, ">$outfile")  || die (print "Could not open $outfile\n"); }
 if($i eq 2000000)  { close(wf);  $outfile = $outfilen . $i . ".txt";  open(wf, ">$outfile")  || die (print "Could not open $outfile\n"); }
 if($i eq 3000000)  { close(wf);  $outfile = $outfilen . $i . ".txt";  open(wf, ">$outfile")  || die (print "Could not open $outfile\n"); }
 if($i eq 4000000)  { close(wf);  $outfile = $outfilen . $i . ".txt";  open(wf, ">$outfile")  || die (print "Could not open $outfile\n"); }
 if($i eq 5000000)  { close(wf);  $outfile = $outfilen . $i . ".txt";  open(wf, ">$outfile")  || die (print "Could not open $outfile\n"); }
 if($i eq 6000000)  { close(wf);  $outfile = $outfilen . $i . ".txt";  open(wf, ">$outfile")  || die (print "Could not open $outfile\n"); }
 if($i eq 7000000)  { close(wf);  $outfile = $outfilen . $i . ".txt";  open(wf, ">$outfile")  || die (print "Could not open $outfile\n"); }
 if($i eq 8000000)  { close(wf);  $outfile = $outfilen . $i . ".txt";  open(wf, ">$outfile")  || die (print "Could not open $outfile\n"); }
 if($i eq 9000000)  { close(wf);  $outfile = $outfilen . $i . ".txt";  open(wf, ">$outfile")  || die (print "Could not open $outfile\n"); }
 if($i eq 10000000) { close(wf);  $outfile = $outfilen . $i . ".txt";  open(wf, ">$outfile")  || die (print "Could not open $outfile\n"); }
 if($i eq 11000000) { close(wf);  $outfile = $outfilen . $i . ".txt";  open(wf, ">$outfile")  || die (print "Could not open $outfile\n"); }
 if($i eq 12000000) { close(wf);  $outfile = $outfilen . $i . ".txt";  open(wf, ">$outfile")  || die (print "Could not open $outfile\n"); }
 if($i eq 13000000) { close(wf);  $outfile = $outfilen . $i . ".txt";  open(wf, ">$outfile")  || die (print "Could not open $outfile\n"); }
        
 $stop = "N"; 
 if($org =~ /.net/ || $org =~ /pool/ || $org =~ /pppox/ || $org =~ /internet/)                     { $stop="Y"; }      
 if($org =~ /broadband/ || $org =~ /network/ || $org =~ /telecom/ || $org =~ /telephone/)          { $stop="Y"; }      
 if($org =~ /communications/ || $org =~ /cable/ || $org =~ /adsl/ || $org =~ /telecommunications/) { $stop="Y"; }      
 if($org =~ /stop/ || $org =~ /dsl/ || $org =~ /chinanet/ || $org =~ /cablevision/)                { $stop="Y"; }      
 if($org =~ /verizon/ || $org =~ /sprint/ || $org =~ /telenet/ || $org =~ /telecomunicaciones/)    { $stop="Y"; }      
 if($org =~ /wireless/ || $org =~ /skynet/ || $org =~ /vodaphone/ || $org =~ /att/)                { $stop="Y"; }      
 if($org =~ /comcast/ || $org =~ /cablenet/ || $org =~ /ethernet/ || $org =~ /at&t/)               { $stop="Y"; }      
 if($org =~ /qwest/  || $org =~ /service provider/  || $org =~/aol/ || $org=~ /t-mobile/)          { $stop="Y"; }      
 if($org =~ /whirlpool/ )                                                                          { $stop="N"; }                                     
 
 if($isp eq "Y" || $block eq "Y")  {  $stop="Y";  }

 if($org eq "?" || $org eq "" || $org eq "#NAME?" || $org eq "unknown" || $org eq "-" ||  $org eq "no company") {  $stop="Y";  }  
  
 if($badorg{$$row[0]} ne "") {  $stop="Y"; }
 
 if($stop eq "N") 
 {          #org,  domain,  city,  state,  zip,  ocleanname,  dcleanname, orgid,  oid,  checked,  ip,  naics,  primary_sic,  countrycode,   country         
  print wf "$org\t$domain\t$city\t$state\t$zip\t$ocleanname\t$dcleanname\t$orgid\t$oid\t$checked\t$ip\t$naics\t$primary_sic\t$countrycode\t$country\n";
 }  
 print "$i\t$org\t$stop\n";

 $i++;
}   

close(rf);
close(wf);

print "\nDone...\n";


 



