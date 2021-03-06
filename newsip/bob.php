<?php
// Resolves IP addresses and load them into a table
// Run this last
// Run as: php -q load-adfiles3.php YYMM
 
date_default_timezone_set('EST');
error_reporting(0);

$fdate =  $argv[1];

require ("countries.inc");

$link = mysql_pconnect('',  '', '');
if (!$link) {
    die('Not connected : ' . mysql_error());
}

$db_selected = mysql_select_db('thomas', $link);
if (!$db_selected) {
    die ('Select db  : ' . mysql_error());
}


function PrepData ($data) {
	if($data=="?" || $data=="-")  {$data="";}
	$data = ereg_replace("\'", "", $data);
	return($data);
}

function GetCountry ($fld) {
	//  iso3 | iso2 | countryname   | regions | continentcode | continentname | countrycode
	//  usa  | us   | united states |       1 |             6 | na            |         840 |
 	//  uzb  | uz   | uzbekistan    |       1 |             4 | as            |         860 |
	$result = mysql_query("SELECT countryname FROM thomnetacuitycountry  WHERE iso3='$fld'");
	echo "SELECT countryname FROM thomnetacuitycountry  WHERE iso3='$fld'\n";
	$desc   = mysql_result($result, 0, "countryname");
	return($desc);
}

function GetState ($fld) {
	// country  | region | regiondesc  | regioncode
	//  usa     | az     | arizona     |          3
	//  usa     | ca     | california  |          5
	$result = mysql_query("SELECT regiondesc FROM thomnetacuityregion WHERE region='$fld'");
	$desc   = trim(mysql_result($result, 0, "regiondesc"));
	return($desc);
}

$iptable = "adip2" .  $fdate;
$ipfile  = "adip2" .  $fdate . ".txt";
echo "\nProcessing $iptable with adcv2.ls\n\n";

// get known blocks and put into an array
$query  = "SELECT trim(orgblock) as orgblock FROM thomtnetlogORGflagBLOCK   WHERE orgblock>'' ";
$result = mysql_query($query);
for($i=0; $i<mysql_numrows($result); $i++) {
        $o          = trim(strtolower(mysql_result($result, $i, "orgblock")));
        $badorg[$o] = $o;
}  



$query  = "SELECT trim(org)  as org FROM thomtnetlogORGflagExtra WHERE org>''  ";
$result = mysql_query($query);
for($i=0; $i<mysql_numrows($result); $i++) {
	$o  = strtolower(mysql_result($result, $i, "org"));
	$isporg[$o] = $o;
}


