#!/usr/bin/perl
#
#

use DBI;
$scorpioDB = 1;
require "/usr/wt/trd-reload.ph";

#### date variables ####
$outfile   = "August2015MediaCycleClients_new.txt";
$startdate = "1508"; 
$rdate     = " '1508','1509','1510','1511','1512','1601','1602','1603','1604','1605','1606','1607' ";
$unix_start_date = 1438401600;
$unix_end_date   = 1472702400;
#$limit = 50;          # for testing
#$testacct =  323694 ; # for testing
########################

sub PrintQ
{
 $q = $_[0];
# print "\n$q\n";
}


system("rm -f $outfile");
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");

print wf "Account Number\t";
print wf "Account Name\t";
print wf "Account Total Spend\t";
print wf "Editorial: City\t";
print wf "Editorial: State\t";
print wf "Editorial: Primary Company Type\t";
print wf "Editorial: All Activities\t";
print wf "Editorial: Paid Listing Count\t";
print wf "Editorial: Bold Listing Count\t";
print wf "Editorial: Brand Data Y/N\t";
print wf "Highest Paid Category\t";
print wf "2nd Highest Paid Category\t";
print wf "Family of Highest Paid Category\t";
print wf "Family of 2nd Highest Paid Category\t";
print wf "Total User Sessions\t";
print wf "Total Conversion Actions\t";
print wf "Call Tracking Phone Sales Inquiries\t";
print wf "Total Call Tracking Phone Calls\t";
print wf "Mirror Site Tracking Phone Inquiries\t";
print wf "Total Mirror Site Tracking  Phone Calls\t";
print wf "Sales Inquiry tnet RFIs\t";
print wf "Total tnet RFIs\t";
print wf "Links to Website\t";
print wf "Profile Views\t";
print wf "Press Release Views\t";
print wf "Links to Catalog/CAD\t";
print wf "Catalog Page Views on tnet\t";
print wf "Display Ad Impressions\t";
print wf "Display Ad Clicks\t";
print wf "Category Specific Ad Dominance Impressions\t";
print wf "Category Specific  Ad Dominance Clicks\t";
print wf "Program Ad Dominance / Dominance Premium Impressions\t";
print wf "Program Ad Dominance / Dominance Premium Clicks\t";
print wf "Paid Category Ad Dominance / Dominance Premium Impressions\t";
print wf "Paid Category Ad Dominance / Dominance Premium Clicks\t";
print wf "Quanity of Co/Org Visitor Names on Display\t";
print wf "CCP Logo Y/N\t";
print wf "CCP Video Views\t";
print wf "CCP Document Views\t";
print wf "CCP Image Views\t";
print wf "Quantity Preview Ads\t";
print wf "Web Traxs Y/N\n";
 
$i=0;
$query  = "SELECT m.company, m.acct,  ad_dollars, city, state, trim(cotype)  ";
$query .= "FROM tgrams.main_history AS m, tgrams.adunits_hist AS a ";
$query .= "WHERE m.acct=a.acct AND rectype='CT' AND prodgrp in ('TSPEC','TRINET') AND FROM_UNIXTIME(startdate, '%y%m') = '$startdate' ";

if($testacct ne "") {  $query .= "AND m.acct='$testacct' ";  }
$query .= "GROUP BY  m.acct ORDER BY m.company ";
if($limit ne "") { $query .= "LIMIT $limit "; } 
PrintQ($query);
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
   $$row[0] =~ s/\|//g;
   $record[$i]="$$row[0]|$$row[1]|$$row[2]|$$row[3]|$$row[4]|$$row[5]";
   $i++;
 }
$sth->finish;



