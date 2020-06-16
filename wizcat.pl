#!/usr/bin/perl
#


use Digest::MD5 qw(md5 md5_hex md5_base64);

$fdate   = $ARGV[0];
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

require "trd-reload.ph";

$fyear     = "20" . substr($fdate, 0, 2);
$yy        =  substr($fdate, 0, 2);
$mm        =  substr($fdate, 2, 2);
$table     = "tnetlogORGCATD" . $yy . "_" . $mm . "W";
$tablefile = $table . ".txt";
$file      = "OrgVisitsCatDrillCovNew";
$infile    = $fyear . "/" . $file . "-" . $fdate . ".txt";
 
use DBI;
$dbh      = DBI->connect("", "", "");

# Get bad and isp orgs - only need bad now
$query  = "SELECT orgblock FROM thomtnetlogORGflagBLOCK   WHERE orgblock>'' ";
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
 
# extra isp flag
$query  = "SELECT trim(org)  FROM thomtnetlogORGflagExtra WHERE org>''  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $$row[0] =~ tr/[A-Z]/[a-z]/;
  $isporg{$$row[0]} = $$row[0];
 }
$sth->finish;


$query  = "SELECT trim(org)  FROM thomtnetlogORGflag WHERE org>'' AND isp='Y' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $$row[0] =~ tr/[A-Z]/[a-z]/;
  $isporg{$$row[0]} = $$row[0];
 }
$sth->finish;


# delete
$query  = "DELETE FROM $table ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
 
$query  = "alter table $table  change longitude longitude  double(16,4) NOT NULL default '0.0000' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
 
$query  = "alter table $table change latitude latitude  double(16,4) NOT NULL default '0.0000'; ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
 

$query  = "DELETE FROM thomtnetlogORGCATD_temp";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;




#open(wf, ">tnetlogORGCATD_temp.txt")  || die (print "Could not open $outfile\n");
open(wf, ">$tablefile")  || die (print "$tablefile\n");
print "$infile\n";
open(rf, "$infile")  || die (print "Could not open $infile\n");
while (!eof(rf))
  { 
    $instr = <rf>;
    chop($instr); 
     ($date,$acct,$org,$cnt,$heading,$dom,$city, $state, $zip, $isp, $ip, $naics, $country, $primary_sic, $countrycode,$duns_number, $domestichqdunsnumber, $hqdunsnumber, $gltdunsnumber, $countrycode3, $audience, $audiencesegment, $b2b, $employee_range, $forbes2k, $fortune1k, $industry, $informationlevel, $latitude, $longitude, $phone, $revenue_range, $subindustry, $cov)  = split(/\t/, $instr);
     #print "$instr\ndate:$date\norg:$org\ncnt:$cnt\nhead:$heading\ndom:$dom\ncity:$city\nstate:$state\nzip:$zip\nisp:$isp\nip:$ip\n";
     #print "acct:$acct\nduns_number:$duns_number\ndomestichqdunsnumber:$domestichqdunsnumber\nhqdunsnumber:$hqdunsnumber\ngltdunsnumber:$gltdunsnumber\n";
     #print "countrycode:$countrycode\ncountry:$country\naudience:$audience\naudiencesegment:$audiencesegment\nb2b:$b2b\n";
     #print "employee_range:$employee_range\nforbes2k:$forbes2k\nfortune1k:$fortune1k\nindustry:$industry\ninformationlevel$informationlevel\n";
     #print "latitude:$latitude\nlongitude:$longitude\nphone:$phone\nrevenue_range:$revenue_range\nsubindustry:$subindustry\n----------\n";
 

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
    $acct                  = &CleanFlds("acct", $acct);
    if($cov eq "") {$cov="NA";}

 
    if($isp eq "Company")        { $isp="N";   } else { $isp="Y"; }
    if($isporg{$org}  ne "")     { $isp="Y"; } 
    if($badorg{$org} ne "")      { $block="Y"; } else { $block="N"; }

    $orgid  = "$date$acct$heading$org$dom$countrycode$city$state$zip$cov";
    $orgid  =  md5_hex($orgid);
    $orgmd5 =  md5_hex($org);

    if($org ne "?"  &&  $org ne ""  &&  $org ne "#NAME?"  &&  $org ne "unknown"  &&  $org ne "-"  &&  $block ne "Y" && $heading>0 && $org ne "no company") {
    #if($instr !~ /[^\x00-\x7e]/) {
     print wf "$date\t$acct\t$heading\t$org\t$dom\t$country\t$city\t$state\t$zip\t$cnt\t$isp\t$block\t$orgid\t$orgmd5\t$ip\t$naics\t$primary_sic\t$countrycode\t$duns_number\t$domestichqdunsnumber\t$hqdunsnumber\t$gltdunsnumber\t$countrycode3\t$audience\t$audiencesegment\t$b2b\t$employee_range\t$forbes2k\t$fortune1k\t$industry\t$informationlevel\t$latitude\t$longitude\t$phone\t$revenue_range\t$subindustry\t$cov\n";
      #}
    }
 
    $date = $heading = $org = $dom = $country = $city = $state = $zip = $cnt =  $orgid = $ip = $isp = $naics = $primary_sic = $countrycode = $orgmd5  ="";
    $acct=$duns_number=$domestichqdunsnumber=$hqdunsnumber=$gltdunsnumber=$countrycode=$country=$audience=$audiencesegment="";
    $b2b=$employee_range=$forbes2k=$fortune1k=$industry=$informationlevel=$latitude=$longitude=$phone=$revenue_range=$subindustry=$cov=$acct="";


   # my $timeout = 1;
   # $timeout -= sleep $timeout while $timeout > 0;
  }
close(rf);

close(wf);
# system("mysqlimport -i thomas tnetlogORGCATD_temp.txt");
system("mysqlimport thomas $tablefile");



# dump temp data
$query  = "INSERT INTO  $table ";
$query .= "      (date, acct, heading, org, domain, country, city, state, zip, cnt, isp, block, orgid, oid, ip, naics, primary_sic, countrycode, duns_number, domestichqdunsnumber, hqdunsnumber, gltdunsnumber, countrycode3, audience, audiencesegment, b2b, employeerange, forbes2k, fortune1k, industry, informationlevel, latitude, longitude, phone, revenuerange, subindustry, cov) ";
$query .= "SELECT date, acct, heading, org, domain, country, city, state, zip, cnt, isp, block, orgid, oid, ip, naics, primary_sic, countrycode, duns_number, domestichqdunsnumber, hqdunsnumber, gltdunsnumber, countrycode3, audience, audiencesegment, b2b, employeerange, forbes2k, fortune1k, industry, informationlevel, latitude, longitude, phone, revenuerange, subindustry, cov  ";
$query .= "FROM  tnetlogORGCATD_temp  WHERE org!='-' ";
#my $sth = $dbh->prepare($query);
#if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
#$sth->finish;

# check rec counts
$query  = "SELECT count(*)  FROM  $table ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
if (my $row = $sth->fetchrow_arrayref)
 {
  print "\nCount from  $table: $$row[0]\n";
 }
$sth->finish;

# delete from temp table
$query  = "DELETE FROM thomtnetlogORGCATD_temp";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

$rc = $dbh->disconnect;

print "\n\nProcessing complete.\nCheck for errors.\n\n";

exit;





