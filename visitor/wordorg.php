<?php
date_default_timezone_set('EST');
error_reporting(0);
$link = mysql_pconnect('',  '', '');
if (!$link) {
    die('Not connected : ' . mysql_error());
}

$db_selected = mysql_select_db('thomas', $link);
if (!$db_selected) {
    die ('Select db  : ' . mysql_error());
}

$dbtin  = "tgrams";
$dbtrd  = "trdaily";
$dbtr   = "tr";
$dbcmg  = "cmg";
$dbtom  = "thomas";
$dbpnn  = "pnn";


//$test =1;
$EXCLUDE[inc]	= 1;
$EXCLUDE[co]	= 1;
$EXCLUDE[corp]	= 1;
$EXCLUDE[the]	= 1;
$EXCLUDE[llc]	= 1;
$EXCLUDE[ltd]	= 1;
  
// error_reporting(255);
require "stem.inc";
 

function FormatWords($acct,$vhd){ //leave "acct" here, doesn't matter for process
  global $OF,$WF, $what, $EXCLUDE;
  $cleanname=CheckInput();

  $tok    = explode(" ", $cleanname);
  $newclean	= "";
  for($i=0; $i < count($tok); $i++) {
	$val	= $tok[$i];
	if(!$EXCLUDE[$val]){
         if($vhd) { fputs ($WF, "$val\t$vhd\t$acct\n"); }
         else     { fputs ($WF, "$val\t$acct\n"); }
	}
  }

  /* decided not to stem
  $what=trim($newclean);
  $stemname = CheckProdInput();
   
  $tok    = explode(" ", $newclean);
  for($i=0; $i < count($tok); $i++) {
	$val	= $tok[$i];
       if($vhd) { fputs ($WF, "$val\t$vhd\t$acct\n"); }
       else     { fputs ($WF, "$val\t$acct\n"); }
  }  
 */
 
}

# make organization word table
$WF = fopen("wordorg2.txt", "w"); 
$query = "select oid, org ";
$query .= "from thomvisitor_tool "; 
//$query .= "where orgid>'' and isp='N' and block='N' and length(org)>1 and checked=''  ";
$query .= "where orgid>'' and  length(org)>1 and checked=''  ";
$query .= "order by ocleanname ";
if($test) { $query .= "limit 1000 "; }
$result = mysql_query($query);
for ($i=0; $i<mysql_numrows($result); $i++)
  {
   if ($i % 1000 == 0) { print "$i\r"; }
   $oid = mysql_result($result, $i, "oid");
   $what = mysql_result($result, $i, "org");
   FormatWords($oid,$vhd);  
}
fclose($WF);


?>