$z=1;
foreach $record (@record)
{

 # Account Number, Account Name, Account Total Spend, Editorial: City, Editorial: State
 ($comp, $acct, $ad_dollars, $city, $state, $cotype) = split(/\|/,$record);



 # Editorial: Primary Company Type
 	#$main_act{$cotype}


 # Ad dollars - need to pull from special table
 $ad_dollars="";
 $q  = "SELECT ad_dollars FROM tgrams.main_20151024   WHERE acct='$acct' ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {
 	$ad_dollars = $$row[0];
 }
 $sth->finish;
 if($ad_dollars=="") {$ad_dollars="0";}

 print "$z. $comp\t$ad_dollars\n"; 


 # Editorial: All Activities
 $all_activities="";
 $q  = "SELECT DISTINCT(description) FROM  tgrams.company_detail   WHERE acct='$acct' ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {
 	$all_activities .= "$$row[0], ";
 }
 $sth->finish;
 $all_activities = substr($all_activities, 0, -2);  
 

 # Editorial: Paid Listing Count
 $paid_listing="0";
 $q  = "SELECT count(distinct heading) FROM  tgrams.position WHERE acct = '$acct'  AND pop>0  ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {
 	$paid_listing = $$row[0];
 }
 $sth->finish;


 # Editorial: Bold Listing Count
 $bold_listing="0";
 $q  = "SELECT count(distinct heading) FROM  tgrams.position WHERE acct = '$acct'   ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {
 	$bold_listing = $$row[0];
 }
 $sth->finish;


 # Editorial: Brand Data Y/N
 $brand="N";
 $q  = "SELECT count(*) FROM  tgrams.brandco WHERE acct = '$acct'   ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {
  	if($$row[0] gt "0"){$brand='Y';}
	else  {$brand='N';}
 }
 $sth->finish;

 # Get first & second categories
 $first_hd = $first_pop =  $first_desc = "";
 $q  = "SELECT h.description, p.heading, p.pop FROM tgrams.position AS p, tgrams.headings AS h WHERE p.heading=h.heading AND p.acct='$acct' ORDER BY p.pop desc LIMIT 1";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {
	$first_desc = $$row[0];
  	$first_hd = $$row[1];
  	$first_pop = $$row[2];
 }
 $sth->finish;

 $second_hd = $second_desc ="";
 $q  = "SELECT h.description, p.heading, p.pop FROM tgrams.position AS p, tgrams.headings AS h ";
 $q .= "WHERE p.heading=h.heading AND p.acct='$acct' AND p.heading!='$first_hd' AND p.pop!='$first_pop' ORDER BY p.pop desc LIMIT 1";

 $q  = "SELECT h.description, p.heading, p.pop FROM tgrams.position AS p, tgrams.headings AS h WHERE p.heading=h.heading AND p.acct='$acct' AND p.heading!='$first_hd'  ORDER BY p.pop desc LIMIT 1";

 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {
        $second_desc = $$row[0];
  	$second_hd = $$row[1];
 }
 $sth->finish;

 # Family of Highest Paid Category
 $first_family_desc ="";
 $q  = "SELECT FamilyCategoryName FROM directorytax.taxonomy AS t, directorytax.tax_headings AS h ";
 $q .= "WHERE t.FamilyID=h.FamilyID AND headingID='$first_hd' GROUP BY t.FamilyID ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {
        $first_family_desc = $$row[0];
 }
 $sth->finish;

 # Family of 2nd Highest Paid Category
 $second_family_desc ="";
 $q  = "SELECT FamilyCategoryName FROM directorytax.taxonomy AS t, directorytax.tax_headings AS h ";
 $q .= "WHERE t.FamilyID=h.FamilyID AND headingID='$second_hd' GROUP BY t.FamilyID ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {
        $second_family_desc = $$row[0];
 }
 $sth->finish;

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

=for comment
 # Total User Sessions
 $us="0";
 $q  = "SELECT sum(us) FROM  thomtnetlogARTU thomtnetlogARTU  WHERE acct IN ($acctmap) AND date in ($rdate) ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {
 	$us = $$row[0];
 }
 $sth->finish;
if($us eq "") {$us="0";}
=cut

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


	$caton =  $thomas_catalog_views = "0";
	$q = "SELECT SUM(totalpageviews) + sum(totalInq) + sum(totalordrfqs), SUM(totalpageviews) ";
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
 
	$catoff = 0;
	$query = "SELECT SUM(totalpageviews) + sum(totalInq + totalordrfqs)   ";
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

	$adclicks =0;
	$q = "SELECT sum(clicks) AS adviews FROM thomtnetlogADviewsServerM ";
	$q .= "WHERE acct IN ($acctmap) AND adtype in ('bad','pai','phd') AND fdate IN ($rdate)  ";
	PrintQ($q);
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
 		$adviews += $$row[0];
	}
	if($adviews eq "") {$adviews=0;}
	$conv += $adviews;

   
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
 

	$adviews = "0";
	$q = "SELECT  sum(BannerClicks) AS adclicks, sum(BannerViews) AS adviews FROM thomnews_ad_cat ";
	$q .= "WHERE AdvertiserCid in ($acctmap) AND date  IN ($rdate)   AND badimg='N' ";
	$q .= " AND ( CampaignType in ( 'Company Specific Full Story','IMT Blog SkyRight','Keyword LeaderBoard','Keyword Specific Full Story','LeaderBoard','MachBlog Link Banner','PNA-IMT Tracking','tnet Network','Tradeshow Tracking / Other','Brand Impact','Complementing (Family Level) Ad', 'Complementing (Category Level) Ad', 'Foundation/Company Specific Full Story' ) || CampaignType in ( 'ROS Campaign - No Heading', 'Run Of Site Offer' ,'True Run of Site','Tradeshow Banner','Tradeshow Tracking / Other' ) ) ";
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


