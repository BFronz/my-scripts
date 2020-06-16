#!/usr/bin/perl
#
#

use DBI;
require "/usr/wt/trd-reload.ph";

sub PrintQ
{
	$q = $_[0];
	#print "\n$q\n";
}

$outfile = "Custom-Report-2016-Aug-Sept.txt";
system("rm -f $outfile");
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");

print wf "tgrams\t";
print wf "company name\t";
print wf "August user sessions\t";
print wf "August profile views\t";
print wf "August links to website\t";
print wf "August links to catalog/cad\t";
print wf "August Ontnet catalog page views\t";
print wf "September user sessions\t";
print wf "September profile views\t";
print wf "September links to website\t";
print wf "September links to catalog/cad\t";
print wf "September Ontnet catalog page views\n";

$i=0;
$query  = "SELECT company, acct FROM tgrams.main WHERE adv>'' and acct>0  ";
#$query  .= "AND acct='10111455' "; # for testing
$query  .= "ORDER BY company ";
#$query  .= "LIMIT 50 "; # for testing
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
	$record[$i]="$$row[0]\t$$row[1]";
	$i++;
}
$sth->finish;

$z=1;
foreach $record (@record)
{
	print "$z) $record\n";
	($comp,$acct) = split(/\t/,$record);

	print wf "$acct\t";           # tgrams
	print wf "$comp\t";           # company name
  
	$acctmap = "0";
	$q = "SELECT dupe FROM tgrams.main_map WHERE prime='$acct' ";
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
		$acctmap = "$$row[0],";
	}
	$sth->finish;
	$acctmap .= $acct;

 
	# AUGUST 2016
	$fdate = "1608";
	$yy    =  substr($fdate, 0, 2);
	$links = $profile = $email = $ecoll = $ccp = $linkscatalog = $total_top_conv = $total_top_cad =  $total_top_prodcat =  "0";
	$video =  $docs =  $imgviews =  $social = $total_top_uses = "0",
 	$q  = "SELECT sum(ln) AS links, sum(pv) AS profile, sum(ca) AS email, ";
 	$q .= "sum(ec) AS ecoll,  sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv) AS ccp, ";
 	#$q .= "sum(lc) AS linkscatalog, ";
 	$q .= "SUM(lc)+SUM(cl)  AS linkscatalog, ";
 	$q .= "sum(pv) + sum(ln) + sum(cl) + sum(cv) + sum(ec) + sum(ca) + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv) + sum(lc) as tot , ";
 	$q .= "sum(cd) as cad , ";
 	$q .= "sum(pc) as prodcat, ";
	$q .= "sum(vv) as video, sum(dv) as docs, sum(iv) as imgviews, sum(sm) as social,  "; 
	$q .= "sum(us) as us,    "; 
	$q .= "sum(cl) as cadlinks    ";
	$q .= "FROM tnetlogARTU$yy WHERE acct in ($acctmap) and date='$fdate' and covflag='t' ";
	PrintQ($q);  
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
		$links              = $$row[0];
		$profile            = $$row[1];
		$email              = $$row[2];
		$ecoll              = $$row[3];
		$ccp                = $$row[4];
		$linkscatalog       = $$row[5];
		$total_top_conv     = $$row[6];
		$total_top_cad      = $$row[7];
		$total_top_prodcat  = $$row[8];
		$video              = $$row[9];
		$docs               = $$row[10];
		$imgviews           = $$row[11];
		$social             = $$row[12];
		$total_top_uses     = $$row[13]; 
		$cadlinks           = $$row[14];
	}  
	$sth->finish;
	if($total_top_uses==""){ $total_top_uses="0"; }
	if($linkscatalog=="")  { $linkscatalog="0"; }
	if($profile=="")       { $profile="0"; }
	if($links=="")         { $links="0"; }	 

	$totalpageviews = $totalemailpage = "0";
	$q  = "SELECT SUM(totalpageviews) AS totalpageviews, sum(totalInq + totalordrfqs) as totalemailpage ";
	$q .= "FROM thomflat_catnav_summmary$yy WHERE tgramsid IN ($acctmap) AND isactive='yes' AND date in ($fdate) ";
	PrintQ($q);
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
		$totalpageviews = $$row[0];
 		$totalemailpage = $$row[1];
	}
	$sth->finish;
	if($totalpageviews eq "") { $totalpageviews = "0";} if($totalemailpage eq "") {$totalemailpage = "0";}

	print wf "$total_top_uses\t";  # August user sessions
	print wf "$profile\t";         # August profile views
	print wf "$links\t";           # August links to website
	print wf "$linkscatalog\t";    # August links to catalog/cad
	print wf "$totalpageviews\t";  # August Ontnet catalog page views


	# SEPTEMBER 2016
	$fdate = "1609";
	$yy    =  substr($fdate, 0, 2);
	$links = $profile = $email = $ecoll = $ccp = $linkscatalog = $total_top_conv = $total_top_cad =  $total_top_prodcat =  "0";
	$video =  $docs =  $imgviews =  $social = $total_top_uses = "0",
 	$q  = "SELECT sum(ln) AS links, sum(pv) AS profile, sum(ca) AS email, ";
 	$q .= "sum(ec) AS ecoll,  sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv) AS ccp, ";
 	#$q .= "sum(lc) AS linkscatalog, ";
 	$q .= "SUM(lc)+SUM(cl)  AS linkscatalog, ";
 	$q .= "sum(pv) + sum(ln) + sum(cl) + sum(cv) + sum(ec) + sum(ca) + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv) + sum(lc) as tot , ";
 	$q .= "sum(cd) as cad , ";
 	$q .= "sum(pc) as prodcat, ";
	$q .= " sum(vv) as video, sum(dv) as docs, sum(iv) as imgviews, sum(sm) as social,  "; 
	$q .= " sum(us) as us,    "; 
	$q .= " sum(cl) as cadlinks    ";
	$q .= "FROM tnetlogARTU$yy WHERE acct in ($acctmap) and date='$fdate' and covflag='t' ";
	PrintQ($q);  
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
		$links              = $$row[0];
		$profile            = $$row[1];
		$email              = $$row[2];
		$ecoll              = $$row[3];
		$ccp                = $$row[4];
		$linkscatalog       = $$row[5];
		$total_top_conv     = $$row[6];
		$total_top_cad      = $$row[7];
		$total_top_prodcat  = $$row[8];
		$video              = $$row[9];
		$docs               = $$row[10];
		$imgviews           = $$row[11];
		$social             = $$row[12];
		$total_top_uses     = $$row[13]; 
		$cadlinks           = $$row[14];
	}  
	$sth->finish;
	if($total_top_uses==""){$total_top_uses="0";}
	if(linkscatalog==0) {$linkscatalog>"0";}
 
	$totalpageviews = $totalemailpage = "0";
	$q  = "SELECT SUM(totalpageviews) AS totalpageviews, sum(totalInq + totalordrfqs) as totalemailpage ";
	$q .= "FROM thomflat_catnav_summmary$yy WHERE tgramsid IN ($acctmap) AND isactive='yes' AND date in ($fdate) ";
	PrintQ($q);
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
		$totalpageviews = $$row[0];
 		$totalemailpage = $$row[1];
	}
	$sth->finish;
	if($totalpageviews eq "") { $totalpageviews = "0";} if($totalemailpage eq "") {$totalemailpage = "0";}

	print wf "$total_top_uses\t";   # September user sessions
	print wf "$profile\t";          # September profile views
	print wf "$links\t";            # September links to website
	print wf "$linkscatalog\t";     # September links to catalog/cad
	print wf "$totalpageviews\n";   # September Ontnet catalog page views
 
	$z++;
}

close(wf);

$dbh->disconnect;

print "\n\nDone...\n\n";
