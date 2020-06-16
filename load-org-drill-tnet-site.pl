#!/usr/bin/perl
#
#
# Loads new Org drill down data by site, acct and heading for TNET
# Need to run to get to get org flag table loaded.
# run as  ./load-org-drill-tnet-site.pl YYMM 
# may have to run this more than once per month if they add more isp & blocks to tnetlogORGflag
# md5 orgid throws out dupe domains 
# loads to temp table then dumps and inserts to live table  
# md5 oid used in tables
# orgs/domains site wide, table: tnetlogORGSITEDYY_MM

#### note ignore temp table for now ###
         
use Digest::MD5 qw(md5 md5_hex md5_base64);

$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}
 
require "trd-reload.ph";

$fyear     = "20" . substr($fdate, 0, 2);
$yy        =  substr($fdate, 0, 2);             
$mm        =  substr($fdate, 2, 2);
$table     = "tnetlogORGSITED" . $yy . "_" . $mm;
$tablefile = $table . ".txt";
$file      = "orgDomainVisitsDrill"; 
$infile    = $fyear . "/" . $file . "-" . $fdate . ".txt";
  
use DBI;
$dbh      = DBI->connect("", "", "");

# Get bad and isp orgs - only need bad now
#$query  = "SELECT trim(org) AS org, isp, block FROM thomtnetlogORGflag WHERE ( isp='Y' || block='Y' ) AND org>'' ORDER BY org ";
#$query  = "SELECT org  FROM thomtnetlogORGflag WHERE block='Y'  AND org>''  ";
#my $sth = $dbh->prepare($query);
#if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
#while (my $row = $sth->fetchrow_arrayref)
# {
#  $$row[0] =~ s/^\s+//;
#  $$row[0] =~ s/\s+$//;
#  $$row[0] =~ tr/[A-Z]/[a-z]/; 
#  #if($$row[1] eq "Y") { $isporg{$$row[0]} = $$row[0]; }
#  $badorg{$$row[0]} = $$row[0]; 
# } 
#$sth->finish;

 
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


 
# extra isp flags
$query  = "SELECT trim(org)  FROM thomtnetlogORGflagExtra WHERE org>''  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {  
  $$row[0] =~ tr/[A-Z]/[a-z]/; 
  $isporg{$$row[0]} = $$row[0]; 
 }  
$sth->finish;
    
# delete from tables    
 $query = "DELETE FROM $table WHERE date='$fdate'";
 my $sth = $dbh->prepare($query);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 $sth->finish;