# Call Tracking Phone Sales Inquiries
$call_track_inq = "0";
$q = "select count(*) from thomcalltracking as c left join tgrams.cs_calls as s on c.acct=s.acct and c.filename=s.filename
      where c.acct in ($acctmap) and (callername not like '%industrial quick%' && callername not like '%INDUSTRIAL QUICK SEARCH%' )
      and ( typeid=10 ) and callresult not in (2,3,4) and c.filename>'' and date in ($rdate)  ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {
 	$call_track_inq  = $$row[0];
 }
 $sth->finish;
if($call_track_inq  eq "") {$call_track_inq =0;}



# Total Call Tracking Phone Calls
$call_track_calls = "0";  
$q = "select count(*) from thomcalltracking as c left join tgrams.cs_calls as s on c.acct=s.acct and c.filename=s.filename 
      where c.acct in ($acctmap) 
      and (callername not like '%industrial quick%' && callername not like '%INDUSTRIAL QUICK SEARCH%' ) 
      and ( typeid=10 || typeid=99 || typeid is Null || (typeid=40 && notes like 'IVR%') ) 
      and callresult not in (2,3,4) and c.filename>'' 
      and date in ($rdate)  ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {
 	$call_track_calls  = $$row[0];
 }
 $sth->finish;
if($call_track_calls  eq "") {$call_track_calls =0;}


# Mirror Site Tracking Phone Inquiries
$mst_inq="0";
$q = "SELECT COUNT(*) from thomCampaign_Event_Detail_v2 as c
      left join Campaign_IP as ip on c.universal_id=ip.universal_id
      left join tgrams.cs_calls as cs on cs.acct=adv_code and filename=wavfile
      where adv_code in ($acctmap) and event_type_name='call' and (cust_name not like '%industrial quick%' && cust_name not like '%INDUSTRIAL QUICK SEARCH%' )
      and date in ($rdate) and typeid=10  AND wavfile>'' ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {
 	$mst_inq = $$row[0];
 }
 $sth->finish;
if($mst_inq eq "") {$mst_inq="0";}


# Total Mirror Site Tracking  Phone Calls
$mst_calls="0";
$q = "select count(*) from thomCampaign_Event_Detail_v2 as c
      left join Campaign_IP as ip on c.universal_id=ip.universal_id
      left join tgrams.cs_calls as cs on cs.acct=adv_code and filename=wavfile
      where adv_code in ($acctmap) and event_type_name='call' and (cust_name not like '%industrial quick%' && cust_name not like '%INDUSTRIAL QUICK SEARCH%' )
      and date in ($rdate) and ( typeid=10 || typeid=99 || typeid is Null || (typeid=40 && notes like 'IVR%') ) AND wavfile>''  ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {
 	$mst_calls = $$row[0];
 }
 $sth->finish;
if($mst_calls eq "") {$mst_calls="0";}


