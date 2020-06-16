#!/usr/bin/perl
#
#

use DBI;
$scorpioDB = 1;
require "/usr/wt/trd-reload.ph";

#### date variables ####
$startdate = "1706"; 
$rdate     = " '1706' ";
$unix_start_date = 1438401600;
$unix_end_date   = 1472702400;
$outfile   = "catalog-on-" . $startdate  . "-new.txt";
#$limit = 50;          # for testing
#$testacct =  30145560; # for testing
########################

sub PrintQ
{
 $q = $_[0];
 #print "\n$q\n";
} 

sub PV
{
 $v = $_[0];
 #print "\n$v\n";
}

system("rm -f $outfile");
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
 

print wf "Client Name\t";
print wf "Tgrams\t";
print wf "User Sessions\t";
print wf "Conversions\t";
print wf "Profile Views\t";
print wf "Flat Links to Catalog/CAD\t";
print wf "Flat Catalog Page Views\n";

 
$i=0;
$query  = "SELECT m.company, m.acct  "; 
$query .= "FROM tgrams.main AS m, thomflat_catnav_summmaryM AS a ";
$query .= "WHERE m.acct=a.tgramsid AND date IN ($rdate)  ";
#$query .= "  AND m.acct in (144221, 30145560, 452870)  "; 
if($testacct ne "") {  $query .= "AND m.acct='$testacct' ";  }
$query .= "GROUP BY  m.acct ORDER BY m.company ";
if($limit ne "") { $query .= "LIMIT $limit "; } 
PrintQ($query);
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
   $$row[0] =~ s/\|//g;
   $record[$i]="$$row[0]|$$row[1]";
   $i++;
 }
$sth->finish;

$z=1;
foreach $record (@record)
{
 ($comp, $acct) = split(/\|/,$record);


 print "$z.\t $comp\t $acct\n";

 $acctmap = "0";
 $q = "SELECT dupe FROM tgrams.main_map WHERE prime='$acct'  ";
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $acctmap = "$$row[0],";
  }
 $sth->finish;
 $acctmap .= $acct;


 # Total User Sessions
 $us="0";
 $q  = "SELECT sum(us) FROM   thomtnetlogARTU  WHERE acct IN ($acctmap) AND date in ($rdate) ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {
 	$us = $$row[0];
 }
 $sth->finish;
if($us eq "") {$us="0";}


