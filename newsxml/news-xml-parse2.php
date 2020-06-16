<?php
// Run as php -q news-xml-parse2.php 
// Run this second
// CHANGE DATE FIELD: date = YYMM

$date  = $argv[1];
if(!$date) {echo "\nForgot to add date YYMM\n\n"; exit;}
$yy      = substr($date, 0, 2);

echo "Date: $date";
 
//$date    = "1205";
$badimg  = "N";

set_time_limit(3600);
$yy      = substr($date, 0,  2);
$xmlfile = "newsdata" . $date . ".xml";
$outfile = "news_ad_cat" . $yy . ".txt";

echo "DATE: $date \n\n";

function GetFld ($word, $data){
 if( eregi( "<$word>", $data) )
   {          
    $field = eregi_replace("<$word>",  "", $data); 
    $field = eregi_replace("</$word>", "", $field);
    $field = trim($field);
   }
 return $field; 
}
            
$of = fopen($outfile, "w") or exit("Unable to open input file $outfile\n");
 
$rf = fopen($xmlfile, "r") or exit("Unable to open input file $xmlfile\n");
while (!feof($rf) )
  {
   $oneline = fgets($rf, 10000);
   $oneline = trim($oneline);
      
   if( eregi( "<Advertiser>",   $oneline) )  { $Advertiser   = GetFld ("Advertiser",   $oneline); }                     
   if( eregi( "<AdvertiserID>", $oneline) )  { $AdvertiserID = GetFld ("AdvertiserID", $oneline); }   
   #if( eregi( "<AdveristerCid>",$oneline) ) { $AdveristerCid= GetFld ("AdveristerCid",$oneline); } 
   if( eregi( "<AdveristerCID>",$oneline) )  { $AdveristerCID= GetFld ("AdveristerCID",$oneline); } 
   if(!$cidhold){$cidhold=$AdveristerCID;}    // used for the first time in 
    
   if($AdveristerCID == $cidhold)   // on going account data
    {     
     if( eregi( "<Campaign>",            $oneline) ) { $Campaign            = GetFld ("Campaign",            $oneline); }
     if( eregi( "<CampaignID>",          $oneline) ) { $CampaignID          = GetFld ("CampaignID",          $oneline); }
     if( eregi( "<CampaignType>",        $oneline) ) { $CampaignType        = GetFld ("CampaignType",        $oneline); }
     if( eregi( "<BannerID>",            $oneline) ) { $BannerID            = GetFld ("BannerID",            $oneline); }
     if( eregi( "<BannerCategory>",      $oneline) ) { $BannerCategory      = GetFld ("BannerCategory",      $oneline); }
     if( eregi( "<BannerImageURL>",      $oneline) ) { $BannerImageURL      = GetFld ("BannerImageURL",      $oneline); }
     if( eregi( "<BannerViews>",         $oneline) ) { $BannerViews         = GetFld ("BannerViews",         $oneline); }
     if( eregi( "<BannerClicks>",        $oneline) ) { $BannerClicks        = GetFld ("BannerClicks",        $oneline); }
     if( eregi( "<CampaignTotalViews>",  $oneline) ) { $CampaignTotalViews  = GetFld ("CampaignTotalViews",  $oneline); }
     if( eregi( "<CampaignTotalClicks>", $oneline) ) { $CampaignTotalClicks = GetFld ("CampaignTotalClicks", $oneline); } 
 
     if( eregi( "</BannerClicks>", $oneline) ) // write to file at this point 
      {   
       /*date
       Advertiser
       AdvertiserID
       AdveristerCid
       Campaign
       CampaignID
       CampaignType
       BannerID
       BannerCategory 
       BannerImageURL
       BannerViews
       BannerClicks*/

       fputs($of, "$date\t$Advertiser\t$AdvertiserID\t$AdveristerCid\t$Campaign\t$CampaignID\t$CampaignType\t$BannerID\t");
       fputs($of, "$BannerCategory\t$BannerImageURL\t$BannerViews\t$BannerClicks\t$badimg\n");
 
       echo "Advertiser: $Advertiser\nAdvertiserID: $AdvertiserID\nAdveristerCid:$AdveristerCid\n";
       echo "Campaign: $Campaign\nCampaignID: $CampaignID\nCampaignType:$CampaignType\n";
       echo "BannerID: $BannerID\nBannerCategory:$BannerCategory\nBannerImageURL:$BannerImageURL\n";
       echo "BannerViews:$BannerViews\nBannerClicks:$BannerClicks\n";
       echo "+++++++++++++++++++++++++++++++++++++++++\n";
          
       $BannerID = $BannerCategory = $BannerImageURL = $BannerViews = $BannerClicks = "";
      } 
    }
   else  // must be a new acount, reload hold var 
    {
     $cidhold=$AdveristerCid;
    }
}

fclose($of);
fclose($rf);
?>