# Sales Inquiry tnet RFIs
 $rfi_inquiries="0";
 $q  = "SELECT count(*) AS ca FROM tgrams.rfi_clientview r 
         WHERE r.acct='$acct' AND r.vetted IN ('lead') AND source='contacts' AND test_msg=0 
        AND r.received BETWEEN $unix_start_date AND $unix_end_date ";  
 PrintQ($q);
 my $sth = $sdbh->prepare($q);
 if (!$sth->execute) { print "Error" . $sdbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {
 	$rfi_inquiries = $$row[0];
 }
 $sth->finish;
if($rfi_inquiries eq ""){$rfi_inquiries="0";}

 

# Total tnet RFIs
 $rfis="0";

 $q  = "SELECT count(*) AS ca FROM tgrams.rfi_clientview r 
         WHERE r.acct='$acct' AND r.vetted IN ('lead','other','solicitation','unclassified') AND source='contacts' AND test_msg=0 
        AND r.received BETWEEN $unix_start_date AND $unix_end_date   ";
 
 PrintQ($q);
 my $sth = $sdbh->prepare($q);
 if (!$sth->execute) { print "Error" . $sdbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {
 	$rfis = $$row[0];
 }
 $sth->finish;
if($rfis eq ""){$rfis="0";}

=for comment
 $q= "select sum(ca)  from thomtnetlogARTU where acct in ($acctmap)  and date in ($rdate) and covflag='t' ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {
 	$rfis = $$row[0];
 }
 $sth->finish;
if($rfis eq ""){$rfis="0";}  
=cut




# Links to Website
	# $links

# Profile Views
	# $profile


# Press Release Views
	# $press_rel

# Links to Catalog/CAD
	# $cad_cat_links

# Catalog Page Views on tnet
	# $thomas_catalog_views

# Display Ad Impressions
        # $adviews

# Display Ad Clicks
        # $adclicks


# Category Specific Ad Dominance Impressions
# Category Specific  Ad Dominance Clicks
$category_specific_clicks =  $category_specific_views = 0;
$q = "SELECT sum(clicks), sum(views)  FROM thomtnetlogADviewsServerM ";
$q .= "WHERE acct IN ($acctmap) AND adtype in ('pai') AND fdate IN ($rdate)  ";
PrintQ($q);
my $sth = $dbh->prepare($q);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
 	$category_specific_clicks = $$row[0];
 	$category_specific_views  = $$row[1];
}
if($category_specific_clicks eq "") {$category_specific_clicks=0;}
if($category_specific_views eq "") {$category_specific_views=0;}




# Program Ad Dominance / Dominance Premium Impressions
# Program Ad Dominance / Dominance Premium Clicks
$bad_clicks =  $bad_views = 0; 
$q = "select sum(BannerViews) as v, sum(BannerClicks) as c FROM thomnews_ad_cat
	where AdvertiserCid in ($acctmap) and CampaignType = 'Program Ad Dominance Premium' and date in ($rdate) ";
PrintQ($q); 
my $sth = $dbh->prepare($q);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{ 
 	$bad_views  = $$row[0];
	$bad_clicks = $$row[1];
}
$q = "SELECT sum(clicks), sum(views)  FROM thomtnetlogADviewsServerM ";
$q .= "WHERE acct IN ($acctmap) AND adtype in ('bad') AND fdate IN ($rdate)  ";
PrintQ($q);
my $sth = $dbh->prepare($q);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
 	$bad_clicks += $$row[0];
 	$bad_views  += $$row[1];
}
if($bad_clicks eq "") {$bad_clicks="0";}
if($bad_views eq "")  {$bad_views="0";}




# Paid Category Ad Dominance / Dominance Premium Impressions
# Paid Category Ad Dominance / Dominance Premium Clicks
$phd_clicks =  $phd_views = 0;
$q = "SELECT sum(clicks), sum(views)  FROM thomtnetlogADviewsServerM ";
$q .= "WHERE acct IN ($acctmap) AND adtype in ('phd') AND fdate IN ($rdate)  ";
PrintQ($q);
my $sth = $dbh->prepare($q);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
 	$phd_clicks = $$row[0];
 	$phd_views  = $$row[1];
}
if($phd_clicks eq "") {$phd_clicks=0;}
if($phd_views eq "")  {$phd_views=0;}




# Quanity of Co/Org Visitor Names on Display
$org_count = 0;
$query  =  "SELECT COUNT(distinct(concat(org,city,state,zip))) FROM thomtnetlogORGDWIZ WHERE isp='N' AND block!='Y'  AND acct='$acct' AND date IN ($rdate) ";
PrintQ($query); 
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
 	$org_count = $$row[0];
} 
if($org_count eq "") { $org_count = "0"; }



