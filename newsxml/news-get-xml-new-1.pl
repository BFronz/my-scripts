#!/usr/bin/perl 
#                   
  
$fdate  = $ARGV[0]; 
if($fdate eq "") {print "\n\nMissing Date YYMM\n\n"; exit;}
$yy = substr($fdate, 0, 2);


use DBI;
require "/usr/wt/trd-reload.ph";

$DIR = " /usr/wt/newsxml";

$newstable = "news_ad_cat" . $yy;
$infile    = "impressions.txt";
$outfile   = "news_ad_cat" . $yy . ".txt" ;    
  
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");


# Delete this months data from table
$query  =  "delete from thom$newstable where date='$fdate' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
$badimg="";

open(rf, "$infile")  || die (print "Could not open $infile\n");
while (!eof(rf))
	{   
		$instr = <rf>;
		chop($instr);  
 		(
			$Advertiser,
			$keyword,
			$SubType,
			$AdvertiserID,
			$AdvertiserCID,
			$campaignname,
			$campaignid,
			$CampaignType,
			$BannerID,
			$BannerCategory,
			$BannerImageURL,
			$ROSImage,
			$PHADImage,
			$OtherImage,
			$BannerViews,
			$BannerClicks) = split(/\t/, $instr);
		
		if($AdvertiserCID gt 0 && $BannerImageURL ne "") 
			{ 	  
			print wf "$fdate\t";
			print wf "$Advertiser\t";
			print wf "$AdvertiserID\t";
			print wf "$AdvertiserCID\t";
			print wf "$campaignname\t";
			print wf "$campaignid\t";
			print wf "$CampaignType\t";
			print wf "$BannerID\t";
			print wf "$BannerCategory\t";
			print wf "$BannerImageURL\t";
			print wf "$BannerViews\t";
			print wf "$BannerClicks\t";
			print wf "$badimg\n";
			}  
	}    
	close(rf);

close(wf);

 

system("mysqlimport -iL thomas $DIR/$outfile");

 
