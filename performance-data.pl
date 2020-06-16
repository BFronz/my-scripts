#!/usr/bin/perl
#
#

use DBI;

# isotope  connect
$data_source_iso = "dbi:mysql:sodm_rank:isotope.rds.c.net";
$user_iso        = "tnet";
$auth_iso        = "7zLdNrISma6Uft";
$dbh_iso         = DBI->connect($data_source_iso, $user_iso, $auth_iso);

# phobus connect
require "/usr/wt/trd-reload.ph";

$unixtime    = time();
#$debug=1;
 
sub AddSlashes {
    $text = shift;
    ## Make sure to do the backslash first!
    $text =~ s/\\/\\\\/g;
    $text =~ s/'/\\'/g;
    $text =~ s/"/\\"/g;
    $text =~ s/\\0/\\\\0/g;
    return $text;
}

$now_string = localtime;
print "$now_string\n\n";
 
$rdate = " '1602','1603','1604','1605','1606','1607','1608','1609','1610','1611','1612','1701' ";
 


  
# get companies
$query  =  "select company, acct from tgrams.main order by company  "; 
$query  =  "select company, acct from tgrams.main  order by company  ";
#$query  =  "select m.company, m.acct FROM tgrams.main as m, thomtnetlogARTU as d WHERE m.acct=d.acct and date in ($rdate) group by m.acct ";
$query  =  "select acct from thomposition16Q4 where pop>0  group by acct "; 
#print "\n$query\n"; exit;
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
	$squery  =  "select company from tgrams.main where acct='$$row[0]'  ";
	my $ssth = $dbh->prepare($squery);
	if (!$ssth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $srow = $ssth->fetchrow_arrayref)
	{ 
		$record[$i] = "$$srow[0]\t$$row[0]";
	        $i++;
	}
	$ssth->finish;
}
$sth->finish;
  
  

$outfile2 = "PerformanceDataforSelfServeComparison-latest.txt";
open(wf, ">$outfile2")  || die (print "Could not open $outfile2\n");
print wf "Account Name\tTGRAMS#\tRank Points National\tRank Points Coverage\t# of Listings (paid and unpaid)\tUser Sessions\tConversions\tProfile Views\tLinks to Website\tRFI Count (all vetting types - total count)\tProgram Cycle Start Date\n";
 
