#!/usr/bin/perl
#
# checks total us & conv

use DBI;
use POSIX;
$dbh = DBI->connect("", "", "");

$outfile = "adv-all-report-2012.txt";
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");

print wf "company (acct)\t";
print wf "us 1201 total\tus 1202 total\tus 1203 total\tus 1204 total\tus 1205 total\tus 1206 total\tus 1207 total\tus 1208 total\tus 1209 total\tus 1210 total\tus 1211 total\tus 1212 total\t";
print wf "conv 1201 total\tconv 1202 total\tconv 1203 total\tconv 1204 total\tconv 1205 total\tconv 1206 total\tconv 1207 total\tconv 1208 total\tconv 1209 total\tconv 1210 total\tconv 1211 total\tconv 1212 total\t";
print wf "us 1201 nat\tus 1202 nat\tus 1203 nat\tus 1204 nat\tus 1205 nat\tus 1206 nat\tus 1207 nat\tus 1208 nat\tus 1209 nat\tus 1210 nat\tus 1211 nat\tus 1212 nat\t";
print wf "conv 1201 nat\tconv 1202 nat\tconv 1203 nat\tconv 1204 nat\tconv 1205 nat\tconv 1206 nat\tconv 1207 nat\tconv 1208 nat\tconv 1209 nat\tconv 1210 nat\tconv 1211 nat\tconv 1212 nat\t";
print wf "us 1201 cov\tus 1202 cov\tus 1203 cov\tus 1204 cov\tus 1205 cov\tus 1206 cov\tus 1207 cov\tus 1208 cov\tus 1209 cov\tus 1210 cov\tus 1211 cov\tus 1212 cov\t";
print wf "conv 1201 cov\tconv 1202 cov\tconv 1203 cov\tconv 1204 cov\tconv 1205 cov\tconv 1206 cov\tconv 1207 cov\tconv 1208 cov\tconv 1209 cov\tconv 1210 cov\tconv 1211 cov\tconv 1212 cov\t";
print wf "\n";


####################  Total   ##########################


$i=0;
$query  = "SELECT company,acct FROM tgrams.main WHERE adv>'' and acct>''  ORDER BY company ";
#$query  .= "LIMIT 100";
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
   print "$z)\t$record\n";
   ($comp,$acct) = split(/\|/,$record);

   $date   = 1201;
   $conv   = $us = 0;
   $covflag="t";
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions12 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat12 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     $subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1201   = $us;
   $conv1201 = $conv;


   $date   = 1202;
   $covflag="t";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions12 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat12 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     $subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1202   = $us;
   $conv1202 = $conv;


   $date   = 1203;
   $covflag="t";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions12 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat12 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     $subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1203   = $us;
   $conv1203 = $conv;

   $date   = 1204;
   $covflag="t";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions12 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat12 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     $subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1204   = $us;
   $conv1204 = $conv;


  $date   = 1205;
   $covflag="t";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions12 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat12 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     $subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1205   = $us;
   $conv1205 = $conv;


  $date   = 1206;
   $covflag="t";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions12 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat12 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     $subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1206   = $us;
   $conv1206 = $conv;
 
   $date   = 1207;
   $covflag="t";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions12 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat12 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     $subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1207   = $us;
   $conv1207 = $conv;
 
   $date   = 1208;
   $covflag="t";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions12 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat12 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     $subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1208   = $us;
   $conv1208 = $conv;

   $date   = 1209;
   $covflag="t";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions12 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat12 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     $subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1209   = $us;
   $conv1209 = $conv;
 
   $date   = 1210;
   $covflag="t";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions12 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat12 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     $subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1210   = $us;
   $conv1210 = $conv;
 
   $date   = 1211;
   $covflag="t";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions12 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat12 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     $subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1211   = $us;
   $conv1211 = $conv;

   $date   = 1212;
   $covflag="t";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions12 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat12 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     $subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1212   = $us;
   $conv1212 = $conv;

  ####################  National   ##########################

   $date   = 1201;
   $conv   = $us = 0;
   $covflag="n";
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1201n   = $us;
   $conv1201n = $conv;


   $date   = 1202;
   $covflag="n";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1202n   = $us;
   $conv1202n = $conv;


   $date   = 1203;
   $covflag="n";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1203n   = $us;
   $conv1203n = $conv;


   $date   = 1204;
   $covflag="n";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1204n   = $us;
   $conv1204n = $conv;

 
   $date   = 1205;
   $covflag="n";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1205n   = $us;
   $conv1205n = $conv;

 
   $date   = 1206;
   $covflag="n";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1206n   = $us;
   $conv1206n = $conv;
 
   $date   = 1207;
   $covflag="n";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1207n   = $us;
   $conv1207n = $conv;
 
   $date   = 1208;
   $covflag="n";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1208n   = $us;
   $conv1208n = $conv;

   $date   = 1209;
   $covflag="n";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1209n   = $us;
   $conv1209n = $conv;
 
   $date   = 1210;
   $covflag="n";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1210n   = $us;
   $conv1210n = $conv;

   $date   = 1211;
   $covflag="n";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1211n   = $us;
   $conv1211n = $conv;


   $date   = 1212;
   $covflag="n";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1212n   = $us;
   $conv1212n = $conv;


   #######################      Coverage      #################################

   $covflag="";
   $subq = "select trim(coverage) from tgrams.main where acct='$acct'";
   #print "\n$subq\n\n";
   my $subr2 = $dbh->prepare($subq);
   if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
   if (my $srow2 = $subr2->fetchrow_arrayref)
    {
       @covs = split(/\|/, $$srow2[0]);
       $j = 0;
       while ($j < @covs)
        {
          if($covs[$j] ne "") { $covflag .= "'$covs[$j]',"; }
          $j++;
        }
      chop ($covflag);
    }
 
   if($covflag eq "") {$covflag = "'XX'";}

   $date   = 1201;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag  in ($covflag) and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1201c   = $us;
   $conv1201c = $conv;


   $date   = 1202;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag in ($covflag) and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1202c   = $us;
   $conv1202c = $conv;


   $date   = 1203;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag in ($covflag) and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1203c   = $us;
   $conv1203c = $conv;

   $date   = 1204;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag in ($covflag) and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1204c   = $us;
   $conv1204c = $conv;
    
 $date   = 1205;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag in ($covflag) and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1205c   = $us;
   $conv1205c = $conv;

 
