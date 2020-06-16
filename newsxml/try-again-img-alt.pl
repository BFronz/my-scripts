#!/usr/bin/perl 
#                   
# repulls all images for a month   

  
$fdate  = $ARGV[0]; 
$yy = substr($fdate, 0, 2);

if($fdate eq "") {print "\n\nMissing Date YYMM\n\n"; exit;}

$BASEURL     = "http://news.tnt.com/tin_advertiser_stats.xml";
$newstable    = "news_ad_cat" . $yy ;   
$user     = "";
$timeout  = " --timeout=30 --tries=1  ";
   
$i=1;
use DBI;
$dbh    = DBI->connect("dbi:mysql:tgrams:localhost", "", "");

$query  = "select BannerImageURL as url, AdvertiserCid  from  thom$newstable  ";
$query .= "where date=$fdate ";
$query .= "group by BannerImageURL order by url ";
#$query .= "limit 10";
print "$query\n\n"; 
 

my $sth = $dbh->prepare($query);
print "$query\n";
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
    {                    
     $img    = $$row[0];
     $img    =~ s|http://rpt.news.c.net/adreports/adreport-images/||g ;
     $imgloc = "/usr/pdf/imagesx_temp/" . $img; 
     #$imgloc = "/usr/pdf/imagesx/" . $img; 
  
     print "$i)  $$row[0]\t AdvertiserCid = $$row[1]\n\n";

     $cmd = "wget  --no-check-certificate $user $timeout \"$$row[0]\" -O $imgloc";  
     system("$cmd");
     $i++;
    }
$sth->finish;
