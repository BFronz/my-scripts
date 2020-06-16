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

$outfile  = "main-table-rpt-new-2.txt";
$of       = fopen($outfile, "w") or exit("Unable to open output file $outfile\n");
fputs($of, "acct \tcompany\tad-dollars\tPrimary Classification\tClassification(s)\n");
   
  
$i=0;
$query = "SELECT acct,company,ad_dollars, activity, cotype from tgrams.main where adv>''  order by company  ";

echo "\n$query\n";
$result  = mysql_query($query, $link);
for ($i=0;  $i < mysql_numrows($result); $i++ )
	{   
		$alink = $acct = $comp = $activity = $clink =""; 

		$acct     = mysql_result($result, $i, "acct");
		$comp     = mysql_result($result, $i, "company");
		$ad       = mysql_result($result, $i, "ad_dollars");
		$activity = mysql_result($result, $i, "activity");
		$cotype   = mysql_result($result, $i, "cotype");
	    
        if(ereg("D", $cotype)){ $clink = "Distributor"; }
        if(ereg("M", $cotype)){
 
                $clink .= "Manufacturer";
        } 
        if(ereg("C", $cotype)){
          
                $clink .= "Custom Manufacturer";
        } 
        if(ereg("R", $cotype)){
          
                $clink .= "Manufacturers' Rep";
        }
        if(ereg("S", $cotype)){
          
                $clink .= "Service Company";
        }  
        if(ereg("F", $cotype)){
          
                $clink .= "Finishing Service Company";
        } 
        if(ereg("I", $cotype)){
          
                $clink .= "Turnkey Systems Integrator";
        } 
        if(ereg("T", $cotype)){
          
                $clink .= "Trade Association";
        } 


	//if($clink ==""){$clink =$cotype;}

 /*
	D"=>"Distributor", 
                "M"=>"Manufacturer", 
                "C"=>"Custom Manufacturer", 
                "R"=>"Manufacturers' Rep", 
                "S"=>"Service Company",
                "F"=>"Finishing Service Company",
                "I"=>"Turnkey Systems Integrator",
                "T"=>"Trade Association",
*/

 
		
 
	$has="0";
        if(ereg("D", $activity)){ $alink = "Distributor\t";  $has++; }
        if(ereg("M", $activity)){

                $alink .= "Manufacturer\t"; $has++;
        } 
        if(ereg("C", $activity)){
          
                $alink .= "Custom Manufacturer\t"; $has++;
        } 
        if(ereg("R", $activity)){
          
                $alink .= "Manufacturers' Rep\t"; $has++;
        }
        if(ereg("S", $activity)){
          
                $alink .= "Service Company\t"; $has++;
        } 

        if(ereg("F", $activity)){
          
                $alink .= "Finishing Service Company";
        } 
        if(ereg("I", $activity)){
          
                $alink .= "Turnkey Systems Integrator";
        } 
        if(ereg("T", $activity)){
          
                $alink .= "Trade Association";
        } 



 
//if($has=="0") { $alink=$activity; } 
      
 
 echo "$i) $acct \t$comp\t$ad\t$clink\t$alink\n";
  
fputs($of, "$acct \t$comp\t$ad\t$clink\t$alink\n");


} 

fclose($of);
 
echo "\nDone...\n";
?>
