#!/usr/bin/perl
#
# checks total us & conv

use DBI;
use POSIX;
$dbh = DBI->connect("d", "", "");

$outfile = "adv-all-report-2013.txt";
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");

print wf "company (acct)\t";
print wf "us 1301 total\tus 1302 total\tus 1303 total\tus 1304 total\tus 1305 total\tus 1306 total\tus 1307 total\tus 1308 total\tus 1309 total\tus 1310 total\tus 1311 total\tus 1312 total\t";
print wf "conv 1301 total\tconv 1302 total\tconv 1303 total\tconv 1304 total\tconv 1305 total\tconv 1306 total\tconv 1307 total\tconv 1308 total\tconv 1309 total\tconv 1310 total\tconv 1311 total\tconv 1312 total\t";
print wf "us 1301 nat\tus 1302 nat\tus 1303 nat\tus 1304 nat\tus 1305 nat\tus 1306 nat\tus 1307 nat\tus 1308 nat\tus 1309 nat\tus 1310 nat\tus 1311 nat\tus 1312 nat\t";
print wf "conv 1301 nat\tconv 1302 nat\tconv 1303 nat\tconv 1304 nat\tconv 1305 nat\tconv 1306 nat\tconv 1307 nat\tconv 1308 nat\tconv 1309 nat\tconv 1310 nat\tconv 1311 nat\tconv 1312 nat\t";
print wf "us 1301 cov\tus 1302 cov\tus 1303 cov\tus 1304 cov\tus 1305 cov\tus 1306 cov\tus 1307 cov\tus 1308 cov\tus 1309 cov\tus 1310 cov\tus 1311 cov\tus 1312 cov\t";
print wf "conv 1301 cov\tconv 1302 cov\tconv 1303 cov\tconv 1304 cov\tconv 1305 cov\tconv 1306 cov\tconv 1307 cov\tconv 1308 cov\tconv 1309 cov\tconv 1310 cov\tconv 1311 cov\tconv 1312 cov\t";
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

   $date   = 1301;
   $conv   = $us = 0;
   $covflag="t";
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions13 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq); 
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat13 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     #my $subr2 = $dbh->prepare($subq);
     #if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     #if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     #$subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1301   = $us;
   $conv1301 = $conv;


   $date   = 1302;
   $covflag="t";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions13 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat13 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     my $subr2 = $dbh->prepare($subq);
     #if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     #if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     #$subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1302   = $us;
   $conv1302 = $conv;


   $date   = 1303;
   $covflag="t";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions13 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat13 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     #my $subr2 = $dbh->prepare($subq);
     #if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     #if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     #$subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1303   = $us;
   $conv1303 = $conv;

   $date   = 1304;
   $covflag="t";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions13 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat13 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     #my $subr2 = $dbh->prepare($subq);
     #if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     #if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     #$subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1304   = $us;
   $conv1304 = $conv;


  $date   = 1305;
   $covflag="t";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions13 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat13 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     #my $subr2 = $dbh->prepare($subq);
     #if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     #if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     #$subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1305   = $us;
   $conv1305 = $conv;


  $date   = 1306;
   $covflag="t";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions13 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat13 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     #my $subr2 = $dbh->prepare($subq);
     #if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     #if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     #$subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1306   = $us;
   $conv1306 = $conv;
 
   $date   = 1307;
   $covflag="t";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions13 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat13 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     #my $subr2 = $dbh->prepare($subq);
     #if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     #if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     #$subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1307   = $us;
   $conv1307 = $conv;
 
   $date   = 1308;
   $covflag="t";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions13 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat13 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     #my $subr2 = $dbh->prepare($subq);
     #if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     #if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     #$subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1308   = $us;
   $conv1308 = $conv;

   $date   = 1309;
   $covflag="t";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions13 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat13 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     #my $subr2 = $dbh->prepare($subq);
     #if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     #if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     #$subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1309   = $us;
   $conv1309 = $conv;
 
   $date   = 1310;
   $covflag="t";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions13 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat13 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     #my $subr2 = $dbh->prepare($subq);
     #if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     #if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     #$subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1310   = $us;
   $conv1310 = $conv;
 
   $date   = 1311;
   $covflag="t";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions13 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat13 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     #my $subr2 = $dbh->prepare($subq);
     #if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     #if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     #$subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1311   = $us;
   $conv1311 = $conv;

   $date   = 1312;
   $covflag="t";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
   #print "\n\n$query\n\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $conv = $$row[0];
     $us   = $$row[1];

     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot ";
     $subq .= "from thomnews_conversions13 where  date='$date' and acct='$acct' ";
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0]; }
       $subr2->finish;

     $subq   = "select sum(BannerViews) + sum(BannerClicks) from thomnews_ad_cat13 ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$date' ";
     #my $subr2 = $dbh->prepare($subq);
     #if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     #if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; }
     #$subr2->finish;
   }
   $sth->finish;
   if($us eq "")   { $us='0';   }
   if($conv eq "") { $conv='0'; }
   $us1312   = $us;
   $conv1312 = $conv;

  ####################  National   ##########################

   $date   = 1301;
   $conv   = $us = 0;
   $covflag="n";
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
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
   $us1301n   = $us;
   $conv1301n = $conv;


   $date   = 1302;
   $covflag="n";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
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
   $us1302n   = $us;
   $conv1302n = $conv;


   $date   = 1303;
   $covflag="n";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
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
   $us1303n   = $us;
   $conv1303n = $conv;


   $date   = 1304;
   $covflag="n";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
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
   $us1304n   = $us;
   $conv1304n = $conv;

 
   $date   = 1305;
   $covflag="n";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
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
   $us1305n   = $us;
   $conv1305n = $conv;

 
   $date   = 1306;
   $covflag="n";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
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
   $us1306n   = $us;
   $conv1306n = $conv;
 
   $date   = 1307;
   $covflag="n";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
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
   $us1307n   = $us;
   $conv1307n = $conv;
 
   $date   = 1308;
   $covflag="n";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
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
   $us1308n   = $us;
   $conv1308n = $conv;

   $date   = 1309;
   $covflag="n";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
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
   $us1309n   = $us;
   $conv1309n = $conv;
 
   $date   = 1310;
   $covflag="n";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
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
   $us1310n   = $us;
   $conv1310n = $conv;

   $date   = 1311;
   $covflag="n";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
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
   $us1311n   = $us;
   $conv1311n = $conv;


   $date   = 1312;
   $covflag="n";
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag='$covflag' and m.acct='$acct'  ";
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
   $us1312n   = $us;
   $conv1312n = $conv;


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

   $date   = 1301;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag  in ($covflag) and m.acct='$acct'  ";
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
   $us1301c   = $us;
   $conv1301c = $conv;


   $date   = 1302;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag in ($covflag) and m.acct='$acct'  ";
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
   $us1302c   = $us;
   $conv1302c = $conv;


   $date   = 1303;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag in ($covflag) and m.acct='$acct'  ";
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
   $us1303c   = $us;
   $conv1303c = $conv;

   $date   = 1304;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag in ($covflag) and m.acct='$acct'  ";
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
   $us1304c   = $us;
   $conv1304c = $conv;
    
 $date   = 1305;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag in ($covflag) and m.acct='$acct'  ";
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
   $us1305c   = $us;
   $conv1305c = $conv;

 
