<?php
error_reporting(0);
$fdate=$argv[1];

$readfile = "news_adserver_banners.xml";
if (!($rf = fopen($readfile, "r"))) {  die("could not open XML input"); }
 
$writefile = "ad_xtenit_id.txt";
if (!($wf = fopen($writefile, "w"))) {  die("could not open XML output"); }

function ParseLine ($tag){
 global $oneline;
 if( eregi( "<$tag>", $oneline) )
  {
   $val = ereg_replace("<$tag>",  "", $oneline);
   $val = ereg_replace("</$tag>", "", $val);
   $val = trim($val);
   return $val;
 }
}
 
while (!feof($rf) )
{
 $oneline = fgets($rf, 10000);
 $oneline = trim($oneline);
                               
  if(!$CID)            { $CID       = ParseLine ("CID"); }
  if(!$BannerID)       { $BannerID  = ParseLine ("BannerID");}
  if(!$BannerImageURL) { $BannerImageURL  = ParseLine ("BannerImageURL");}
   
  # write  data
  if ( ereg("</AdBlock>", $oneline) ) 
   {               
    #echo "$CID\t$BannerID\t$BannerImageURL\n";
    fputs($wf,  "$CID\t$BannerID\t$BannerImageURL\t\n");
    $CID = $BannerID = $BannerImageURL = "";
   }  
 
}

fclose($rf);
fclose($wf);
?>