# Total Conversion Actions, Links to Website, Profile Views, Press Release Views, Links to Catalog/CAD

	$profile = $us = $links =  $conv =  $cad_cat_links = $vv = $dv = $iv = 0;
	
  	$query = " select sum(pv) as prof, sum(us) as uses, sum(ln) as links,  ";
	$query .= " sum(pv) + sum(ln) + sum(cl) + sum(cv) + sum(ca) + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv) + sum(lc)+ sum(cd)  as tot, ";
	$query .= "  SUM(lc)+SUM(cl)  AS cadlinks, ";
	$query .= " SUM(vv), SUM(dv), SUM(iv)  ";
  	$query .= " from tnetlogARTU where acct in ($acctmap) and date in ($rdate) and covflag='t' ";
	PrintQ($query);
	
	my $sth = $dbh->prepare($query);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	if (my $row = $sth->fetchrow_arrayref)
		{
		  $profile = $$row[0];
		  $us      = $$row[1];
		  $links   = $$row[2];
		  $conv    = $$row[3];
		  $cad_cat_links =$$row[4];

		  $vv      = $$row[5];
		  $dv      = $$row[6];
		  $iv      = $$row[7];
		}
	$sth->finish;

	PV("\nconv $conv");  
 

	$totnews = $press_rel =0;
	$q = "SELECT sum(nsv) + sum(ncc) + sum(nes) + sum(nlw) AS tot, SUM(nsv) AS pr  ";
	$q .= " FROM thomnews_conversions WHERE acct IN ($acctmap) AND date IN ($rdate) ";
	PrintQ($q); 
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
		$totnews   = $$row[0];
		$press_rel   = $$row[1];
	}
	if($totnews eq ""){$totnews = "0";}
	if($press_rel eq ""){$press_rel = "0";}
 	$conv += $totnews;
	PV("news $totnews");  
     
	$caton =  $thomas_catalog_views = "0";
	#$q = "SELECT SUM(totalpageviews) + sum(totalInq) + sum(totalordrfqs), SUM(totalpageviews) ";
	$q = "SELECT SUM(totalpageviews) + sum(totalInq), SUM(totalpageviews) ";
	$q .= "FROM thomflat_catnav_summmaryM WHERE tgramsid IN ($acctmap) AND date IN ($rdate)   ";
	PrintQ($q);
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
 		$caton    = $$row[0];
 		$thomas_catalog_views    = $$row[1];
	}
	if($caton==""){$caton="0";}
	if( $thomas_catalog_views==""){$thomas_catalog_views="0";}
 	$conv += $caton;
	PV("caton $caton");   
 
	$catoff = 0;
	$query = "SELECT SUM(totalpageviews) + sum(totalInq + totalordrfqs)   ";
	$query = "SELECT SUM(totalpageviews) + sum(totalInq)   ";
	$query .= "FROM thomcatnav_summmaryM WHERE tgramsid in ($acctmap) and isactive='yes' and date in ($rdate) ";
	PrintQ($query);
	my $sth = $dbh->prepare($query);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	if (my $row = $sth->fetchrow_arrayref)
	{
		$catoff = $$row[0];
	}
	$sth->finish;
	if($catoff==""){$catoff="0";}
	$conv += $catoff;
	PV("catoff $catoff");  

	$adclicks = $adviews  = 0;
	$q = "SELECT sum(clicks) AS adclicks FROM thomtnetlogADviewsServerM ";
	$q .= "WHERE acct IN ($acctmap) AND adtype in ('bad','pai','phd') AND fdate IN ($rdate)  ";
	PrintQ($q);
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
 		$adclicks = $$row[0];
	}
	if($adclicks eq "") {$adclicks=0;}
	$conv += $adclicks;
	PV("badpai $adclicks");  
   
	$bad_ad_clicks =0;
	$q = "select sum(BannerClicks) as c FROM thomnews_ad_cat where AdvertiserCid in ($acctmap) and CampaignType = 'Program Ad Dominance Premium' and date in ($rdate) ";
	PrintQ($q); 
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{  
 	$bad_ad_clicks  = $$row[0];
	}  
        if($bad_ad_clicks eq "") {$bad_ad_clicks=0;}
        $conv += $bad_ad_clicks;	
 	PV("bad $bad_ad_clicks");  

	$adviews = $adclicks = "0";
	$q = "SELECT  sum(BannerClicks) AS adclicks, sum(BannerViews) AS adviews FROM thomnews_ad_cat ";
	$q .= "WHERE AdvertiserCid in ($acctmap) AND date  IN ($rdate)   AND badimg='N' ";
	$q .= " AND ( CampaignType in ( 'Company Specific Full Story','IMT Blog SkyRight','Keyword LeaderBoard','Keyword Specific Full Story','LeaderBoard','MachBlog Link Banner','PNA-IMT Tracking','tnet Network','Tradeshow Tracking / Other','Brand Impact','Category Sponsor','Complementing (Family Level) Ad', 'Complementing (Category Level) Ad', 'Foundation/Company Specific Full Story' ) || CampaignType in ( 'ROS Campaign - No Heading', 'Run Of Site Offer' ,'True Run of Site','Tradeshow Banner','Tradeshow Tracking / Other' ) )   ";
	PrintQ($q);   
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
		$adclicks  = $$row[0];
		$adviews  = $$row[1];
	}
	if($adviews eq "")  {$adviews=0;}
	if($adclicks eq "") {$adclicks=0;}
	$conv += $adclicks;
	PV("display $adclicks");  
	PV($conv);
 
	$totalpageviews =0;
  $q= "SELECT SUM(totalpageviews) AS totalpageviews, sum(totalInq) as totalemailpage, sum(totalses) as totalses, 
      sum(totalItemdetailviews + totalassetdlviews + totalitemcomparison + totalprintpages + totalsavefav + totalemailpage) as totalconv 
      FROM thomflat_catnav_summmaryM WHERE tgramsid in ($acctmap) and isactive='yes' and date IN ($rdate) "; 
  PrintQ($q);
  my $sth = $dbh->prepare($q);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
  {
 	$totalpageviews = $$row[0];
  }
  $sth->finish;
 if($totalpageviews eq ""){$totalpageviews ="0";}  
 


 print wf "$comp\t";                     #  Account Name   
 print wf "$acct\t";                     #  Account Number
  
 print wf "$us\t";                       #  Total User Sessions
 print wf "$conv\t";                     #  Total Conversion Actions
 print wf "$profile\t";                  #  Profile Views

 print wf "$cad_cat_links\t";            #  Links to Catalog/CAD
 print wf "$totalpageviews\n";            #  total page views
  
$us =  $conv = $profile = $cad_cat_links = $totalpageviews=0;

 $z++;

}

close(wf);

$dbh->disconnect;

print "\n\nDone...\n\n";
