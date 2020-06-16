#!/usr/bin/php
<?php 
error_reporting(0);
date_default_timezone_set('EST');

echo "Stopped March 2017";
exit;

$link = mysql_pconnect('',  '', '');
if (!$link) {
    die('Not connected : ' . mysql_error());
}

$db_selected = mysql_select_db('thomas', $link);
if (!$db_selected) {
    die ('Select db  : ' . mysql_error());
}

   

require_once("/usr/wt/netacuity/NetAcuity.php");
$ServerIp   = "";
$db_feature = "4,6,15,18,25,14";
$created    = time();
$created    = 0; // update manually later

$outfile = "/usr/wt/netacuity/netacuityIPresolved.txt";
$of      = fopen($outfile, "w") or die("Unable to open output file $outfile\n");

// pull ip addresses,  created=0 will only pull new ips
// $query  = "SELECT * FROM thomdbaseIPold   limit 1000 "; //test
// $query  = "SELECT * FROM thomdbaseNetAcuityIP WHERE created=0 LIMIT 1000 "; //test
// $query  = "SELECT * FROM thomdbaseNetAcuityIP  limit 10 ";
 $query  = "SELECT * FROM thomdbaseNetAcuityIP WHERE ip='42.99.164.64'  ";
$query  = "SELECT * FROM thomdbaseNetAcuityIP WHERE created=0  ";
#$query  = "SELECT '192.35.35.34' as ip FROM thomdbaseNetAcuityIP  limit 1";

//echo "\n\n$query\n\n";  

$result = mysql_query($query);
for ($i=0; $i<mysql_numrows($result); $i++)
{
	$ip   = mysql_result($result, $i, "ip");
	//echo "$ip";
	$netAcuity  = new NetAcuity;
	$netAcuity->debugOn();
	$netAcuity->set_server_addr($ServerIp);
	$netAcuity->set_id("1");
	$netAcuity->set_timeout(1);
	$netAcuity  = new NetAcuityXML($ServerIp, 100, 2);
	$returnCode = $netAcuity->queryAndParse($ip, $db_feature, $transID);
	$tokenArray = $netAcuity->getResponseTable();
	//print_r ($tokenArray);

	// #4 db
	$country              = $tokenArray['edge-country'];
	$region               = $tokenArray['edge-region'];
	$city                 = $tokenArray['edge-city'];
	$connspeed            = $tokenArray['edge-conn-speed'];
	$metrocode            = $tokenArray['edge-metro-code'];
	$latitude             = $tokenArray['edge-latitude'];
	$longitude            = $tokenArray['edge-longitude'];
	$postalcode           = $tokenArray['edge-postal-code'];
	$countrycode          = $tokenArray['edge-country-code'];
	$regioncode           = $tokenArray['edge-region-code'];
	$citycode             = $tokenArray['edge-city-code'];
	$continentcode        = $tokenArray['edge-continent-code'];
	$twolettercountry     = $tokenArray['edge-two-letter-country'];
	$internalcode         = $tokenArray['edge-internal-code'];
	$areacodes            = $tokenArray['edge-area-codes'];
	$countryconf          = $tokenArray['edge-country-conf'];
	$regionconf           = $tokenArray['edge-region-conf'];
	$cityconf             = $tokenArray['edge-city-conf'];
	$postalconf           = $tokenArray['edge-postal-conf'];
	$gmtoffset            = $tokenArray['edge-gmt-offset'];
	$indst                = $tokenArray['edge-in-dst'];

	// # 6 db
	$domainname           = $tokenArray['domain-name'];

	// # 14 db
	$ispflag              = $tokenArray['is-an-isp'];

	// # 15 db
	$companyname          = $tokenArray['company-name'];

	// # 18 db
	$naicscode            = $tokenArray['naics-code'];

	// # 25 db
	$org                  = $tokenArray['organization-name'];

	fputs($of, "$ip\t$created\t$country\t$region\t$city\t$connspeed\t$metrocode\t$latitude\t$longitude\t$postalcode\t$countrycode\t$regioncode\t");
        fputs($of, "$citycode\t$continentcode\t$twolettercountry\t$internalcode\t$areacodes\t$countryconf\t$regionconf\t$cityconf\t$postalconf\t");
        fputs($of, "$gmtoffset\t$indst\t$domainname\t$companyname\t$naicscode\t$org\t$ispflag\n");

	if ($i % 1000 == 0) { echo "$i\r"; }
}

fclose($of);
?> 
