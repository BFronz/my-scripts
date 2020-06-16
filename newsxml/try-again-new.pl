#!/usr/bin/perl 
#                   
# Retreives images 
  
  
$fdate  = $ARGV[0]; 
$yy = substr($fdate, 0, 2);

if($fdate eq "") {print "\n\nMissing Date YYMM\n\n"; exit;}

   

$i=1;
use DBI;
require "/usr/wt/trd-reload.ph";

$BASEURL     = "http://news.tnt.com/tin_advertiser_stats.xml";
$newstable    = "news_ad_cat" . $yy ;   
$user     = "--http-user=reps --http-passwd";
$timeout  = " --timeout=30 --tries=1  ";

open(wf, ">scpimg") || die (print "Could not open scpimg") ;

print "\n\n";
$query  = "select  AdvertiserCid, BannerImageURL, substring_index(BannerImageURL, '/', -1)  from  thom$newstable where date='$fdate'  ";
#$query .= " and AdvertiserCid = 10023494  ";
#$query .= " and badimg = 'Y' ";
$query .= "group by BannerImageURL ";
$query .= "  order by  BannerImageURL ";
#print "$query\n"; 
#exit;
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {                    
     $imgloc = "/usr/pdf/imagesx/" . $$row[2]; 

     if (( -e "$imgloc" ) && ( -s "$imgloc" ))  # check for image if doesn't exist pull
      {   
        print "$i) EXISTS $$row[0]\t$imgloc\n";
        $badimg="N";
      }
     else
      {  
        print "$i) GET  $$row[0]\t$imgloc\n";
        $badimg="Y"; 
  
        $cmd = "wget  --no-check-certificate $user $timeout \"$$row[1]\" -O $imgloc";  
	print "\n$cmd\n"; 
       system("$cmd");   
  
        if (( -e "$imgloc" ) && ( -s "$imgloc" ))
          {  
             print "$i) OK NOW $$row[0]\t$imgloc\n";
             $badimg="N";
          }

	#create an scp file
  	print wf "scp phobus:$imgloc /usr/pdf/imagesx/ \n";
 
      }

     $subq  = "update thom$newstable set badimg='$badimg' where BannerImageURL='$$row[1]' and date='$fdate' ";  
     print "$subq\n";	
     my $subr = $dbh->prepare($subq);
     if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
     $subr->finish; 
     print "$imgloc\tbadimg: $badimg\n\n";  
     $i++; 
     sleep(1);
  }
$sth->finish;
close(wf);


 
$query  = "select  count(*) from thom$newstable where date='$fdate' and badimg='Y'  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
if (my $row = $sth->fetchrow_arrayref)
 {
	print "\nTotal badimg:  $$row[0]\n";		
 }
$sth->finish;
