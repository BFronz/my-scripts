<?  
// Resolves IP addresses and load them into a table
// Run this last
// Run as: php -q load-adfiles3.php YYMM

require ("NetAcuity.php");
require ("countries.inc");

$MAXLINES = 10;                        
$ServerIp   = "";
$db_feature = "3,6,7,13,18";
 

$fdate  = $argv[1];
//if(!$fdate) {echo "\nForgot to add date YYMM\n\n"; exit;}
//$yy      = substr($fdate, 0, 2);

// connect to db
$link = mysql_connect('localhost', '', '');
if (!$link) {
    die('Not connected : ' . mysql_error());
}

$db_selected = mysql_select_db('thomas', $link);
if (!$db_selected) {
    die ('Select db  : ' . mysql_error());
} 


echo "\nProcessing\n\n";
 
// get known isps and put into an array
//$query   = "SELECT trim(org) AS org FROM tnetlogORGflag WHERE ( isp='Y' || block='Y' ) AND org>'' ";
//$result  = mysql_query($query);
//for ($i=0; $i<mysql_numrows($result); $i++)
// {                         
//  $iorg       = strtolower(mysql_result($result, $i, "org"));
//  $isp[$iorg] = $iorg;
// }

 
/// PROCESS IP CLICKS ///
// get all ip addresses, resolve them and write to file
$i=0;   
$rf = fopen("fpsatest.txt", "r") or exit("Unable to open output file fpsatest.txt\n"); 
$wf = fopen("webtraxs_news.txt", "w")   or exit("Unable to open output file webtraxs_news.txt\n"); 
while (!feof($rf)) { 
  $adip .= fgets($rf, 4096);
  $adip = trim($adip);
  #echo "$i) $adip\n"; 

  $flds = explode("\t", $adip);
  echo "$flds[0]\t$flds[1]\n";  
  
  if (preg_match("/^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/", $flds[1]))
   { 
     $netAcuity = new NetAcuity;
     $netAcuity->debugOn();
     $netAcuity->set_server_addr($ServerIp);
     $netAcuity->set_id("1");
     $netAcuity->set_timeout(1);
     $netAcuity = new NetAcuityXML($ServerIp, 100, 2);
     $returnCode = $netAcuity->queryAndParse($flds[1], $db_feature, $transID);
     $tokenArray = $netAcuity->getResponseTable();

     $country     = $tokenArray['country'];
     $countrycode = $tokenArray['two-letter-country'];
     $reg        = $tokenArray['region'];
     $city       = $tokenArray['city'];
     $dom        = $tokenArray['domain-name'];
     $zip        = $tokenArray['zip-code-text'];
     $co         = trim($tokenArray['dc-company-name']);
     $naics      = $tokenArray['naics-code'];
     $lat        = $tokenArray['latitude'];
     $long       = $tokenArray['longitude'];
         
     $co      = ereg_replace("\'", "", $co); 
     $city    = ereg_replace("\'", "", $city); 
     $state   = ereg_replace("\'", "", $state);   
     $country = ereg_replace("\'", "", $country); 
     $country = ereg_replace("\t", ",", $country); 
    
    $ispflag  = "N";
    if($isp[$co]){ $ispflag="Y"; }

   if(ereg("broadband", $org)  
   || ereg(" isp ", $org)       
   || ereg("chinanet", $org)  
   || ereg("ppox", $org) 
   || ereg("comcast", $org)       
   || ereg("cablevision", $org) 
   || ereg("internet service provider", $org) 
   || ereg(" internet ", $org)    
   || ereg(" telecom ", $org)   
   || ereg("bellsouth", $org)  
   || ereg("communication", $org)   
   || ereg("telcom", $org)
   || ereg("rogers cable", $org)
   || ereg("road runner", $org)
   || ereg("roadrunner", $org)
   || ereg("telekommunikations", $org)
   || ereg("virgin media", $org)
   || ereg("telefonica", $org)
   || ereg("telekom", $org)
   || ereg("dialup", $org)
   || ereg(" pool ", $org)
   || ereg("network", $org)
   || ereg("telephone", $org)
   || ereg("wideopenwest", $org)
   || ereg("telecomunikasi", $org)
   || ereg("celular", $org)
   || ereg("netlin", $org)
   || ereg("telecomunicaciones", $org)
   || ereg("t-mobile", $org)
   || ereg("cable", $org)
   || ereg("dsl ", $org)
   || ereg(" dsl ", $org)
   || ereg("tel�fonos", $org)
   || ereg("online", $org)
   || $co==""  )   { $ispflag="Y"; }        
 
   $city = ucfirst($city);
   $co   = ucfirst($co);                   
   $countrycode3 = strtoupper($country);
     

   #$reg  = strtoupper($reg);
   if($STLIST[$reg] != "") { $regionname = $STLIST[$reg]; }
   else                    { $regionname = $reg; }
   if($reg=="NO REGION")                { $regionname=""; }
   if (preg_match("/[0-9\.\-]/", $reg)) { $regionname=""; }

    #$ProfileSiteKey,$yearmonth,$cid,$org,$city,$reg,$country,$HeadingName,$LinkType,$clickthroughtime,$InitialVisitTime
 
   $yyyymm = substr($flds[0], 0, 4) . substr($flds[0], 2, 2);
 
    $reg= strtolower($reg);
    $city= strtolower($city);
    $co= strtolower($co);
    $countrycode3= strtolower($countrycode3);
 
 
    echo "$i) 1\t$yyyymm\t30463548\t$co\t$city\t$regionname\t$countrycode3\t0\tnews ad link\t$flds[0]\t$flds[0]\n";
   fputs($wf, "1\t$yyyymm\t30463548\t$co\t$city\t$regionname\t$countrycode3\t0\tnews ad link\t$flds[0]\t$flds[0]\n");

              
  }   

 $cup=$adip=$co=$continentcode=$countrycode2=$countrycode3=$country=$reg=$city=$zip=$lat=$long=$dma=$areacode=$regionname=$ispflag="";  
 $adip = $org = $ispflag = $regionname = "";  
 $i++;
     
 #if($i==10000) {exit;} 

}
fclose($rf);
fclose($wf);
   

echo "\nRecord count: $i\n";
?>
 
