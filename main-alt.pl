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

$outfile  = "main-table-rpt-new-alt.txt";
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
	     
 echo "$i) $acct \t$comp\t$ad\t$cotype\t$activity\n";
  
fputs($of, "$acct \t$comp\t$ad\t$cotype\t$activity\n");


} 

fclose($of);
 
echo "\nDone...\n";
?>