$query = "DELETE FROM thomtnetlogORGSITED_temp";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

 
# load temp table
#open(wf, ">tnetlogORGSITED_temp.txt")  || die (print "Could not open tnetlogORGSITED_temp.txt\n");
open(wf, ">$tablefile")  || die (print "Could not open $tablefile\n");
print "$infile\n";  
open(rf, "$infile")  || die (print "Could not open $infile\n");
while (!eof(rf))
  {
    $instr = <rf>;
    chop($instr); 
    #print "$instr\n";	
    # new order: date, org, count, dom, city, state, zip, isp, ip, naics, country, primary_sic, countrycode,
    # $duns_number, $domestichqdunsnumber, $hqdunsnumber, $gltdunsnumber, $countrycode, $country, $audience, $audiencesegment, $b2b, 
    # $employee_range, $forbes2k, $fortune1k, $industry, $informationlevel, $latitude, $longitude, $phone, $revenue_range, $subindustry
    ($date, $org, $cnt, $dom, $city, $state, $zip, $isp, $ip, $naics, $country, $primary_sic, $countrycode, $duns_number, $domestichqdunsnumber, $hqdunsnumber, $gltdunsnumber, $countrycode3, $audience, $audiencesegment, $b2b, $employee_range, $forbes2k, $fortune1k, $industry, $informationlevel, $latitude, $longitude, $phone, $revenue_range, $subindustry, $cov) = split(/\t/, $instr); 
    #print "$instr\ndate:$date\n org:$org\n cnt:$cnt\n dom:$dom\n city:$city\n state:$state\n zip:$zip\n isp:$isp\n ip:$ip\n";
    #print "naics:$naics\t$country:$country\t$primary_sic:$primary_sic\n";
    #print "duns_number:$duns_number\tdomestichqdunsnumber:$domestichqdunsnumber\thqdunsnumber:$hqdunsnumber\tgltdunsnumber:$gltdunsnumber\tcountrycode:$countrycode\tcountry:$country\taudience:$audience\taudiencesegment:$audiencesegment\tb2b:$b2b\temployee_range: $employee_range\tforbes2k:$forbes2k\tfortune1k:$fortune1k\tindustry:$industry\tinformationlevel$informationlevel\tlatitude:$latitude\tlongitude:$longitude\tphone:$phone\trevenue_range:$revenue_range\tsubindustry:$subindustry-------\n";	  
 
    $org                   = &CleanForeign($org); 
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
        
    $orgid  = "$date$org$dom$countrycode$city$state$zip$cov";                                        
    $orgid  =  md5_hex($orgid); 
    $orgmd5 =  md5_hex($org); 


    if($org ne "?"  &&  $org ne ""  &&  $org ne "#NAME?"  &&  $org ne "unknown"  &&  $org ne "-" && $block ne "Y" && $org ne "no company") {   
     # if($instr !~ /[^\x00-\x7e]/) {
     # print wf "INSERT IGNORE INTO tnetlogORGSITED_temp VALUES ('$date','$org','$dom','$country','$city','$state','$zip','$cnt','$isp','$block', md5('$orgid') , md5('$org'), '$ip', '$naics', '$primary_sic', '$countrycode''$duns_number', '$domestichqdunsnumber', '$hqdunsnumber', '$gltdunsnumber', '$countrycode', '$country', '$audience', '$audiencesegment', '$b2b', '$employee_range', '$forbes2k', '$fortune1k', '$industry', '$informationlevel', '$latitude', '$longitude', '$phone', '$revenue_range', '$subindustry' );\n";        

     print wf "$date\t$org\t$dom\t$country\t$city\t$state\t$zip\t$cnt\t$isp\t$block\t$orgid\t$orgmd5\t$ip\t$naics\t$primary_sic\t$countrycode\t$duns_number\t$domestichqdunsnumber\t$hqdunsnumber\t$gltdunsnumber\t$countrycode3\t$audience\t$audiencesegment\t$b2b\t$employee_range\t$forbes2k\t$fortune1k\t$industry\t$informationlevel\t$latitude\t$longitude\t$phone\t$revenue_range\t$subindustry\t$cov\n";        
     # }      
    }     

    $org = $dom = $country = $city = $state = $zip = $cnt = $orgid = $ip = $naics = $primary_sic = $countrycode  = $orgmd5  = "";
    $duns_number=$domestichqdunsnumber=$hqdunsnumber=$gltdunsnumber=$countrycode3=$country=$audience=$audiencesegment="";             
    $b2b=$employee_range=$forbes2k=$fortune1k=$industry=$informationlevel=$latitude=$longitude=$phone=$revenue_range=$subindustry=$cov="";

    #my $timeout = 1;
    #$timeout -= sleep $timeout while $timeout > 0;
  }   
close(rf);
close(wf);
 
#system("mysqlimport -i thomas tnetlogORGSITED_temp.txt");   
system("mysqlimport thomas $tablefile");   
     

# dump temp data
$query  = "INSERT INTO  $table ";
$query .= "(      date, org, domain, country, city, state, zip, cnt, isp, block, orgid, oid, ip, naics, primary_sic, countrycode, duns_number, domestichqdunsnumber, hqdunsnumber, gltdunsnumber, countrycode3, audience, audiencesegment, b2b, employeerange, forbes2k, fortune1k, industry, informationlevel, latitude, longitude, phone, revenuerange, subindustry, cov) ";
$query .= "SELECT date, org, domain, country, city, state, zip, cnt, isp, block, orgid, oid, ip, naics, primary_sic, countrycode, duns_number, domestichqdunsnumber, hqdunsnumber, gltdunsnumber, countrycode3, audience, audiencesegment, b2b, employeerange, forbes2k, fortune1k, industry, informationlevel, latitude, longitude, phone, revenuerange, subindustry, cov ";
$query .= "FROM thomtnetlogORGSITED_temp WHERE  org!='-'   ";
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
$query = "DELETE FROM thomtnetlogORGSITED_temp";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

$rc = $dbh->disconnect;
            
print "\n\nProcessing complete.\nCheck for errors.\n\n";

exit;
 




