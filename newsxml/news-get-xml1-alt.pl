#!/usr/bin/perl 
#                   
# run like:
# April:
# http://news.tnt.com/tin_advertiser_stats.xml?startdate=2012-04-01&enddate=2012-04-30
# May:
# http://news.tnt.com/tin_advertiser_stats.xml?startdate=2012-05-01&enddate=2012-05-30
  

$fdate =  $ARGV[0];
$sdate  = $ARGV[1]; 
$edate  = $ARGV[2]; 
if($fdate eq "" || $sdate eq "" || $edate  eq "") {print "\n\nMissing date(s) Check...\n\n"; exit;}
$yy = substr($fdate, 0, 2);
$newstable   = "news_ad_cat" . $yy ;    
$BASEURL     = "http://news.tnt.com/tin_advertiser_stats.xml";
$BASEURL    .=  "?startdate=$sdate&enddate=$edate";
$newsfile    = "newsdata" . $fdate .  ".xml";   
$newsfilebak = "newsdata" . $fdate .  ".xml" .  ".bak";
     
#$user     = "--http-user=cmg --http-passwd=";
#$timeout  = " --timeout=10800 --tries=1  ";

use DBI;
$dbh    = DBI->connect("dbi:mysql:tgrams:localhost", "", "");

 
# Get file
$cmd = "wget $user $timeout \"$BASEURL\" -O $newsfile";  
#print "$cmd"; exit;
system("$cmd");


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
  
$cmd = "perl -pi.bak -0777 -e 's|</AdveristerCid>|</AdveristerCid>\n|g' $newsfile";
system("$cmd");
 
$cmd = "perl -pi.bak -0777 -e 's|</Campaign>|</Campaign>\n|g' $newsfile";
system("$cmd");

$cmd = "perl -pi.bak -0777 -e 's|</CampaignID>|</CampaignID>\n|g' $newsfile";
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



