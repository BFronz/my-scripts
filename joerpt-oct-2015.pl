#!/usr/bin/perl
#
#

use DBI;
require "/usr/wt/trd-reload.ph";

$fdate   = $ARGV[0];
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}
$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);

sub PrintQ
{
 $q = $_[0];
# print "\n$q\n";
}

$outfile = "Conversion-Action-Detail-" . $fdate . ".txt";
system("rm -f $outfile");
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");

print wf "Account Name\t";                      # $comp
print wf "Account Number\t";                    # $acct

print wf "Total User Sessions\t";               # $total_top_uses
print wf "Total Conversion Actions\t";          # $total_top_conv

print wf "Profile Views\t";                     # $profile
print wf "Links to Website\t";                  # $links

print wf "Total Ad Impressions\t";              # $adviews
print wf "Total Ad Clicks\t";                   # $aclicks
print wf "News Release Views\t";                # $newsviews

print wf "Links to Catalog/CAD\t";              # $linkscatalog
print wf "On-tnet Catalog Page Views\t";   # $caton
print wf "On-tnet Catalog RFQs\t";         # $catonrfq

print wf "Video Views\t";                       # $video
print wf "Document Views\t";                    # $docs
print wf "Image Views\t";                       # $imgviews
print wf "Social Media Links\t";                # $social

print wf "E-mail Sent to You\t";                # $email

print wf "Count of Unique Company / Org Names in Visitor Section\t"; # $visitors
print wf "Web Traxs\n";                         # $webtrax


$i=0;
$query  = "SELECT company,acct FROM tgrams.main WHERE adv>'' and acct>0  ";
#$query  .= "AND acct='10111455' "; # for testing
$query  .= "ORDER BY company ";
#$query  .= "LIMIT 500 "; # for testing
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $record[$i]="$$row[0]|$$row[1]";
  $i++;
 }
$sth->finish;

$z=1;
foreach $record (@record)
{
 print "$z) $record\n";
 ($comp,$acct) = split(/\|/,$record);

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
 $q .= "FROM tnetlogARTU$yy WHERE acct in ($acctmap) and date = '$fdate' and covflag='t' ";
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
 $q .= "FROM thomflat_catnav_summmary$yy WHERE tgramsid IN ($acctmap) AND isactive='yes' AND date='$fdate' ";
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


 $newsviews = $linksweb = $totnews = 0;
 $q = "SELECT sum(nsv)  AS newsviews, sum(nlw)  AS linksweb,  sum(nsv) + sum(ncc) + sum(nes) + sum(nlw) AS totnews FROM thomnews_conversions$yy WHERE acct IN ($acctmap) AND date='$fdate' ";
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

 $adclicks =  $adviews = "0";
 $q = "SELECT sum(BannerClicks) AS adclicks, sum(BannerViews) AS adviews FROM thomnews_ad_cat$yy WHERE AdvertiserCid in ($acctmap) AND date='$fdate' AND badimg='N' ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $adclicks = $$row[0];
   $adviews  = $$row[1];
  }




 $q = "SELECT sum(clicks) AS adclicks, sum(views) AS adviews FROM thomtnetlogADviewsServer$yy WHERE acct IN ($acctmap) AND adtype ='pai' AND fdate='$fdate' ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $adclicks += $$row[0];
   $adviews  += $$row[1];
  }
 $q = "SELECT sum(clicks) AS adclicks, sum(views) AS adviews FROM thomtnetlogADviewsServer$yy WHERE acct IN ($acctmap) AND adtype ='bad' AND fdate='$fdate' ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $adclicks += $$row[0];
   $adviews  += $$row[1];
  }
 

 $visitor = "0";
 $q = "select count(distinct org) FROM thomtnetlogORGDAllM WHERE acct IN ($acctmap) AND isp='N' AND date='$fdate' ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $visitors = $$row[0];
  }
 

 $webtraxs = "0";
 $q = "SELECT if( count(*) > 0 , 'Y', 'N') from  tgrams.webtraxs_accts WHERE acct IN  ($acctmap)  ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $webtraxs = $$row[0];
  }

 
 $caton = $catonrfq = "0";
 $q = "SELECT SUM(totalpageviews) AS n, sum(totalInq) + sum(totalordrfqs) totalInq FROM thomflat_catnav_summmaryM WHERE tgramsid IN ($acctmap) AND date='$fdate'  ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $caton    = $$row[0];
   $catonrfq = $$row[1];
  }
 if($caton==""){$caton="0";} if($catonrfq==""){$catonrfq="0";} 

 
 $catoff = $catoffrfq = "0";
 $q = "SELECT SUM(totalpageviews) AS n, sum(totalInq) + sum(totalordrfqs) totalInq FROM thomcatnav_summmaryM WHERE tgramsid IN ($acctmap) AND date='$fdate'  ";
 PrintQ($q); 
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $catoff    = $$row[0];
   $catoffrfq = $$row[1];
  }
 if($catoff==""){$catoff="0";} if($catoffrfq==""){$catoffrfq="0";} 
  
 if($profile==""){$profile="0";} if($links==""){$links="0";} if($email==""){$email="0";} 
 if($video==""){$video="0";}  if($docs==""){$docs="0";}  if($imgviews==""){$imgviews="0";}  if($social==""){$social="0";}  if($linkscatalog==""){$linkscatalog="0";}  
     

 $total_top_conv += $totnews;
 $total_top_conv += $adclicks; 
 $total_top_conv += $catoff + $catoffrfq ;
 $total_top_conv += $caton + $catonrfq ;
 
 print wf "$comp\t";
 print wf "$acct\t";
 print wf "$total_top_uses\t";
 print wf "$total_top_conv\t";
 print wf "$profile\t";
 print wf "$links\t";
 print wf "$adviews\t";
 print wf "$adclicks\t";
 print wf "$newsviews\t";
 print wf "$linkscatalog\t";
 print wf "$caton\t";
 print wf "$catonrfq\t";
 print wf "$video\t";
 print wf "$docs\t";
 print wf "$imgviews\t";
 print wf "$social\t";
 print wf "$email\t";
 print wf "$visitors\t";
 print wf "$webtraxs\n";

 $z++;
}

close(wf);

$dbh->disconnect;

print "\n\nDone...\n\n";