$date   = 1306;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag in ($covflag) and m.acct='$acct'  ";
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
   $us1306c   = $us;
   $conv1306c = $conv;
 
   $date   = 1307;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag in ($covflag) and m.acct='$acct'  ";
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
   $us1307c   = $us;
   $conv1307c = $conv;

 
   $date   = 1308;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag in ($covflag) and m.acct='$acct'  ";
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
   $us1308c   = $us;
   $conv1308c = $conv;

   $date   = 1309;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag in ($covflag) and m.acct='$acct'  ";
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
   $us1309c   = $us;
   $conv1309c = $conv;
 
   $date   = 1310;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag in ($covflag) and m.acct='$acct'  ";
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
   $us1310c   = $us;
   $conv1310c = $conv;

   $date   = 1311;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag in ($covflag) and m.acct='$acct'  ";
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
   $us1311c   = $us;
   $conv1311c = $conv;
   
   
   $date   = 1312;
   $conv   = $us = 0;
   $query  = "select sum(pv) + sum(pc) + sum(ln) + sum(mi) + sum(ec) + sum(mt) + sum(ca) + sum(cl) + sum(cv) + sum(cd) + sum(lc)  ";
   $query .= " + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv)  ";
   $query .= " as conv ";
   $query .= ", sum(us) us ";
   $query .= "from tnetlogARTU13 as u left join tgrams.main as m on u.acct=m.acct where date='$date' and covflag in ($covflag) and m.acct='$acct'  ";
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
   $us1312c   = $us;
   $conv1312c = $conv;

   ########################################################

   print wf "$comp ($acct)\t";
   print wf "$us1301\t$us1302\t$us1303\t$us1304\t$us1305\t$us1306\t$us1307\t$us1308\t$us1309\t$us1310\t$us1311\t$us1312\t";
   print wf "$conv1301\t$conv1302\t$conv1303\t$conv1304\t$conv1305\t$conv1306\t$conv1307\t$conv1308\t$conv1309\t$conv1310\t$conv1311\t$conv1312\t";
   print wf "$us1301n\t$us1302n\t$us1303n\t$us1304n\t$us1305n\t$us1306n\t$us1307n\t$us1308n\t$us1309n\t$us1310n\t$us1311n\t$us1312n\t";
   print wf "$conv1301n\t$conv1302n\t$conv1303n\t$conv1304n\t$conv1305n\t$conv1306n\t$conv1307n\t$conv1308n\t$conv1309n\t$conv1310n\t$conv1311n\t$conv1312n\t";
   print wf "$us1301c\t$us1302c\t$us1303c\t$us1304c\t$us1305c\t$us1306c\t$us1307c\t$us1308c\t$us1309c\t$us1310c\t$us1311c\t$us1312c\t";
   print wf "$conv1301c\t$conv1302c\t$conv1303c\t$conv1304c\t$conv1305c\t$conv1306c\t$conv1307c\t$conv1308c\t$conv1309c\t$conv1310c\t$conv1311c\t$conv1312c\t";
   print wf "\n";
  
   $z++;
}

close(wf);

$dbh->disconnect;

print "\n\nDone...\n\n";