# CCP Logo Y/N
$ccp_logo="N";
$q   = "SELECT l.filename AS logo, c.publish FROM tgrams.ccp_logo AS l JOIN tgrams.ccp_content AS c ";
$q  .= "WHERE acct='$acct' AND l.contentid=c.contentid AND publish='Y' ";
my $sth = $dbh->prepare($q);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
 	if($$row[0] ne "") {$ccp_logo="Y";}
	else               {$ccp_logo="N";}
}

 

# CCP Video Views
	# $vv

# CCP Document Views
	# $dv

# CCP Image Views
	# $iv

# Quantity Preview Ads
$preview_ads = "0";
$q = "SELECT count(*)  FROM tgrams.previewads_active  WHERE acct='$acct' ";
PrintQ($q);
my $sth = $dbh->prepare($q);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
 	$preview_ads  = $$row[0];
}
if($preview_ads  eq "") {$preview_ads =0;}


# Web Traxs Y/N
$webtrax = "N";
$q = "SELECT count(*)  FROM  tgrams.webtraxs_accts WHERE acct='$acct' ";
PrintQ($q);
my $sth = $dbh->prepare($q);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
 	if($$row[0] >0) { $webtrax = "Y"; }
  	else { $webtrax = "N"; }
}

  
 print wf "$acct\t";                     #  Account Number
 print wf "$comp\t";                     #  Account Name
 print wf "$ad_dollars\t";               #  Account Total Spend
 print wf "$city\t";                     #  Editorial: City
 print wf "$state\t";                    #  Editorial: State\t";
 print wf "$main_act{$cotype}\t";        #  Editorial: Primary Company Type
 print wf "$all_activities\t";           #  Editorial: All Activities
 print wf "$paid_listing\t";             #  Editorial: Paid Listing Count
 print wf "$bold_listing\t";             #  Editorial: Bold Listing Count
 print wf "$brand\t";                    #  Editorial: Brand Data Y/N
 print wf "$first_desc\t";               #  Highest Paid Category
 print wf "$second_desc\t";              #  2nd Highest Paid Category
 print wf "$first_family_desc\t";        #  Family of Highest Paid Category
 print wf "$second_family_desc\t";       #  Family of 2nd Highest Paid Category
 print wf "$us\t";                       #  Total User Sessions
 print wf "$conv\t";                     #  Total Conversion Actions
 print wf "$call_track_inq\t";           #  Call Tracking Phone Sales Inquiries
 print wf "$call_track_calls\t";         #  Total Call Tracking Phone Calls
 print wf "$mst_inq\t";                  #  Mirror Site Tracking Phone Inquiries
 print wf "$mst_calls\t";                #  Total Mirror Site Tracking  Phone Calls
 print wf "$rfi_inquiries\t";            #  Sales Inquiry tnet RFI
 print wf "$rfis\t";                     #  Total tnet RFIs
 print wf "$links\t";                    #  Links to Website
 print wf "$profile\t";                  #  Profile Views
 print wf "$press_rel\t";                #  Press Release Views
 print wf "$cad_cat_links\t";            #  Links to Catalog/CAD
 print wf "$thomas_catalog_views\t";     #  Catalog Page Views on tnet
 print wf "$adviews\t";                  #  Display Ad Impressions
 print wf "$adclicks\t";                 #  Display Ad Clicks
 print wf "$category_specific_views\t";  #  Category Specific Ad Dominance Impressions
 print wf "$category_specific_clicks\t"; #  Category Specific  Ad Dominance Clicks
 print wf "$bad_views\t";                #  Program Ad Dominance / Dominance Premium Impressions
 print wf "$bad_clicks\t";               #  Program Ad Dominance / Dominance Premium Clicks
 print wf "$phd_views\t";                #  Paid Category Ad Dominance / Dominance Premium Impressions
 print wf "$phd_clicks\t";               #  Paid Category Ad Dominance / Dominance Premium Clicks
 print wf "$org_count\t";                #  Quanity of Co/Org Visitor Names on Display
 print wf "$ccp_logo\t";                 #  CCP Logo Y/N
 print wf "$vv\t";                       #  CCP Video Views
 print wf "$dv\t";                       #  CCP Document Views
 print wf "$iv\t";                       #  CCP Image Views
 print wf "$preview_ads\t";              #  Quantity Preview Ads
 print wf "$webtrax \n";                 #  Web Traxs Y/N

 $z++;

}

close(wf);

$dbh->disconnect;

print "\n\nDone...\n\n";
