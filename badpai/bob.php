<?  
// Resolves IP addresses and load them into a table
// Run this last
// Run as: php -q load-adfiles3.php YYMM

require ("NetAcuity.php");
require ("countries.inc");

$MAXLINES = 10;                        
$ServerIp   = "";
$db_feature = "3,6,7,13,18";
 

 
/// PROCESS IP CLICKS ///
// get all ip addresses, resolve them and write to file
$i=0;   
$rf = fopen("ispin-test.txt", "r") or exit("Unable to open output file adcv.ls\n"); 
while (!feof($rf)) { 
  $adip .= fgets($rf, 4096);
  $adip = trim($adip);
  echo "$i) $adip\n";
  
  if (preg_match("/^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/", $adip))
   { 
     $netAcuity = new NetAcuity;
     $netAcuity->debugOn();
     $netAcuity->set_server_addr($ServerIp);
     $netAcuity->set_id("1");
     $netAcuity->set_timeout(1);
     $netAcuity = new NetAcuityXML($ServerIp, 100, 2);
     $returnCode = $netAcuity->queryAndParse($adip, $db_feature, $transID);
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
    
 
   $city = ucfirst($city);
   $co   = ucfirst($co);                   
   $countrycode3 = strtoupper($country);
     
   $reg  = strtoupper($reg);
   if($STLIST[$reg] != "") { $regionname = $STLIST[$reg]; }
   else                    { $regionname = $reg; }
   if($reg=="NO REGION")                { $regionname=""; }
   if (preg_match("/[0-9\.\-]/", $reg)) { $regionname=""; }
   
    print "$i)\t$adip\t$co\t$city\t$regionname\t$countrycode3\t$zip\t$ispflag\n"; 
 
             
  }   

 $cup=$adip=$co=$continentcode=$countrycode2=$countrycode3=$country=$reg=$city=$zip=$lat=$long=$dma=$areacode=$regionname=$ispflag="";  
 $adip = $org = $ispflag = $regionname = "";  
 $i++;
     
 #if($i==10000) {exit;} 

}
fclose($rf);

?>
 
