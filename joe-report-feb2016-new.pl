#!/usr/bin/perl
#
#

$infile   = $ARGV[0];
if($infile eq "") {print "\n\nMissing infile\n\n"; exit;}
$filename = substr($infile, 0, -4);;
$outfile  = "report-" . $filename . ".txt";
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");

 
$i=0;
open(rf, "$infile")  || die (print "Could not open $infile\n");
while (!eof(rf))
    {
  $instr = <rf>;
  chop($instr);
  $record[$i] = $instr;
  #print "$record[$i]\n";
  $i++;
    }
close(rf);
  
if   ($filename eq "1410-1509") { $rdate = " '1410','1411','1412','1501','1502','1503','1504','1505','1506','1507','1508','1509' "; }
elsif($filename eq "1403-1502") { $rdate = " '1403','1404','1405','1506','1407','1408','1409','1410','1411','1412','1501','1502' "; }
elsif($filename eq "1502-1509") { $rdate = " '1502','1503','1504','1505','1506','1507','1508','1509' "; }
elsif($filename eq "1406-1505") { $rdate = " '1406','1407','1408','1409','1410','1411','1412','1501','1502','1503','1504','1505' "; }
elsif($filename eq "1502-1510") { $rdate = " '1502','1503','1504','1505','1506','1507','1508','1509','1510' "; }
elsif($filename eq "1404-1503") { $rdate = " '1404','1405','1406','1407','1408','1409','1410','1411','1412','1501','1502','1503' "; }
elsif($filename eq "1407-1506") { $rdate = " '1407','1408','1409','1410','1411','1412','1501','1502','1503','1504','1505','1506' "; }
elsif($filename eq "1408-1507") { $rdate = " '1408','1409','1410','1411','1412','1501','1502','1503','1504','1505','1506','1507' "; }
elsif($filename eq "1402-1501") { $rdate = " '1402','1403','1404','1405','1406','1407','1408','1409','1410','1411','1412','1501' "; }
elsif($filename eq "1409-1508") { $rdate = " '1409','1410','1411','1412','1501','1502','1503','1504','1505','1506','1507','1508' "; }
elsif($filename eq "1411-1510") { $rdate = " '1411','1412','1501','1502','1503','1504','1505','1506','1507','1508','1509','1510' "; }
elsif($filename eq "1405-1504") { $rdate = " '1405','1406','1407','1408','1409','1410','1411','1412','1501','1502','1503','1504' "; }

print "\n\nfilename: $filename\ninfile: $infile\noutfile:$outfile\nrdate:$rdate\n\n";

sub PrintQ
{
 $q = $_[0];
 # print "\n$q\n";
}

use DBI;
require "/usr/wt/trd-reload.ph";

print wf "Company\t";
print wf "Account #\t";
print wf "tnt.com - Links to Your Website\t";
print wf "tnt.com - Profiles Viewed\t";
print wf "tnt.com - Total Brand Display Ad Clicks\t";
print wf "Profile Engagement - Video Views\t";
print wf "Profile Engagement - Document Views\t";
print wf "Profile Engagement - Image Views\t";
print wf "Profile Engagement - Social Media Links\t";
print wf "tnet News - News Release Views\t";
print wf "tnet News - Links to Your Website\t";
print wf "Catalog Activity on tnet - Links to Catalog/CAD\t";
print wf "Catalog Activity on tnet - Pages Viewed\t";
print wf "Catalog Activity on tnet - Request for Quote/Order/Info\t";
print wf "Brand Display Impressions - Display Ad Impressions\t";
print wf "Brand Display Impressions - Category Specific Ad Dominance Impressions\t";
print wf "Brand Display Impressions - Program Ad Dominance Impressions\n";

