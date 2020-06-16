#!/usr/bin/perl 
#                   
#
# updates network tile ads in the data 
# run as ./news-tilead-update4.pl 1305 
# then check network_ad_update.txt and run mysql thomas < network_ad_update.txt
    
if($ARGV[0] eq "") { print "\n\nMissing Date YYMM\n\n"; exit; }
$fdate     = $ARGV[0]; 
$yy        = substr($fdate, 0, 2);
$newstable = "news_ad_cat" . $yy ;    
 
use DBI;
require "/usr/wt/trd-reload.ph";
  
open(wf, ">network_ad_update.txt") || die (print "Could not open network_ad_update.txt");
                                             
$query  = "SELECT Campaign, substring_index(campaign , ' ', -1), CampaignID, BannerID ";
$query .= "FROM thomnews_ad_cat$yy ";
$query .= "WHERE campaign LIKE '%Network Tile Ads%' AND date='$fdate' ";
#print "$query\n"; 
$i=1;  
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{ 
 $Campaign   = $$row[0];
 $cid        = $$row[1]; 
 $cid        =~ s/CID//g;
 $cid        =~ s/^\s+//;
 $cid        =~ s/\s+$//;
 $CampaignID =  $$row[2]; 
 $BannerID   =  $$row[3]; 

 print "$i) $campaign\t$$row[1]\t$cid\n"; 
 
 print wf "UPDATE thomnews_ad_cat$yy SET AdvertiserCid='$cid' ";
 print wf "WHERE  date='$fdate' AND campaign ='$Campaign' AND CampaignID='$CampaignID' AND BannerID='$BannerID';\n";

 $i++;                                                            
}
$sth->finish;

close(wf);

$dbh->disconnect;  
              
print "\n\n*** NOTE *** Check file network_ad_update.txt then run mysql thomas < network_ad_update.txt ***\n\n";
print "Done...\n"
