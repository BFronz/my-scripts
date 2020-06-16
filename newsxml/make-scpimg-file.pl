#!/usr/bin/perl 
#                   
# Retreives images 
  
  
$fdate  = $ARGV[0]; 
$yy = substr($fdate, 0, 2);

if($fdate eq "") {print "\n\nMissing Date YYMM\n\n"; exit;}

$newstable    = "news_ad_cat" . $yy ;
   

$i=1;
use DBI;
require "/usr/wt/trd-reload.ph";

open(wf, ">scpimg") || die (print "Could not open scpimg") ;

print "\n\n";
$query  = "select  AdvertiserCid, BannerImageURL, substring_index(BannerImageURL, '/', -1)  from  thom$newstable where date='$fdate'  ";
$query .= "group by BannerImageURL ";
$query .= "order by  BannerImageURL ";
print "$query\n"; 
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
	{                     
		$imgloc = "/usr/pdf/imagesx/" . $$row[2]; 
		print wf "scp phobus:$imgloc /usr/pdf/imagesx/ \n";
	}
$sth->finish;
close(wf);