$date   = 1206;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag in ($covflag) and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1206c   = $us;
   $conv1206c = $conv;
 
   $date   = 1207;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag in ($covflag) and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1207c   = $us;
   $conv1207c = $conv;

 
   $date   = 1208;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag in ($covflag) and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1208c   = $us;
   $conv1208c = $conv;

   $date   = 1209;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag in ($covflag) and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1209c   = $us;
   $conv1209c = $conv;
 
   $date   = 1210;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag in ($covflag) and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1210c   = $us;
   $conv1210c = $conv;

   $date   = 1211;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag in ($covflag) and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1211c   = $us;
   $conv1211c = $conv;
   
   
   $date   = 1212;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU12 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag in ($covflag) and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1212c   = $us;
   $conv1212c = $conv;

   ########################################################

   print wf "$comp ($acct)\t";
   print wf "$us1201\t$us1202\t$us1203\t$us1204\t$us1205\t$us1206\t$us1207\t$us1208\t$us1209\t$us1210\t$us1211\t$us1212\t";
   print wf "$conv1201\t$conv1202\t$conv1203\t$conv1204\t$conv1205\t$conv1206\t$conv1207\t$conv1208\t$conv1209\t$conv1210\t$conv1211\t$conv1212\t";
   print wf "$us1201n\t$us1202n\t$us1203n\t$us1204n\t$us1205n\t$us1206n\t$us1207n\t$us1208n\t$us1209n\t$us1210n\t$us1211n\t$us1212n\t";
   print wf "$conv1201n\t$conv1202n\t$conv1203n\t$conv1204n\t$conv1205n\t$conv1206n\t$conv1207n\t$conv1208n\t$conv1209n\t$conv1210n\t$conv1211n\t$conv1212n\t";
   print wf "$us1201c\t$us1202c\t$us1203c\t$us1204c\t$us1205c\t$us1206c\t$us1207c\t$us1208c\t$us1209c\t$us1210c\t$us1211c\t$us1212c\t";
   print wf "$conv1201c\t$conv1202c\t$conv1203c\t$conv1204c\t$conv1205c\t$conv1206c\t$conv1207c\t$conv1208c\t$conv1209c\t$conv1210c\t$conv1211c\t$conv1212c\t";
   print wf "\n";
  
   $z++;
}

close(wf);

$dbh->disconnect;

print "\n\nDone...\n\n";
