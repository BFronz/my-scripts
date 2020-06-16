#!/usr/bin/perl 
#                   
# Retreives xml, adds newline characters and writes to a local file 
#
# Run this first ./news-get-xml1.pl YYMM
#
# then run ./news-get-xml3.pl YYMM
  
$fdate  = $ARGV[0]; 
if($fdate eq "") {print "\n\nMissing Date YYMM\n\n"; exit;}
$yy = substr($fdate, 0, 2);
$newstable   = "news_ad_cat" . $yy ;    
$BASEURL     = "http://news.tnt.com/tin_advertiser_stats.xml";
$BASEURL     = "http://news-lb.news.c.net/tin_advertiser_stats.xml";
$BASEURL     = "http://news-lb.news.c.net/tnreports/tin_advertiser_stats.xml";




$newsfile    = "newsdata" . $fdate .  ".xml";   
$newsfilebak = "newsdata" . $fdate .  ".xml" .  ".bak";   
#$user     = "--http-user=cmg --http-passwd=";
#$timeout  = " --timeout=10800 --tries=1  ";

use DBI;
require "/usr/wt/trd-reload.ph";
 

#$BASEURL     = "http://tnetnews.tnt.com/tnreports/tin_advertiser_stats.html";
#$user     = "--http-user=bjenkins --http-passwd=roscoe1200";  

 
# Get file
#$cmd = "wget $user $timeout \"$BASEURL\" -O $newsfile";   
#print "\n\ncmd: $cmd\n\n"; exit;
#system("$cmd");
  



# Delete this months data from table
$query  =  "delete from thom$newstable where date='$fdate' ";


my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

  
# Add new line chars, not pretty but it works
$cmd = "perl -pi.bak -0777 -e 's|</DateRange>|</DateRange>\n|g' $newsfile";
system("$cmd");
 
$cmd = "perl -pi.bak -0777 -e 's|</Advertiser>|</Advertiser>\n|g' $newsfile";
system("$cmd");

$cmd = "perl -pi.bak -0777 -e 's|<AdBlock>|<AdBlock>\n|g' $newsfile";
system("$cmd");

$cmd = "perl -pi.bak -0777 -e 's|</AdBlock>|</AdBlock>\n|g' $newsfile";
system("$cmd");
 
$cmd = "perl -pi.bak -0777 -e 's|</AdvertiserID>|</AdvertiserID>\n|g' $newsfile";
system("$cmd");
  
#$cmd = "perl -pi.bak -0777 -e 's|</AdveristerCid>|</AdveristerCid>\n|g' $newsfile";
$cmd = "perl -pi.bak -0777 -e 's|</AdveristerCID>|</AdveristerCID>\n|g' $newsfile";
system("$cmd");
   
#$cmd = "perl -pi.bak -0777 -e 's|</Campaign>|</Campaign>\n|g' $newsfile";
$cmd = "perl -pi.bak -0777 -e 's|</campaignname>|</campaignname>\n|g' $newsfile";
system("$cmd");
 
#$cmd = "perl -pi.bak -0777 -e 's|</CampaignID>|</CampaignID>\n|g' $newsfile";
$cmd = "perl -pi.bak -0777 -e 's|</campaignid>|</campaignid>\n|g' $newsfile";
system("$cmd");
 
$cmd = "perl -pi.bak -0777 -e 's|</CampaignType>|</CampaignType>\n|g' $newsfile";
system("$cmd");

$cmd = "perl -pi.bak -0777 -e 's|</BannerID>|</BannerID>\n|g' $newsfile";
system("$cmd");

$cmd = "perl -pi.bak -0777 -e 's|</BannerCategory>|</BannerCategory>\n|g' $newsfile";
system("$cmd");

$cmd = "perl -pi.bak -0777 -e 's|</BannerImageURL>|</BannerImageURL>\n|g' $newsfile";
system("$cmd");

$cmd = "perl -pi.bak -0777 -e 's|</BannerViews>|</BannerViews>\n|g' $newsfile";
system("$cmd");

$cmd = "perl -pi.bak -0777 -e 's|</BannerClicks>|</BannerClicks>\n|g' $newsfile";
system("$cmd");

$cmd = "perl -pi.bak -0777 -e 's|</CampaignTotalViews>|</CampaignTotalViews>\n|g' $newsfile";
system("$cmd");

$cmd = "perl -pi.bak -0777 -e 's|</CampaignTotalClicks>|</CampaignTotalClicks>\n|g' $newsfile";
system("$cmd");

  
# Remove backup file
#$cmd = "rm -f $newsfilebak";
#system("$cmd");



