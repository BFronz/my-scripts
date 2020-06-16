#!/usr/local/bin/php
<?php
$outfile   = "position_popz.txt";
$rdate     = " '1601','1602','1603' ";

error_reporting(0);
   
# load position_popz tables first                                       
# INSERT  INTO position_popz_se (acct,heading,covflag,us)  SELECT acct,heading,covflag,sum(us) FROM  thomqlog16Y WHERE date in ( '1601','1602','1603' ) GROUP BY acct,heading,covflag;
# INSERT IGNORE INTO position_popz_se_total (heading,covflag,us) SELECT heading,covflag, SUM(cnt) FROM quickUS16 WHERE date in ( '1601','1602','1603' ) GROUP BY heading,covflag;  

# open file
$of = fopen($outfile, "w") or exit("Unable to open output file $outfile\n");

# db connect
$link = mysql_pconnect('charon.rds.c.net',  'dbadmin', 'at1prabhst');
if (!$link) {
    die('Not connected : ' . mysql_error());
}
$db_selected = mysql_select_db('tgrams', $link);
if (!$db_selected) {
    die ('Select db  : ' . mysql_error());
}
   
# total supplier evaluation array
$query = "SELECT heading, us FROM thomposition_popz_se_total WHERE covflag='n' AND heading>0  ";
$result = mysql_query($query, $link);
for ($i=0;  $i < mysql_numrows($result); $i++ )  
{  
	$h = mysql_result($result, $i, "heading");
	$us = mysql_result($result, $i, "us");
	$setotal[$h] = $us;
} 

# pull rank data       
$query = "SELECT * FROM tgrams.position WHERE cov='NA' AND adv=1 ";
//$query .= " AND acct in (587988,643,1559, 3392, 3565, 3890, 5301, 5309, 7407, 9112,11367,16160,16161,17235,19133,19453,19539,21067,21111,21967,23170,23173,24165,28595,30243,30716)  ";
$query .= "ORDER BY heading, pos ";
//$query .= "LIMIT 100000";
$result = mysql_query($query, $link);
for ($i=0;  $i < mysql_numrows($result); $i++ ) 
{ 
	$acct     = mysql_result($result, $i, "acct");
	$heading  = mysql_result($result, $i, "heading");
	$cov      = mysql_result($result, $i, "cov");
	$pos      = mysql_result($result, $i, "pos");
	$adv      = mysql_result($result, $i, "adv");
	$pop      = mysql_result($result, $i, "pop");
	$premiums = mysql_result($result, $i, "premiums");
	$p1       = mysql_result($result, $i, "p1");
	$p2       = mysql_result($result, $i, "p2");
	$p3       = mysql_result($result, $i, "p3");
	$p4       = mysql_result($result, $i, "p4");
	$p5       = mysql_result($result, $i, "p5");
	$p6       = mysql_result($result, $i, "p6");
	$p7       = mysql_result($result, $i, "p7");
	$p8       = mysql_result($result, $i, "p8");
	$p9       = mysql_result($result, $i, "p9");
	$p10      = mysql_result($result, $i, "p10");
	$p15      = mysql_result($result, $i, "p15");
	$p20      = mysql_result($result, $i, "p20");
	$p25      = mysql_result($result, $i, "p25");

	//echo "$i. $heading\n";
	if ($i%1000 == 0) { print "$i\r"; }

	if($cov=='NA') { $covflag = "n";  }
	else           { $covflag = $cov; }
        
	# pull se at acct & heading                          
	$subq    = "SELECT us AS se FROM thomposition_popz_se WHERE acct = '$acct'  AND heading='$heading'  AND covflag='$covflag'  ";
	$sresult = mysql_query($subq, $link); 
 	if (mysql_numrows($sresult)) {  $se = mysql_result($sresult, 0, "se"); } 	
 	if($se == "") {  $se = "0"; }	
	 
	# check for total se
	if( $setotal[$heading] != "")  {  $se_total = $setotal[$heading] ; }
 	else                           {  $se_total = "0"; }		

	fputs($of, "$acct\t$heading\t$cov\t$pos\t$adv\t$pop\t$premiums\t$p1\t$p2\t$p3\t$p4\t$p5\t$p6\t$p7\t$p8\t$p9\t$p10\t$p15\t$p20\t$p25\t$se\t$se_total\n");
	$se = $se_total = 0;
}

system("mysqlimport  -dL thomas  /usr/wt/$outfile");


?> 
