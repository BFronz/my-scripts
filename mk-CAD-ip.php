#!/usr/local/bin/php
<?php
set_time_limit(3600);
date_default_timezone_set('EST');
error_reporting(0);

system("date");

$fdate = $argv[1];
if(!$fdate) {echo "\nForgot to add data YYMM\n\n"; exit;}

$link = mysql_pconnect('',  '', '');
if (!$link) {
    die('Not connected : ' . mysql_error());
}
$db_selected = mysql_select_db('thomas', $link);
if (!$db_selected) {
    die ('Select db  : ' . mysql_error());
}


$yy       = substr($fdate, 0, 2);
$outfile  = "tnetlogCADIP.txt";
$of       = fopen($outfile, "w") or exit("Unable to open output file $outfile\n");

function PrepData ($data) {
	if($data=="?" || $data=="-")  {$data="";}
	$data = ereg_replace("\'", "", $data);
	$data = strtoupper($data);
	return($data);
} 

function GetCountry ($fld) {
        $result = mysql_query("SELECT countryname FROM thomnetacuitycountry  WHERE iso3='$fld'");
        $desc   = mysql_result($result, 0, "countryname");
        return($desc); 
} 

function GetState ($fld) {
        $result = mysql_query("SELECT regiondesc FROM thomnetacuityregion WHERE region='$fld'");
        $desc   = mysql_result($result, 0, "regiondesc");
        return($desc); 
} 

// get all ip addresses
$query    = "select distinct ipaddress as ip from thomtnetlogCADMAST$yy where date='$fdate' ";
$result   = mysql_query($query);
for ($i=0; $i<mysql_numrows($result); $i++){
	$record[$i] = mysql_result($result, $i, "ip");
}

// get block visitors
$query  = "SELECT orgblock FROM thomtnetlogORGflagBLOCK   WHERE orgblock>'' ";
$result = mysql_query($query);
for($i=0; $i<mysql_numrows($result); $i++) {
        $o          = trim(strtolower(mysql_result($result, $i, "orgblock")));
        $badorg[$o] = $o;
}  


  
// get extra isp visitors
$query   = "SELECT org FROM thomtnetlogORGflagExtra WHERE org>'' limit 10 ";
$result  = mysql_query($query);
for($i=0; $i<mysql_numrows($result); $i++) {
  	$o           = strtoupper(mysql_result($result, $i, "org"));
	$isporg[$o] = mysql_result($result, $i, "isp");
} 


