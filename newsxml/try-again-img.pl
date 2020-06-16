#!/usr/bin/perl 
#                   
# rechecks  all images for the month 
# pulls i 

  
$fdate  = $ARGV[0]; 
$yy = substr($fdate, 0, 2);

if($fdate eq "") {print "\n\nMissing Date YYMM\n\n"; exit;}

$BASEURL     = "http://news.tnt.com/tin_advertiser_stats.xml";
$newstable    = "news_ad_cat" . $yy ;   
$user1	     = "--http-user=reps --http-passwd";
$timeout  = " --timeout=30 --tries=1  ";
$i=1;
   
open(wf, ">scpimg") || die (print "Could not open scpimg") ;
 
use DBI; 
require "/usr/wt/trd-reload.ph";

$query  = "select BannerImageURL as url, SUBSTRING_INDEX(BannerImageURL, '/', -1) as img, AdvertiserCid a from  thom$newstable  ";
$query .= "where date=$fdate ";
#$query .="and AdvertiserCid in (1313240,1160254)";
$query .= "group by AdvertiserCid , url order by img ";
print "$query\n"; 
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{  
  $url    = $$row[0];                   
  $img    = $$row[1];
  $cid   = $$row[2];
  $imgloc = "/usr/pdf/imagesx/" . $img; 
 
  #create an scp file 
  print wf "scp phobus:$imgloc /usr/pdf/imagesx/ \n"; 


  if ( -e "$imgloc" &&  -s  "$imgloc") # check for image again if doesn't exist flag it
  {  
    print "OK: $imgloc\n";
    
  }
  else
  {
   print "$i) acct:$cid - Missing: $imgloc > $url\n"; $i++;
 
   $cmd = "wget  --no-check-certificate $user1 $timeout \"$url\" -O $imgloc";
   system("$cmd");
   #print "\n$cmd\n";
   if ( -e "$imgloc") {  print "\t$imgloc exists!\n";}
   else { print "Still missing\n"; }

   }  


}
$sth->finish;

close(wf);


$rc = $dbh->disconnect;
