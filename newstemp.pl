#!/usr/bin/perl
#


use Digest::MD5 qw(md5 md5_hex md5_base64);

require "trd-reload.ph";


use DBI;
$dbh      = DBI->connect("", "", "");

$yy="00";

# Get bad and isp orgs - only need bad now
$query  = "select trim(org) as org, isp, block from thomtnetlogORGflag where ( isp='Y' || block='Y' ) and org>'' order by org ";
$query  = "SELECT org  FROM thomtnetlogORGflag WHERE block='Y'  AND org>''  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $$row[0] =~ s/^\s+//;
  $$row[0] =~ s/\s+$//;
  $$row[0] =~ tr/[A-Z]/[a-z]/;
  #if($$row[1] eq "Y") { $isporg{$$row[0]} = $$row[0]; }
  $badorg{$$row[0]} = $$row[0];
 }
$sth->finish;

# extra isp flag
$query  = "SELECT trim(org)  FROM thomtnetlogORGflagExtra WHERE org>'' and created<=1391717153  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $$row[0] =~ tr/[A-Z]/[a-z]/;
  $isporg{$$row[0]} = $$row[0];
 }
$sth->finish;


#$file   = "news_advOrgVisitsDrill";
$file   = "news_advOrgVisitsDrillCov";
$infile = 2014 . "/" . $file . "-" . 1404 . ".txt";

# delete from tables
$query = "DELETE FROM thomnewsORGD00 WHERE date='$fdate'";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

$query = "DELETE FROM thomnewsORGD_temp  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

#open(wf,  ">newsORGD_temp.txt")  || die (print "Could not open newsORGD_temp\n");
open(wf,  ">newsORGD00.txt")  || die (print "newsORGD00.txt\n");
print "$infile\n";
open(rf, "$infile")  || die (print "Could not open $infile\n");
while (!eof(rf))
  {
    $instr = <rf>;
    chop($instr);
    ($date,$acct,$org,$cnt,$dom,$city, $state, $zip, $isp, $ip, $naics, $country, $primary_sic, $countrycode, $duns_number, $domestichqdunsnumber, $hqdunsnumber, $gltdunsnumber, $countrycode3, $audience, $audiencesegment, $b2b, $employee_range, $forbes2k, $fortune1k, $industry, $informationlevel, $latitude, $longitude, $phone, $revenue_range, $subindustry, $cov)  = split(/\t/, $instr);

    $org                   = &CleanOrg($org);
    $dom                   = &CleanFlds("dom",$dom);
    $city                  = &CleanFlds("city",$city);
    $state                 = &CleanFlds("state",$state);
    $zip                   = &CleanFlds("zip",$zip);
    $ip                    = &CleanFlds("ip",$ip);
    $naics                 = &CleanFlds("naics",$naics);
    $country               = &CleanFlds("country",$country);
    $primary_sic           = &CleanFlds("primary_sic",$primary_sic);
    $countrycode           = &CleanFlds("countrycode",$countrycode);
    $duns_number           = &CleanFlds("duns_number", $duns_number);
    $domestichqdunsnumber  = &CleanFlds("domestichqdunsnumber", $domestichqdunsnumber);
    $hqdunsnumber          = &CleanFlds("hqdunsnumber", $hqdunsnumber);
    $gltdunsnumber         = &CleanFlds("gltdunsnumber", $gltdunsnumber);
    $countrycode           = &CleanFlds("countrycode", $countrycode);
    $country               = &CleanFlds("country", $country);
    $audience              = &CleanFlds("audience", $audience);
    $audiencesegment       = &CleanFlds("audiencesegment", $audiencesegment);
    $b2b                   = &CleanFlds("b2b", $b2b);
    $employee_range        = &CleanFlds("employee_range", $employee_range);
    $forbes2k              = &CleanFlds("forbes2k", $forbes2k);
    $fortune1k             = &CleanFlds("fortune1k", $fortune1k);
    $industry              = &CleanFlds("industry", $industry);
    $informationlevel      = &CleanFlds("informationlevel", $informationlevel);
    $latitude              = &CleanFlds("latitude", $latitude);
    $longitude             = &CleanFlds("longitude", $longitude);
    $phone                 = &CleanFlds("phone", $phone);
    $revenue_range         = &CleanFlds("revenue_range", $revenue_range);
    $subindustry           = &CleanFlds("subindustry", $subindustry);
    $cov                   = &CleanFlds("cov", $cov);

  
    if($isp eq "Company")        { $isp="N";   } else { $isp="Y"; }
    if($isporg{$org}  ne "")     { $isp="Y"; }
    if($badorg{$org} ne "")      { $block="Y"; } else { $block="N"; }

    $orgid = "$date$acct$org$dom$countrycode$city$state$zip$cov";
    $orgid  =  md5_hex($orgid);
    $orgmd5 =  md5_hex($org);


    if($org ne "?"  &&  $org ne ""  &&  $org ne "#NAME?"  &&  $org ne "unknown"  &&  $org ne "-" && $block ne "Y" && $org ne "no company") {
     #if($instr !~ /[^\x00-\x7e]/) {
      print wf "$date\t$acct\t$org\t$dom\t$country\t$city\t$state\t$zip\t$cnt\t$isp\t$block\t$orgid\t$orgmd5\t$ip\t$naics\t$primary_sic\t$countrycode\t$duns_number\t$domestichqdunsnumber\t$hqdunsnumber\t$gltdunsnumber\t$countrycode3\t$audience\t$audiencesegment\t$b2b\t$employee_range\t$forbes2k\t$fortune1k\t$industry\t$informationlevel\t$latitude\t$longitude\t$phone\t$revenue_range\t$subindustry\t$cov\n";
     #}
    }

    $date = $acct = $org = $dom = $country = $city = $state = $zip = $cnt = $orgid = $ip = $naics = $primary_sic = $countrycode = $orgmd5  = "";
    $duns_number=$domestichqdunsnumber=$hqdunsnumber=$gltdunsnumber=$countrycode3=$country=$audience=$audiencesegment="";
    $b2b=$employee_range=$forbes2k=$fortune1k=$industry=$informationlevel=$latitude=$longitude=$phone=$revenue_range=$subindustry=$cov=""
  }
close(rf);
 
close(wf);
system("mysqlimport thomas  newsORGD00.txt");

 

# check rec counts
$query  = "SELECT count(*)  FROM  newsORGD00 WHERE date='$fdate' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
if (my $row = $sth->fetchrow_arrayref)
 {
  print "\nCount from  newsORGD00: $$row[0]\n\n";
 }
$sth->finish;

print "\n\nProcessing complete.\nCheck for errors.\n\n";

$rc = $dbh->disconnect;

exit;





