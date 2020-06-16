#!/usr/local/bin/php
<?php
set_time_limit(360000);
date_default_timezone_set('EST');
error_reporting(0);

$link = mysql_pconnect('',  '', '');
if (!$link) {
    die('Not connected : ' . mysql_error());
}
$db_selected = mysql_select_db('thomas', $link);
if (!$db_selected) {
    die ('Select db  : ' . mysql_error());
}

$dbkey    = "9b07d129aa62479636667e2bf1e891054714d307";
$url    = "http://api.dbase.com/api/v2/ip.json?key=$dbkey&query=";

//echo "$url"; exit;

$outfile  = "dbaseIPresolved.txt";
$of       = fopen($outfile, "w") or exit("Unable to open output file $outfile\n");


function CleanVar ($data) {
        $data = trim($data);
        $data = strtolower($data);
	$date = utf8_decode($data);
        return $data;
}

$j=1;
   
$query = "SELECT * FROM thomdbaseNetAcuityIP WHERE  ip='163.188.94.122' LIMIT  10";
$query = "SELECT * FROM thomdbaseNetAcuityIP WHERE  created=0  ";
//print "\n$query\n";
$result   = mysql_query($query);
for ($i=0; $i<mysql_numrows($result); $i++){

	$ip = trim(mysql_result($result, $i, "ip"));

	$dburl = $url . "key=$dbkey&query=" . $ip;
	#echo "\n$dburl\n";
 
	$string   = file_get_contents($dburl);
	$jvars     = json_decode($string);
	//var_dump($jvars);

	$ilevel= $jvars->information_level;
	//echo "\ninfo: $ilevel\n";
 
	if ($j % 1000 == 0) { echo "$j. $ip\t$jvars->registry_company_name\n"; }

	if($jvars->information_level == "Basic")
	{
			$org                   = $jvars->registry_company_name;  # basic
			$dom                   = $jvars->web_site;
			$city                  = $jvars->registry_city;          # basic
			$state                 = $jvars->registry_state;         # basic
			$zip                   = $jvars->registry_zip_code;      # basic
			$naics                 = $jvars->naics;
			$country               = $jvars->registry_country;       # basic
			$isp                   = $jvars->isp;                    # basic
			$naics                 = $jvars->naics;
			$primary_sic           = $jvars->primary_sic;
			$dunsnum               = $jvars->duns_num;
			$domestichqdunsnumber  = $jvars->domduns_num;
			$hqdunsnumber	       = $jvars->hqduns_num;
			$gltdunsnumber	       = $jvars->gltduns_num;
			$countrycode	       = $jvars->registry_country_code;  # basic
			$countrycode3	       = $jvars->registry_country_code3; # basic
			$audience	       = $jvars->audience;               # basic
			$audiencesegment       = $jvars->audience_segment;       # basic
			$b2b	               = $jvars->b2b;
			$employee_range	       = $jvars->employee_range;
			$forbes2k	       = $jvars->forbes_2000;
			$fortune1k	       = $jvars->fortune_1000;
			$industry	       = $jvars->industry;
			$informationlevel      = $jvars->information_level;
			$latitude	       = $jvars->registry_latitude;       # basic
			$longitude	       = $jvars->registry_longitude;      # basic
			$phone	               = $jvars->phone;
			$revenue_range	       = $jvars->revenue_range;
			$subindustry	       = $jvars->sub_industry;
			$hqdunsnumber	       = $jvars->hqduns_num;

	}
	else
	{
			$org                   = $jvars->company_name;
			$dom                   = $jvars->web_site;
			$city                  = $jvars->city;
			$state                 = $jvars->state;
			$zip                   = $jvars->zip;
			$country               = $jvars->country_name;
			$isp                   = $jvars->isp;
			$naics                 = $jvars->naics;
			$primary_sic           = $jvars->primary_sic;
			$dunsnum               = $jvars->duns_num;
	  		$domestichqdunsnumber  = $jvars->domduns_num;
			$hqdunsnumber	       = $jvars->hqduns_num;
			$gltdunsnumber	       = $jvars->domestichq->gltduns_num;
			$countrycode	       = $jvars->country;
			//$countrycode	       = $jvars->registry_country_code;
			$countrycode3          = $jvars->registry_country_code3;
			$audience              = $jvars->audience;
			$audiencesegment       = $jvars->audience_segment;
			$b2b	               = $jvars->b2b;
			$employee_range	       = $jvars->employee_range;
			$forbes2k              = $jvars->forbes_2000;
			$fortune1k	       = $jvars->fortune_1000;
			$industry	       = $jvars->industry;
			$informationlevel      = $jvars->information_level;
			$latitude	       = $jvars->latitude;
			$longitude	       = $jvars->longitude;
			$phone	               = $jvars->phone;
			$revenue_range	       = $jvars->revenue_range;
			$subindustry	       = $jvars->sub_industry;

	}

	$org                     = CleanVar($org);
	$dom                     = CleanVar($dom);
	$city                    = CleanVar($city);
	$state                   = CleanVar($state);
	$zip                     = CleanVar($zip);
	$country                 = CleanVar($country);
	$isp                     = CleanVar($isp);
	$naics                   = CleanVar($naics);
	$primary_sic             = CleanVar($primary_sic);
	$dunsnum                 = CleanVar($dunsnum);
	$domestichqdunsnumber    = CleanVar($domestichqdunsnumber);
	$hqdunsnumber            = CleanVar($hqdunsnumber);
	$gltdunsnumber           = CleanVar($gltdunsnumber);
	$countrycode             = CleanVar($countrycode);
	$countrycode3            = CleanVar($countrycode3);
	$audience                = CleanVar($audience);
	$audiencesegment         = CleanVar($audiencesegment);
	$b2b                     = CleanVar($b2b);
	$employee_range          = CleanVar($employee_range);
	$forbes2k                = CleanVar($forbes2k);
	$fortune1k               = CleanVar($fortune1k);
	$industry                = CleanVar($industry);
	$informationlevel        = CleanVar($informationlevel);
	$latitude                = CleanVar($latitude);
	$longitude               = CleanVar($longitude);
	$phone                   = CleanVar($phone);
	$revenue_range           = CleanVar($revenue_range);
	$subindustry             = CleanVar($subindustry);

	//echo "$org  $ip   isp:  $isp\n";
	if($isp==1) {$isp="true";} else  { $isp="false"; }

	fputs($of, "$ip\t$created\t$org\t$dom\t$city\t$state\t$zip\t$country\t$isp\t$naics\t$primary_sic\t$dunsnum\t$domestichqdunsnumber\t$hqdunsnumber\t$gltdunsnumber\t$countrycode\t$countrycode3\t$audience\t$audiencesegment\t$b2b\t$employee_range\t$forbes2k\t$fortune1k\t$industry\t$informationlevel\t$latitude\t$longitude\t$phone\t$revenue_range\t$subindustry\n");

	//usleep(2000);
  
	$j++;
}

fclose($of);
?>