/// PROCESS IP CLICKS ///
// get all ip addresses, resolve them and write to file
$i=0;
$rf = fopen("adcv2.ls", "r") or exit("Unable to open output file adcv.ls\n");
$wf = fopen($ipfile, "w")   or exit("Unable to open output file $ipfile \n");
while (!feof($rf)) 
{
	$adip = fgets($rf, 4096);
	$adip = trim($adip);
	//echo "$i) $adip\n";

	// ckeck demand base first
	$query = "SELECT
              org, domain, city, state, zip, country, isp, naics, primary_sic, dunsnum, domestichqdunsnumber, hqdunsnumber,
              gltdunsnumber, countrycode, countrycode3, audience, audiencesegment, b2b, employee_range, forbes2k, fortune1k,
              industry, informationlevel, latitude, longitude, phone, revenue_range, subindustry
              FROM  thomdbaseIPresolved
              WHERE ip='$adip'";
	print "$query\n\n";
	$result = mysql_query($query);
	if(mysql_numrows($result) )
	{  
			$org                  = PrepData(mysql_result($result, 0, "org"));
			$orglow               = strtolower(mysql_result($result, 0, "org"));
			$domain               = PrepData(mysql_result($result, 0, "domain"));
			$city                 = PrepData(mysql_result($result, 0, "city"));
			$state                = strtoupper(mysql_result($result, 0, "state"));
			$statename            = $STLIST[$state];
			$zip                  = PrepData(mysql_result($result, 0, "zip"));
			$country              = GetCountry (mysql_result($result, 0, "country"));
			$country              = PrepData($country);
			$isp                  = PrepData(mysql_result($result, 0, "isp"));
			$naics                = PrepData(mysql_result($result, 0, "naics"));
			$primary_sic          = PrepData(mysql_result($result, 0, "primary_sic"));
			$dunsnum              = PrepData(mysql_result($result, 0, "dunsnum"));
			$domestichqdunsnumber = PrepData(mysql_result($result, 0, "domestichqdunsnumber"));
			$hqdunsnumber         = PrepData(mysql_result($result, 0, "hqdunsnumber"));
			$gltdunsnumber        = PrepData(mysql_result($result, 0, "gltdunsnumber"));
			$countrycode          = PrepData(mysql_result($result, 0, "countrycode"));
			$countrycode3         = PrepData(mysql_result($result, 0, "countrycode3"));
			$audience             = PrepData(mysql_result($result, 0, "audience"));
			$audiencesegment      = PrepData(mysql_result($result, 0, "audiencesegment"));
			$b2b                  = PrepData(mysql_result($result, 0, "b2b"));
			$employee_range       = PrepData(mysql_result($result, 0, "employee_range"));
			$forbes2k             = PrepData(mysql_result($result, 0, "forbes2k"));
			$fortune1k            = PrepData(mysql_result($result, 0, "fortune1k"));
			$industry             = PrepData(mysql_result($result, 0, "industry"));
			$informationlevel     = PrepData(mysql_result($result, 0, "informationlevel"));
			$latitude             = PrepData(mysql_result($result, 0, "latitude"));
			$longitude            = PrepData(mysql_result($result, 0, "longitude"));
			$phone                = PrepData(mysql_result($result, 0, "phone"));
			$revenue_range        = PrepData(mysql_result($result, 0, "revenue_range"));
			$subindustry          = PrepData(mysql_result($result, 0, "subindustry"));
		

		

		if($badorg[$orglow]){ $block="Y"; }
		else                { $block="N"; }

		if($isp=="" || $isp=="true" ||  $isp=="y" || $isp=="Y") {$isp="Y";}
		else                                                    {$isp="N";}

 		if($isporg[$orglow]){ $isp="Y"; }

		//if($country=="US") {$countrycode3="USA";}
		//if($country=="CA") {$countrycode3="CAN";}
	 
                if( preg_match("/fuck/", $org)  || preg_match("/asshole/", $org) ) { $block="Y";  }
                if( preg_match("/FUCK/", $org)  || preg_match("/ASSHOLE/", $org) ) { $block="Y";  }	

		$org  = ucwords ( $org );
		$city = ucwords ( $city );
		$countrycode3 = strtoupper ( $countrycode3 );
  
                $city = strtr($city,   "ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÑÒÓÔÕÖØÝßàáâãäåçèéêëìíîïñòóôõöøùúûüýÿ",  "AAAAAACEEEEIIIINOOOOOOYSaaaaaaceeeeiiiinoooooouuuuyy"); 
                $org = strtr($org,   "ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÑÒÓÔÕÖØÝßàáâãäåçèéêëìíîïñòóôõöøùúûüýÿ",  "AAAAAACEEEEIIIINOOOOOOYSaaaaaaceeeeiiiinoooooouuuuyy"); 
    
		if($org!="" &&  $block!="Y") {
   		fputs($wf, "$fdate\t$adip\t$org\t$continentcode\t$country\t$countrycode3\t$country\t$state\t$city\t$zip\t$latitude\t$longitude\t$domain\t$areacode\t$statename\t$isp\t$zip\t");
		fputs($wf, "$naics\t$primary_sic\t$countrycode\t$dunsnum\t$domestichqdunsnumber\t$hqdunsnumber\t$gltdunsnumber\t$audience\t$audiencesegment\t$b2b\t$employeerange\t$forbes2k\t$fortune1k\t$industry\t$informationlevel\t$phone\t$revenuerange\t$subindustry\n");

 

	$cup=$adip=$co=$continentcode=$countrycode2=$countrycode3=$country=$reg=$city=$zip=$lat=$long=$dma=$areacode=$regionname=$ispflag="";
	$adip = $org = $ispflag = $regionname =  $orglow =  $isp = $block ="";
	$country=$countrycode=$state=$city=$latitude=$longitude=$zip=$org=$domain=$isp=$naics=$primary_sic="";
	$dunsnum=$domestichqdunsnumber=$hqdunsnumber=$gltdunsnumber=$countrycode3=$audience=$audiencesegment=$b2b="";
	$employeerange=$forbes2k=$fortune1k=$industry=$informationlevel=$phone=$revenuerange=$subindustry="";

	} 


     }

 $i++;
 if ($i % 1000 == 0) { echo "$i\r"; }
}
fclose($rf);
fclose($wf);

// import
//$query  = "LOAD DATA INFILE '/usr/wt/newsip/$ipfile' IGNORE INTO TABLE $iptable ";
//$result  = mysql_query($query);

echo "\nRecord count: $i\n";
?>

