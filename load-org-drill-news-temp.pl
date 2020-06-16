#!/usr/bin/perl
#
# TGR & NEWS
# Loads new Org drill down data by site, acct and heading for TNET, TGR and News
# Need to run to get to get org flag table loaded.
# run as  ./load-org-drill-news.pl YYMM
# may have to run this more than once per month if they add more isp & blocks to tnetlogORGflag
# md5 orgid throws out dupe domains
# md5 oid used in tables

#### note ignore temp table for now ###


use Digest::MD5 qw(md5 md5_hex md5_base64);

$fdate   = $ARGV[0];
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

require "trd-reload.ph";

$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);
$mm       =  substr($fdate, 2, 2);
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

# get country       0    1      2
$query  = "select iso2,iso3,countryname from thomnetacuitycountry ";
#print "\n\n$query\n\n";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $countryname{$$row[0]} = $$row[2]; # countryname from 2 char country
  $country3{$$row[0]}    = $$row[1]; # 3 char countrycode from 2
  #print "$$row[0]  $countryname{$$row[0]}\n";
 }
$sth->finish;

# orgs/domains site wide, table: newsORGSITED$yy
$file   = "news_orgDomainVisitsDrillCov";

$file   = "news_advOrgVisitsDrillcovnewregnoCID";
###$file   = "news_OrgDomainVisitsDrillCovReg";

$infile = $fyear . "/" . $file . "-" . $fdate . ".txt";
open(rf, "$infile")  || die (print "Could not open $infile\n");


# delete from tables
#$query = "DELETE FROM thomnewsORGSITED$yy WHERE date='$fdate'";
#my $sth = $dbh->prepare($query);
#if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
#$sth->finish;

$query = "DELETE FROM thomnewsORGSITED_temp";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

