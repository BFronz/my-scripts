#!/usr/bin/perl
#
# Run as ./load-site-new.pl yymm
# This adds "Email to Supplier" counts (ea) in tnetlogSITEN
# Also News stories, press rel, email colleague, links, news contacts, product catalog 
         
if($ARGV[0] eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
use POSIX;
require "/usr/wt/trd-reload.ph";
 
$year    = substr($ARGV[0], 0, 2);
$yy      = $year;
$month   = substr($ARGV[0], 2, 2);
$logtime = $year . $month ;
$month   =~ s/^0//g;
$year    = "20" . $year ;

 
# Get unixtime for begin of month
$sec   =  0;
$min   =  0;
$hour  =  0;
$day   =  1;
$mon   = $month   - 1;
$yyear = $year - 1900;
$wday  = 0;
$yday  = 0;
$start =  mktime($sec, $min, $hour, $day, $mon, $yyear, $wday,0,-1);
#print "$start\n";
#$readable_time = localtime($start);
#print "$readable_time\n";

# Get unixtime for end of month
$day=31;
if($month==9 || $month==4 || $month==6 || $month==11  ) {   $day = 30; }
if ($month==2) {$day=28; }
$sec   =  59;
$min   =  59;
$hour  =  23;
$mon   = $month   - 1;
$yyear = $year - 1900;
$wday  = 0;
$yday  = 0; 
$end   =  mktime($sec, $min, $hour, $day, $mon, $yyear, $wday,0,-1);
#print "$end\n";
#$readable_time = localtime($end);
#print "$readable_time\n";

# Get contact counts  
$query = " select count(*) from tgrams.contacts where (created>=$start and created<=$end) and  notsent < 1 and test_msg!=1 and other!=50 and sell!=50   ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {   $contact_count = $$row[0];     }
$sth->finish; 
 
# Get News counts  >> note that this is now done in news-site.pl due to green & clean addition Aug 2011 advPRIDViews dset=cidprid group=news_view 0
# leaving this here anyway
$query = "  select sum(storyviews), sum(press), sum(estory), sum(ecomp), sum(linksweb) as linksweb from thomtnetlogPNN$yy where date='$logtime'  ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {   
  $story_count  = $$row[0];     
  $press_count  = $$row[1];     
  $estory_count = $$row[2]; # email colleague
  $ecomp_count  = $$row[3]; # add to contacts
  $linksweb     = $$row[4]; # links
 } 
$sth->finish; 

# Get prod catalog counts
$prodcat_count = 0;   
# Old
$query = "  select sum(pc) from thomtnetlogARTU$yy   where acct>0 and date='$logtime' and covflag='t'  ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
  # $prodcat_count = $$row[0];     
 } 
$sth->finish; 

# Get prod catalog counts
$query = "  select sum( totalpageviews ) from thomflat_catnav_summmary$yy   where isactive='yes' and date='$logtime'   ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $prodcat_count = $$row[0];
 }
$sth->finish;

$query = "  select sum( totalpageviews ) from thomcatnav_summmary$yy   where isactive='yes' and date='$logtime'   ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $prodcat_count += $$row[0];
 }
$sth->finish;



# Get CCP counts   
$query = "  select  sum(vv),  sum(dv),  sum(iv),  sum(sm),  sum(pp),  sum(mv) from thomtnetlogARTU$yy   where acct>0 and date='$logtime' and covflag='t'  ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {  
  $ccp_vv = $$row[0];     
  $ccp_dv = $$row[1];     
  $ccp_iv = $$row[2];     
  $ccp_sm = $$row[3];     
  $ccp_pp = $$row[4];     
  $ccp_mv = $$row[5];     
 } 
$sth->finish; 
 
#old 
$query = " update thomtnetlogSITEN set cv=$prodcat_count, ea=$contact_count, news_stories=$story_count, ";
$query .= "press_rel=$press_count, ec=ec+$estory_count, la=la+$linksweb  where date='$logtime' ";
 
#new
$query = " update thomtnetlogSITEN set cv='$prodcat_count', ea='$contact_count', news_ea='$ecomp_count', news_stories='$story_count', ";
$query .= "press_rel='$press_count', news_ec='$estory_count', news_la='$linksweb',  ";
$query .= " vv='$ccp_vv',  dv='$ccp_dv', iv='$ccp_iv', sm='$ccp_sm',  pp='$ccp_pp',  mv='$ccp_mv' "; 
$query .= "where date='$logtime' "; 

print "\n\nQUERY: $query\n\n";
 
#print "cv='$prodcat_count'\nea='$contact_count'\nnews_ea='$ecomp_count'\nnews_stories='$story_count'\npress_rel='$press_count'\nnews_ec='$estory_count'\nnews_la='$linksweb'\n\n";  
   
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
$sth->finish;
  
## Disconnect from thomas database
$rc = $dbh->disconnect;


 