$j=1;
foreach $record (@record)
{
	($comp,$acct) = split(/\t/,$record);
	print "$j. $comp\t$acct\n";  
 
	$rank =0;
	$q = "select sum(pop) from thomposition16Q4  where acct=$acct and cov='NA'";
 	my $sth = $dbh->prepare($q);
 	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  	while (my $row = $sth->fetchrow_arrayref)
  	{  
                $rank = $$row[0];
        }
        $sth->finish;
	if( $rank eq "") { $rank="0";}   
 
        $crank = "0";
        $q = "select sum(pop) from thomposition16Q4 where acct=$acct and cov!='NA' and pop>0 group by cov limit 1";
        my $sth = $dbh->prepare($q);
        if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
        while (my $row = $sth->fetchrow_arrayref)
        {    
                $crank = $$row[0];
        }
        $sth->finish;
	if( $crank eq "") { $crank="0";}        
 

	

  
	$q = "select count(distinct heading) from thomposition16Q4  where acct=$acct ";
 	my $sth = $dbh->prepare($q);
 	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  	while (my $row = $sth->fetchrow_arrayref)
  	{
                $listings = $$row[0];
        }
        $sth->finish; 

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

        $total_top_conv = $profile = $us = $links ="0";
 	$q  = "SELECT sum(us) AS uses, sum(pv) AS profile, sum(ln) AS links, ";
 	$q .= "sum(pv) + sum(ln) + sum(cl) + sum(cv) + sum(ec) + sum(ca) + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv) + sum(lc) as tot,  ";
	$q .= " sum(ca) AS cont ";
   	$q .= "FROM tnetlogARTU WHERE acct in ($acctmap) and date in ($rdate) and covflag='t' ";
 	my $sth = $dbh->prepare($q);
 	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 	while (my $row = $sth->fetchrow_arrayref)
  	{
   	$us              = $$row[0];
   	$profile         = $$row[1];
   	$links           = $$row[2];
   	$total_top_conv  = $$row[3];
   	$rfi             = $$row[4];
  	 } 
 	$sth->finish;
	if($total_top_conv==""){$total_top_conv="0";}
	if($profile=="")       {$profile="0";}
	if($us==""){$us="0";}
	if($links==""){$links="0";}
	if($rfi==""){$rfi="0";}
 
 
 
 	$newsviews = $linksweb = $totnews = 0;
 	$q = "SELECT sum(nsv)  AS newsviews, sum(nlw)  AS linksweb,  sum(nsv) + sum(ncc) + sum(nes) + sum(nlw) AS totnews FROM thomnews_conversions WHERE acct IN ($acctmap) AND date in ($rdate) ";
 	my $sth = $dbh->prepare($q);
 	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 	while (my $row = $sth->fetchrow_arrayref)
  	{
   	$newsviews = $$row[0];
   	$linksweb  = $$row[1];
   	$totnews   = $$row[2];
  	}
 	if($newsviews eq ""){$newsviews = "0";} if($linksweb eq ""){$linksweb = "0";}  if($totnews eq ""){$totnews = "0";}
 
 	$adclicks =  $adviews = "0";
 	$q = "SELECT sum(BannerClicks) AS adclicks, sum(BannerViews) AS adviews FROM thomnews_ad_cat WHERE AdvertiserCid in ($acctmap) AND date in ($rdate)  AND badimg='N' ";
 	my $sth = $dbh->prepare($q);
 	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	 while (my $row = $sth->fetchrow_arrayref)
  	{
   	$adclicks = $$row[0];
   	$adviews  = $$row[1];
 	 }
   
 	$q = "SELECT sum(clicks) AS adclicks, sum(views) AS adviews FROM thomtnetlogADviewsServerM WHERE acct IN ($acctmap) AND adtype ='pai' AND fdate in ($rdate)  ";
	my $sth = $dbh->prepare($q);
 	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 	while (my $row = $sth->fetchrow_arrayref)
  	{
  	$adclicks += $$row[0];
   	$adviews  += $$row[1];
  	}   
 	$q = "SELECT sum(clicks) AS adclicks, sum(views) AS adviews FROM thomtnetlogADviewsServerM WHERE acct IN ($acctmap) AND adtype ='bad' AND fdate in ($rdate)  ";
 	my $sth = $dbh->prepare($q);
 	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 	while (my $row = $sth->fetchrow_arrayref)
  	{
   	$adclicks += $$row[0];
   	$adviews  += $$row[1];
  	}
 
 	$caton = $catonrfq = "0";
 	$q = "SELECT SUM(totalpageviews) AS n, sum(totalInq) + sum(totalordrfqs) totalInq FROM thomflat_catnav_summmaryM WHERE tgramsid IN ($acctmap) AND date in ($rdate)  ";
 	my $sth = $dbh->prepare($q);
 	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 	while (my $row = $sth->fetchrow_arrayref)
  	{
   	$caton    = $$row[0];
   	$catonrfq = $$row[1];
  	}
 	if($caton==""){$caton="0";} if($catonrfq==""){$catonrfq="0";} 

 
 	$catoff = $catoffrfq = "0";
 	$q = "SELECT SUM(totalpageviews) AS n, sum(totalInq) + sum(totalordrfqs) totalInq FROM thomcatnav_summmaryM WHERE tgramsid IN ($acctmap) AND date in ($rdate)   "; 
 	my $sth = $dbh->prepare($q);
 	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 	while (my $row = $sth->fetchrow_arrayref)
	{
   	$catoff    = $$row[0];
   	$catoffrfq = $$row[1];
  	}

	#$rfi = "";
	#$q = "select count(*) as n from tgrams.contacts where acct=$acct and (created>=1454302800 and created<1485925200) and  notsent  < 1 and test_msg!=1  ";
	#my $sth = $dbh->prepare($q);
 	#if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 	#while (my $row = $sth->fetchrow_arrayref)
	#{ 
   	#$rfi  = $$row[0];
  	#}  
	#if($rfi==""){$rfi="0";} 
 
	$programdate =""; 
 	$q= "select contract_start_date         
        from sodm_rank.sodm_contracts
        where acct=$acct
        and contract_end_date>curdate()
        and legacy_publication_code not in('32','3B','3D','3H','41','48','50','54','59','64')
        and contract_status!='C'
        and legacy_publication_code in ('42','3E') ";
 	my $sth_iso = $dbh_iso->prepare($q);
 	if (!$sth_iso->execute) { print "Error" . $dbh_iso->errstr . "<BR>\n"; exit(0); }
 	while (my $row = $sth_iso->fetchrow_arrayref)
	{   
   	$programdate       = $$row[0];
  	}  


	#print "news: $totnews\nadclicks: $adclicks\n$catoff + $catoffrfq \n$caton + $catonrfq \n"; 


	$total_top_conv += $totnews;
 	$total_top_conv += $adclicks; 
 	$total_top_conv += $catoff + $catoffrfq ;
 	$total_top_conv += $caton + $catonrfq ;
   


	#Account Name\tTGRAMS#\tRank Points\t# of Listings (paid and unpaid)\tUser Sessions\tConversions\tProfile Views\tLinks to Website\tRFI Count (all vetting types - total count)\tProgram Cycle Start Date\n";

	print wf "$comp\t";
	print wf "$acct\t";
	print wf "$rank\t";
	print wf "$crank\t";
	print wf "$listings\t";
	print wf "$us\t";
	print wf "$total_top_conv\t";
	print wf "$profile\t";
	print wf "$links\t";
	print wf "$rfi\t";
	print wf "$programdate\t";
	print wf "\n";
 	$j++;   
}


close(wf);




$dbh->disconnect;

$now_string = localtime;
print "$now_string"; 


=for comment
=cut 
 
print "\nDone...";
