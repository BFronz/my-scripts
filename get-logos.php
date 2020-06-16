#!/usr/local/bin/php
<?php
set_time_limit(3600);
date_default_timezone_set('EST');
//error_reporting(0);

system("date");

$link = mysql_pconnect('',  '', '');
if (!$link) {
    die('Not connected : ' . mysql_error());
}
$db_selected = mysql_select_db('thomas', $link);
if (!$db_selected) {
    die ('Select db  : ' . mysql_error());
}

include_once("simple_html_dom.php");
  
$i=0;
$query = "SELECT domain, org, oid, count(*) as n FROM thomtnetlogORGD15_08W WHERE domain>'' AND isp='N' GROUP BY domain ORDER BY n DESC ";
$query .= "limit 350, 20 ";
echo "\n$query\n";
$result  = mysql_query($query, $link);
for ($i=0;  $i < mysql_numrows($result); $i++ )
	{   
		$dom[$i] = mysql_result($result, $i, "domain");
		$org[$i] = mysql_result($result, $i, "org");
		$oid[$i] = mysql_result($result, $i, "oid");
	}  
 


for($i=0; $i<count($dom); $i++){
	echo "$i $org[$i]\t$dom[$i]\n";
 
	$domfull = "http://". $dom[$i];
     
	$html = file_get_html($domfull);

	foreach($html->find('img') as $element) { 
		$img =  $element->src;				   
		 if(preg_match("/logo/", $img)) 
			{ 
				if(preg_match("/$dom[$i]/", $img)) { $urlimg = $img; }
				else                               { $urlimg = $domfull . "/"  . $img; }
				
				echo "$urlimg\n";

				$path = parse_url($urlimg, PHP_URL_PATH);
				$pathFragments = explode('/', $path);
				$end = end($pathFragments);
   
				$ch = curl_init($curlimg);
				$fp = fopen('logos/$end', 'wb');
				curl_setopt($ch, CURLOPT_FILE, $fp);
				curl_setopt($ch, CURLOPT_HEADER, 0);
				curl_exec($ch);
				curl_close($ch);
				fclose($fp);
  
		 	}
	}  

echo "\n--------------------------\n";
} 
 
echo "\nDone...\n";
?>