# loop through each heading
$l=1;
foreach $record (@record)
{ 	
 $acct = $record;	
 $acct =~ s/^\s+|\s+$//g;
 

  $query = " SELECT company FROM tgrams.main WHERE acct='$acct' ";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  if (my $row = $sth->fetchrow_arrayref)
    {
     $company = $$row[0];
    }

  print "$l. $company\t$acct\n";

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
  $q .= "FROM tnetlogARTU WHERE acct in ($acctmap) and date in ( $rdate ) and covflag='t' ";
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
  if($profile==""){$profile="0";} if($links==""){$links="0";}
  if($video=="")  {$video="0";  } if($docs=="") {$docs="0"; } if($imgviews==""){$imgviews="0";}  if($social==""){$social="0";} 
  
 $q = "SELECT sum(nsv)  AS newsviews, sum(nlw)  AS linksweb,  sum(nsv) + sum(ncc) + sum(nes) + sum(nlw) AS totnews FROM thomnews_conversions WHERE acct IN ($acctmap) AND date in ($rdate) ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $newsviews = $$row[0];
   $linksweb  = $$row[1];
   $totnews   = $$row[2];
  }
 if($newsviews eq ""){$newsviews = "0";} if($linksweb eq ""){$linksweb = "0";}  if($totnews eq ""){$totnews = "0";}

 $caton = $catonrfq = "0";
 $q = "SELECT SUM(totalpageviews) AS n, sum(totalInq) + sum(totalordrfqs) totalInq FROM thomflat_catnav_summmaryM WHERE tgramsid IN ($acctmap) AND date  in ($rdate)   ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $caton    = $$row[0];
   $catonrfq = $$row[1];
  }
 if($caton==""){$caton="0";} if($catonrfq==""){$catonrfq="0";} 
 
 $adclicks =  $adviews = "0";
 $q = "SELECT sum(BannerClicks) AS adclicks, sum(BannerViews) AS adviews FROM thomnews_ad_cat WHERE AdvertiserCid in ($acctmap) AND date  in ($rdate)  AND badimg='N' ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $adclicks = $$row[0];
   $adviews  = $$row[1];
  }
 $q = "SELECT sum(clicks) AS adclicks, sum(views) AS adviews FROM thomtnetlogADviewsServerM WHERE acct IN ($acctmap) AND adtype ='pai' AND fdate  in ($rdate)  ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $adclicks += $$row[0];
   $adviews  += $$row[1];
   $pai   = $$row[0];	
  }
 $q = "SELECT sum(clicks) AS adclicks, sum(views) AS adviews FROM thomtnetlogADviewsServerM WHERE acct IN ($acctmap) AND adtype ='bad' AND fdate  in ($rdate)  ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $adclicks += $$row[0];
   $adviews  += $$row[1];
   $bad = $$row[0];	
  }
 $q = "SELECT sum(clicks) AS adclicks, sum(views) AS adviews FROM thomtnetlogADviewsServerM WHERE acct IN ($acctmap) AND adtype ='phd' AND fdate  in ($rdate)  ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $adclicks += $$row[0];
   $adviews  += $$row[1];
  }
 if($adclicks eq "") {$adclicks="0";} if($adviews eq "") {$adviews="0";} 
 if($pai eq "") {$pai = "0";}
 if($bad eq "") {$bad = "0";} 

 $q = "select sum(BannerViews) as banviews, sum(BannerClicks) as banclicks from thomnews_ad_cat where AdvertiserCid in ($acctmap) ";
 $q .= "and date in ($rdate) and badimg='N' ";
 $q .= "and ( CampaignType in ( 'Company Specific Full Story','IMT Blog SkyRight','Keyword LeaderBoard','Keyword Specific Full Story','LeaderBoard','MachBlog Link Banner','PNA-IMT Tracking','tnet Network','Tradeshow Tracking / Other','Brand Impact','Category Sponsor','Complementing (Family Level) Ad', 'Foundation/Company Specific Full Story' ) || CampaignType in ( 'ROS Campaign - No Heading', 'Run Of Site Offer' ,'True Run of Site' ) ) ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  { 
   $displayviews  += $$row[0];
   $displayclicks += $$row[1];
  }  
 if($displayviews eq "") {$displayviews="0";}

 
  print wf "$company\t";    # Company
  print wf "$acct\t";       # Acct
  print wf "$links\t";      # tnt.com - Links to Your Website
  print wf "$profile\t";    # tnt.com - Profiles Viewed
  print wf "$adclicks\t";    # tnt.com - Total Brand Display Ad Clicks

  print wf "$video\t";           # Profile Engagement - Video Views
  print wf "$docs\t";            # Profile Engagement - Document Views
  print wf "$imgviews\t";        # Profile Engagement - Image Views
  print wf "$social\t";          # Profile Engagement - Social Media Links

  print wf "$newsviews\t";       # tnet News News - Release Views
  print wf "$linksweb\t";        # tnet News Links - to Your Website

  print wf "$linkscatalog\t";    # Catalog Activity on tnet - Links to Catalog/CAD
  print wf "$caton\t";           # Catalog Activity on tnet - Pages Viewed
  print wf "$catonrfq\t";        # Catalog Activity on tnet - Request for Quote/Order/Info

  print wf "$displayviews\t";    # Brand Display Impressions - Display Ad Impressions
  print wf "$pai\t";        # Brand Display Impressions - Category Specific Ad Dominance Impressions
  print wf "$bad\n";        # Brand Display Impressions - Program Ad Dominance Impressions
 

  $company = "";                                                                          
  $acct = $links = $profile = $adviews = $video = $docs = $imgviews = $social = 0;        
  $newsviews = $linksweb = $linkscatalog = $caton = $catonrfq = $adviews = $pai = $bad =  $displayviews = 0;
 
  $l++;
}

close(wf);
$rc = $dbh->disconnect;



print "\n\nDone...\n\n";
