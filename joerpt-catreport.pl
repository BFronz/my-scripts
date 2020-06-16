#!/usr/bin/perl
#
#

use DBI;
require "/usr/wt/trd-reload.ph";

$y14   = " '1401','1402','1403','1404','1405','1406','1407','1408','1409','1410','1411','1412' ";    
$y15 = " '1501','1502','1503','1504','1505','1506','1507','1508','1509','1510','1511' ";
    
sub PrintQ
{
 $q = $_[0];
 #print "\n$q\n";
}

$outfile = "catalog-offsite.txt";
system("rm -f $outfile");
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");

print wf "Account Name\t";                     
print wf "Account Number\t";                   
print wf "2014 Year End Catalog Page Views\t";
print wf "2014 Year End Links to Website\t";
print wf "2015 Jan - Nov Catalog Page Views\t";
print wf "2015 Jan - Nov Links to Website\n";
 
$i=0;
$query  = "SELECT company,acct FROM tgrams.main WHERE adv>'' and acct>0  ";
#$query  .= "AND acct='10111455' "; # for testing
$query  .= "ORDER BY company ";
$query  .= "LIMIT 10 "; # for testing
 
$query = " select m.company, m.acct from tgrams.main as m , thomcatnav_summmaryM as c where totalpageviews>0 and isactive='yes' and acct=tgramsid and date in ('1401','1402','1403','1404','1405','1406','1407','1408','1409','1410','1411','1412', '1501','1502','1503','1504','1505','1506','1507','1508','1509','1510','1511') group by m.acct order by  m.company ";
#$query  .= "LIMIT 10 "; # for testing
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

   
 ### 2014
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
 $q .= "FROM tnetlogARTU WHERE acct in ($acctmap) and date in ($y14) and covflag='t' ";
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
if(linkscatalog==0) {$linkscatalog="0";}
  
 $totalpageviews = $totalemailpage = "0";
 $q  = "SELECT SUM(totalpageviews) AS totalpageviews, sum(totalInq + totalordrfqs) as totalemailpage ";
 $q .= "FROM thomcatnav_summmaryM  WHERE tgramsid IN ($acctmap) AND isactive='yes' AND date in ($y14) ";
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


 ### 2015
 $jlinks = $jprofile = $jemail = $jecoll = $jccp = $jlinkscatalog = $jtotal_top_conv = $jtotal_top_cad =  $jtotal_top_prodcat =  "0";
 $jvideo =  $jdocs =  $jimgviews =  $jsocial = $jtotal_top_uses = "0",
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
 $q .= "FROM tnetlogARTU WHERE acct in ($acctmap) and date in ($y15) and covflag='t' ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $jlinks              = $$row[0];
   $jprofile            = $$row[1];
   $jemail              = $$row[2];
   $jecoll              = $$row[3];
   $jccp                = $$row[4];
   $jlinkscatalog       = $$row[5];
   $jtotal_top_conv     = $$row[6];
   $jtotal_top_cad      = $$row[7];
   $jtotal_top_prodcat  = $$row[8];
   $jvideo              = $$row[9];
   $jdocs               = $$row[10];
   $jimgviews           = $$row[11];
   $jsocial             = $$row[12];
   $jtotal_top_uses     = $$row[13];
   $jcadlinks           = $$row[14];
  }
 $sth->finish;
if($jlinkscatalog==0) {$jlinkscatalog="0";}
  
 $jtotalpageviews = $jtotalemailpage = "0";
 $q  = "SELECT SUM(totalpageviews) AS totalpageviews, sum(totalInq + totalordrfqs) as totalemailpage ";
 $q .= "FROM thomcatnav_summmaryM  WHERE tgramsid IN ($acctmap) AND isactive='yes' AND date in ($y15) ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $jtotalpageviews = $$row[0];
   $jtotalemailpage = $$row[1];
  } 
 $sth->finish;
 if($jtotalpageviews eq "") { $jtotalpageviews = "0";} if($jtotalemailpage eq "") {$jtotalemailpage = "0";}
  
 # 2014 Year End Catalog Page Views
 # 2014 Year End Links to Website
 # 2015 Jan - Nov Catalog Page Views
 # 2015 Jan - Nov Links to Website
 
 
 print wf "$comp\t";
 print wf "$acct\t";

 print wf "$totalpageviews\t";
 print wf "$links\t";

 print wf "$jtotalpageviews\t";   
 print wf "$jlinks\n";

  

 $z++;
}

close(wf);

$dbh->disconnect;

print "\n\nDone...\n\n";