#open(wf,  ">newsORGSITED_temp.txt")  || die (print "Could not open $outfile\n");
open(wf,  ">newsORGSITED$yy.txt")  || die (print "Could not open newsORGSITED$yy.txt\n");
print "$infile\n";
while (!eof(rf))
  {
    $instr = <rf>;
    chop($instr);
    ($date, $org, $cnt, $dom, $city, $state, $zip, $isp, $ip, $naics, $country, $primary_sic, $countrycode, $duns_number, $domestichqdunsnumber, $hqdunsnumber, $gltdunsnumber, $countrycode3, $audience, $audiencesegment, $b2b, $employee_range, $forbes2k, $fortune1k, $industry, $informationlevel, $latitude, $longitude, $phone, $revenue_range, $subindustry, $tinid) = split(/\t/, $instr);

    $org                   = &CleanOrg($org);
    $dom                   = &CleanFlds("dom",$dom);
    $acct                  = &CleanFlds("acct",$acct);
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
    if($cov eq "") {$cov="NA";}	

    if($isp eq "Company")        { $isp="N";   } else { $isp="Y"; }
    if($isporg{$org}  ne "")     { $isp="Y"; } 	
    if($badorg{$org} ne "")      { $block="Y"; } else { $block="N"; }
 


	######### Check for tinid ################
	$tinid                   = &CleanOrg($tinid);
	$tinidok = "0"; 
	if($tinid ne "") {
		$query  = "SELECT count(*) FROM  tgrams.mt_profile_history WHERE tinid='$tinid'  ";
		my $ssth = $dbh->prepare($query);
		if (!$ssth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
		if (my $srow = $ssth->fetchrow_arrayref)
		{
        	$tinidok  =  $$srow[0];
		}
		$ssth->finish;
		#print "$tinid\t $tinidok\n";
    	}

    # if OK use registry date if not use infile data
    if($tinidok ne 0)
    { 
 
 	# pull data           0         1      2          3        4        5            6            7       8        9         10
	$query  = "SELECT company,    city,  state,    country,    zip,  industry,  jobfunction,    phone,  '$cnt', '$acct', '$heading' ";
	$query  = "SELECT company,    city,  state,    country,    zip,  industry,  jobfunction,    phone  ";
	$query .= "FROM   tgrams.mt_profile_history WHERE tinid='$tinid'   ";
	my $sth = $dbh->prepare($query);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
    		$$row[3]     =~ tr/[A-Z]/[a-z]/;  
    		$countrycode =~ tr/[A-Z]/[a-z]/;  
    		$org                   = &CleanForeign($$row[0]);
    		$org                   = &CleanOrg($org);
    		$dom                   = "";
    		$city                  = $$row[1];
    		$state                 = $$row[2];
    		$zip                   = $$row[4];
    		$ip                    = "";
    		$naics                 = "";
		
		if($$row[3] eq "" || length($$row[3] gt 2) )  { $$row[3]=$countrycode; } # if no registry country or 3 char use IRs country code
    		$country               = $countryname{$$row[3]};
    		$primary_sic           = "";
    		$duns_number           = 0;
    		$domestichqdunsnumber  = 0;
    		$hqdunsnumber          = 0;
    		$gltdunsnumber         = 0;  
    		$countrycode           = $$row[3];
    		$countrycode3          = $country3{$$row[3]};		
    		$audience              = "";
    		$audiencesegment       = "";
    		$b2b                   = "";
    		$employee_range        = "";
    		$forbes2k              = "";
    		$fortune1k             = "";
    		$industry              = $$row[5];
    		$informationlevel      = "basic";
    		$latitude              = "0.0001"; # flags them as registry record
    		$longitude             = "0.0001";
    		$phone                 = $$row[7];
    		$revenue_range         = "";
    		$subindustry           = "";
    		$cov                   = "$cov"; # from infile

    		#$cnt  = $$row[8];  # These 3 fields will be taken from the infile
    		#$acct = $$row[9];
    		#$hdd = $$row[10];

 		if($isporg{$org}  ne "")     { $isp="Y";  } else { $isp="N";  }
		if($badorg{$org} ne "")      { $block="Y";} else { $block="N";}

 		if($city  eq "NULL")    { $city = $state = ""; }
    		if( ($$row[1] eq "" || $$row[2] eq "" || $$row[1]==NULL || $$row[2] eq "NU")  && $$row[4] ne "" )
		{
			# try primary first 
        		$squery  = "SELECT City, State  FROM thomzipcodes WHERE Zipcode='$$row[4]' AND LocationType='PRIMARY' limit 1 ";
        		$squery  = "SELECT place_name, admin_code1  FROM thomallCountries WHERE postal_code='$$row[4]' AND country_code='$$row[3]' limit 1 ";
			if ($$row[4] =~ /^[a-zA-Z]/) # canada
			{
			$zzip  = substr $$row[4], 0, 3;
			$squery  = "SELECT place_name, admin_code1  FROM thomallCountries WHERE postal_code='$zzip' AND country_code='$$row[3]' limit 1 ";
			} 
        		my $ssth = $dbh->prepare($squery);  
        		if (!$ssth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
        		if (my $srow = $ssth->fetchrow_arrayref)
        		{
        		$city  =  $$srow[0];
        		$state =  $$srow[1];
        		}
        		$ssth->finish;

        		if($city eq "") { # try for secondary
        		$squery  = "SELECT City, State  FROM thomzipcodes WHERE Zipcode='$$row[4]' AND LocationType='ACCEPTABLE' limit 1 ";
        		my $ssth = $dbh->prepare($squery);
        		if (!$ssth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
        		if (my $srow = $ssth->fetchrow_arrayref)
        		{
        		$city  =  $$srow[0];
        		$state =  $$srow[1];
        		}
        		$ssth->finish;
			}

        	} 
    		$city  =~ tr/[A-Z]/[a-z]/;
    		$state =~ tr/[A-Z]/[a-z]/;
	} 
	#print "$org\t$dom\t$country\t$city\t$state\t$zip\t$countrycode\n";
    } 
    ######### Check for tinid end ################ 

    $orgid = "$date$org$dom$countrycode$city$state$zip";
    $orgid  =  md5_hex($orgid);
    $orgmd5 =  md5_hex($org);
 
    if($org ne "?"  &&  $org ne ""  &&  $org ne "#NAME?"  &&  $org ne "unknown"  &&  $org ne "-"   && $org ne "no company") {
     if($block ne "Y") {
      print wf "$date\t$org\t$dom\t$country\t$city\t$state\t$zip\t$cnt\t$isp\t$block\t$orgid\t$orgmd5\t$ip\t$naics\t$primary_sic\t$countrycode\t$duns_number\t$domestichqdunsnumber\t$hqdunsnumber\t$gltdunsnumber\t$countrycode3\t$audience\t$audiencesegment\t$b2b\t$employee_range\t$forbes2k\t$fortune1k\t$industry\t$informationlevel\t$latitude\t$longitude\t$phone\t$revenue_range\t$subindustry\t$cov\n";
     }
    }
    $org = $dom = $country = $city = $state = $zip = $cnt = $orgid = $ip = $isp = $naics = $primary_sic = $countrycode =  $orgmd5  = "";
    $duns_number=$domestichqdunsnumber=$hqdunsnumber=$gltdunsnumber=$countrycode3=$country=$audience=$audiencesegment="";
    $b2b=$employee_range=$forbes2k=$fortune1k=$industry=$informationlevel=$latitude=$longitude=$phone=$revenue_range=$subindustry=$tinid=$tinidok="";

  }
close(rf);
close(wf);

#system("mysqlimport -i thomas newsORGSITED_temp.txt");
system("mysqlimport thomas newsORGSITED$yy.txt");

 
print "\nDone...\n";
exit;



# dump temp data
$query  = "INSERT INTO  newsORGSITED$yy ";
$query .= "(      date, org, domain, country, city, state, zip, cnt, isp, block, orgid, oid, ip, naics, primary_sic, countrycode,duns_number, domestichqdunsnumber, hqdunsnumber, gltdunsnumber, countrycode3, audience, audiencesegment, b2b, employeerange, forbes2k, fortune1k, industry, informationlevel, latitude, longitude, phone, revenuerange, subindustry ) ";
$query .= "SELECT date, org, domain, country, city, state, zip, cnt, isp, block, orgid, oid, ip, naics, primary_sic, countrycode,duns_number, domestichqdunsnumber, hqdunsnumber, gltdunsnumber, countrycode3, audience, audiencesegment, b2b, employeerange, forbes2k, fortune1k, industry, informationlevel, latitude, longitude, phone, revenuerange, subindustry ";
$query .= "FROM thomnewsORGSITED_temp  WHERE  org!='-'   ";
#my $sth = $dbh->prepare($query);
#if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
#$sth->finish;

# check rec counts
$query  = "SELECT count(*)  FROM   newsORGSITED$yy  WHERE date='$fdate' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
if (my $row = $sth->fetchrow_arrayref)
 {
  print "\nCount from newsORGSITED$yy: $$row[0]\n\n";
 }
$sth->finish;


##############################

#$file   = "news_advOrgVisitsDrill";
$file   = "news_advOrgVisitsDrillCov";
$file   = "news_advOrgVisitsDrillcovnewreg";

$infile = $fyear . "/" . $file . "-" . $fdate . ".txt";
open(rf, "$infile")  || die (print "Could not open $infile\n");

# delete from tables
$query = "DELETE FROM thomnewsORGD$yy WHERE date='$fdate'";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

$query = "DELETE FROM thomnewsORGD_temp  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
 
#open(wf,  ">newsORGD_temp.txt")  || die (print "Could not open newsORGD_temp\n");
open(wf,  ">newsORGD$yy.txt")  || die (print "newsORGD$yy.txt\n");
print "$infile\n";
while (!eof(rf))
  {
    $instr = <rf>;
    chop($instr);
    ($date,$acct,$org,$cnt,$dom,$city, $state, $zip, $isp, $ip, $naics, $country, $primary_sic, $countrycode, $duns_number, $domestichqdunsnumber, $hqdunsnumber, $gltdunsnumber, $countrycode3, $audience, $audiencesegment, $b2b, $employee_range, $forbes2k, $fortune1k, $industry, $informationlevel, $latitude, $longitude, $phone, $revenue_range, $subindustry, $cov, $tinid)  = split(/\t/, $instr);

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
    if($cov eq "") {$cov="NA";}
   
    if($isp eq "Company")        { $isp="N";   } else { $isp="Y"; }
    if($isporg{$org}  ne "")     { $isp="Y"; }
    if($badorg{$org} ne "")      { $block="Y"; } else { $block="N"; }


	######### Check for tinid ################
	$tinid                   = &CleanOrg($tinid);
	$tinidok = ""; 
	if($tinid ne "") {
		$query  = "SELECT count(*) FROM  tgrams.mt_profile_history WHERE tinid='$tinid'  ";
		my $ssth = $dbh->prepare($query);
		if (!$ssth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
		if (my $srow = $ssth->fetchrow_arrayref)
		{
        	$tinidok  =  $$srow[0];
		}
		$ssth->finish;
		#print "$tinid\t $tinidok\n";
    	}

    # if OK use registry date if not use infile data
    if($tinidok ne 0)
    { 
 
 	# pull data           0         1      2          3        4        5            6            7       8        9         10
	$query  = "SELECT company,    city,  state,    country,    zip,  industry,  jobfunction,    phone,  '$cnt', '$acct', '$heading' ";
	$query  = "SELECT company,    city,  state,    country,    zip,  industry,  jobfunction,    phone  ";
	$query .= "FROM   tgrams.mt_profile_history WHERE tinid='$tinid'   ";
	my $sth = $dbh->prepare($query);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
    		$$row[3]     =~ tr/[A-Z]/[a-z]/;  
    		$countrycode =~ tr/[A-Z]/[a-z]/;  
    		$org                   = &CleanForeign($$row[0]);
    		$org                   = &CleanOrg($org);
    		$dom                   = "";
    		$city                  = $$row[1];
    		$state                 = $$row[2];
    		$zip                   = $$row[4];
    		$ip                    = "";
    		$naics                 = "";
		
		if($$row[3] eq "" || length($$row[3] gt 2) )  { $$row[3]=$countrycode; } # if no registry country or 3 char use IRs country code
    		$country               = $countryname{$$row[3]};
    		$primary_sic           = "";
    		$duns_number           = 0;
    		$domestichqdunsnumber  = 0;
    		$hqdunsnumber          = 0;
    		$gltdunsnumber         = 0;  
    		$countrycode           = $$row[3];
    		$countrycode3          = $country3{$$row[3]};		
    		$audience              = "";
    		$audiencesegment       = "";
    		$b2b                   = "";
    		$employee_range        = "";
    		$forbes2k              = "";
    		$fortune1k             = "";
    		$industry              = $$row[5];
    		$informationlevel      = "basic";
    		$latitude              = "0.0001"; # flags them as registry record
    		$longitude             = "0.0001";
    		$phone                 = $$row[7];
    		$revenue_range         = "";
    		$subindustry           = "";
    		$cov                   = "$cov"; # from infile

    		#$cnt  = $$row[8];  # These 3 fields will be taken from the infile
    		#$acct = $$row[9];
    		#$hdd = $$row[10];

 		if($isporg{$org}  ne "")     { $isp="Y";  } else { $isp="N";  }
		if($badorg{$org} ne "")      { $block="Y";} else { $block="N";}

 		if($city  eq "NULL")    { $city = $state = ""; }
    		if( ($$row[1] eq "" || $$row[2] eq "" || $$row[1]==NULL || $$row[2] eq "NU")  && $$row[4] ne "" )
		{
			# try primary first 
        		$squery  = "SELECT City, State  FROM thomzipcodes WHERE Zipcode='$$row[4]' AND LocationType='PRIMARY' limit 1 ";
        		$squery  = "SELECT place_name, admin_code1  FROM thomallCountries WHERE postal_code='$$row[4]' AND country_code='$$row[3]' limit 1 ";
			if ($$row[4] =~ /^[a-zA-Z]/) # canada
			{
			$zzip  = substr $$row[4], 0, 3;
			$squery  = "SELECT place_name, admin_code1  FROM thomallCountries WHERE postal_code='$zzip' AND country_code='$$row[3]' limit 1 ";
			} 
        		my $ssth = $dbh->prepare($squery);  
        		if (!$ssth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
        		if (my $srow = $ssth->fetchrow_arrayref)
        		{
        		$city  =  $$srow[0];
        		$state =  $$srow[1];
        		}
        		$ssth->finish;

        		if($city eq "") { # try for secondary
        		$squery  = "SELECT City, State  FROM thomzipcodes WHERE Zipcode='$$row[4]' AND LocationType='ACCEPTABLE' limit 1 ";
        		my $ssth = $dbh->prepare($squery);
        		if (!$ssth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
        		if (my $srow = $ssth->fetchrow_arrayref)
        		{
        		$city  =  $$srow[0];
        		$state =  $$srow[1];
        		}
        		$ssth->finish;
			}

        	} 
    		$city  =~ tr/[A-Z]/[a-z]/;
    		$state =~ tr/[A-Z]/[a-z]/;
	} 
	#print "$org\t$dom\t$country\t$city\t$state\t$zip\t$countrycode\n";
    } 
    ######### Check for tinid end ################ 

    $orgid = "$date$acct$org$dom$countrycode$city$state$zip$cov";
    $orgid  =  md5_hex($orgid);
    $orgmd5 =  md5_hex($org);


    if($org ne "?"  &&  $org ne ""  &&  $org ne "#NAME?"  &&  $org ne "unknown"  &&  $org ne "-" && $org ne "no company") {
     if($block ne "Y") {
      print wf "$date\t$acct\t$org\t$dom\t$country\t$city\t$state\t$zip\t$cnt\t$isp\t$block\t$orgid\t$orgmd5\t$ip\t$naics\t$primary_sic\t$countrycode\t$duns_number\t$domestichqdunsnumber\t$hqdunsnumber\t$gltdunsnumber\t$countrycode3\t$audience\t$audiencesegment\t$b2b\t$employee_range\t$forbes2k\t$fortune1k\t$industry\t$informationlevel\t$latitude\t$longitude\t$phone\t$revenue_range\t$subindustry\t$cov\n";
     }
    }

    $date = $acct = $org = $dom = $country = $city = $state = $zip = $cnt = $orgid = $ip = $naics = $primary_sic = $countrycode = $orgmd5  = "";
    $duns_number=$domestichqdunsnumber=$hqdunsnumber=$gltdunsnumber=$countrycode3=$country=$audience=$audiencesegment="";
    $b2b=$employee_range=$forbes2k=$fortune1k=$industry=$informationlevel=$latitude=$longitude=$phone=$revenue_range=$subindustry=$cov=$tinid=$tinidok=""
  }
close(rf);

close(wf);
#system("mysqlimport -i thomas  newsORGD_temp.txt");
system("mysqlimport thomas  newsORGD$yy.txt");


# dump temp data
$query  = "INSERT INTO  newsORGD$yy ";
$query .= "(      date, acct, org, domain, country, city, state, zip, cnt, isp, block, orgid, oid, ip, naics, primary_sic, countrycode, duns_number, domestichqdunsnumber, hqdunsnumber, gltdunsnumber, countrycode3, audience, audiencesegment, b2b, employeerange, forbes2k, fortune1k, industry, informationlevel, latitude, longitude, phone, revenuerange, subindustry, cov) ";
$query .= "SELECT date, acct, org, domain, country, city, state, zip, cnt, isp, block, orgid, oid, ip, naics, primary_sic, countrycode, duns_number, domestichqdunsnumber, hqdunsnumber, gltdunsnumber, countrycode3, audience, audiencesegment, b2b, employeerange, forbes2k, fortune1k, industry, informationlevel, latitude, longitude, phone, revenuerange, subindustry, cov ";
$query .= "FROM thomnewsORGD_temp WHERE  org!='-'   ";
#my $sth = $dbh->prepare($query);
#if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
#$sth->finish;

# check rec counts
$query  = "SELECT count(*)  FROM  newsORGD$yy WHERE date='$fdate' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
if (my $row = $sth->fetchrow_arrayref)
 {
  print "\nCount from  newsORGD$yy: $$row[0]\n\n";
 }
$sth->finish;

print "\n\nProcessing complete.\nCheck for errors.\n\n";

$rc = $dbh->disconnect;

exit;