// loop through ips
echo "\nDate: $fdate\nTotal IP's $max\n";
for ($i=0; $i<=count($record); $i++)
{
	#print "$i\t$record[$i]\n";
	$linenum++;
	$transID = time();
 
	// ckeck demand base first
	$query = "SELECT
              org, domain, city, state, zip, country, isp, naics, primary_sic, dunsnum, domestichqdunsnumber, hqdunsnumber,
              gltdunsnumber, countrycode, countrycode3, audience, audiencesegment, b2b, employee_range, forbes2k, fortune1k,
              industry, informationlevel, latitude, longitude, phone, revenue_range, subindustry
              FROM  thomdbaseIPresolved
              WHERE ip='$record[$i]'";
	$result = mysql_query($query);
	if(mysql_numrows($result) )
	{

		/********************* NetAcuity stopped March 2017
		// if level = basic go to NetAcuity table
		if(mysql_result($result, 0, "informationlevel") == "basic") 
		{
			$query    = "SELECT country, region, city, connspeed, metrocode, latitude, longitude, postalcode, countrycode, regioncode, citycode, continentcode, twolettercountry, internalcode, areacodes, countryconf, regionconf, cityconf, postalconf, gmtoffset, indst, domainname, companyname, naicscode, org, ispflag FROM thomnetacuityIPresolved WHERE  ip='$record[$i]' ";
			$nresult  = mysql_query($query);
			$org                  = PrepData(mysql_result($nresult, 0, "org")); 
			$domain               = PrepData(mysql_result($nresult, 0, "domainname"));
			$city                 = PrepData(mysql_result($nresult, 0, "city"));
			$state                = GetState(mysql_result($nresult, 0, "region")); 
			$state                = PrepData($state);
			$zip                  = PrepData(mysql_result($nresult, 0, "postalcode"));
			$country              = GetCountry (mysql_result($nresult, 0, "country"));
			$country              = PrepData($country);
			$isp                  = PrepData(mysql_result($nresult, 0, "ispflag"));
			$isp                  = strtoupper(substr($isp, 0, 1));
			//$isp                  = "y"; // default to isp
			$naics                = PrepData(mysql_result($nresult, 0, "naicscode")); 
			$primary_sic          = "";
			$dunsnum              = "";
			$domestichqdunsnumber = "";
			$hqdunsnumber         = "";
			$gltdunsnumber        = "";
			$countrycode          = PrepData(mysql_result($nresult, 0, "twolettercountry"));
			$countrycode3         = PrepData(mysql_result($nresult, 0, "country"));
			$audience             = "";
			$audiencesegment      = "";
			$b2b                  = "";
			$employee_range       = "";
			$forbes2k             = "";
			$fortune1k            = "";
			$industry             = "";
			$informationlevel     = "BASIC";
			$latitude             = PrepData(mysql_result($nresult, 0, "latitude")); 
			$longitude            = PrepData(mysql_result($nresult, 0, "longitude"));
			$phone                = "";
			$revenue_range        = "";
			$subindustry          = "";		 

		}
		else
		{
		**************************/

			$org                  = PrepData(mysql_result($result, 0, "org"));
			$domain               = PrepData(mysql_result($result, 0, "domain"));
			$city                 = PrepData(mysql_result($result, 0, "city"));
			$state                = PrepData(mysql_result($result, 0, "state"));
			$zip                  = PrepData(mysql_result($result, 0, "zip"));
			$country              = PrepData(mysql_result($result, 0, "country"));
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
		//}		

		if($badorg[$org]){ $block="Y"; }
		else             { $block="N"; }

		if($isp=="" || $isp=="true" || $isp=="y" ||  $isp=="Y") {$isp="Y";}
		else                                                    {$isp="N";}

 		if($isporg[$org]){ $isp="Y"; }
  
		if( preg_match("/fuck/", $org)  || preg_match("/asshole/", $org) ) { $block="Y";  }
		if( preg_match("/FUCK/", $org)  || preg_match("/ASSHOLE/", $org) ) { $block="Y";  }

 
		if($org != "" &&  $block!="Y")                   
		{ fputs($of, "$fdate\t$record[$i]\t$countrycode\t$country\t$state\t$city\t$latitude\t$longitude\t$zip\t$org\t$domain\t$isp\t$naics\t$primary_sic\t$dunsnum\t$domestichqdunsnumber\t$hqdunsnumber\t$gltdunsnumber\t$countrycode3\t$audience\t$audiencesegment\t$b2b\t$employeerange\t$forbes2k\t$fortune1k\t$industry\t$informationlevel\t$phone\t$revenuerange\t$subindustry\n"); }
		if ($linenum % 1000 == 0) { echo "$linenum\r"; }

		$country=$countrycode=$state=$city=$latitude=$longitude=$zip=$org=$domain=$isp=$naics=$primary_sic="";         
		$dunsnum=$domestichqdunsnumber=$hqdunsnumber=$gltdunsnumber=$countrycode3=$audience=$audiencesegment=$b2b="";  
		$block=$employeerange=$forbes2k=$fortune1k=$industry=$informationlevel=$phone=$revenuerange=$subindustry="";          
		}
 
}
fclose($of);
system("date");
system("mysqlimport  -rL thomas  /usr/wt/tnetlogCADIP.txt");
echo "Done...";
?>
