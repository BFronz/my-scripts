#!/usr/bin/perl 
#                   
# Retreives images 
# Run this last
# Run as ./news-get-img3.pl YYMM
  
# Use this var to test for errors. If AdvertiserCid = 0 don't worry about it  
#$showerr = 1;
  
$fdate  = $ARGV[0]; 
$yy = substr($fdate, 0, 2);

if($fdate eq "") {print "\n\nMissing Date YYMM\n\n"; exit;}

$BASEURL     = "http://news.tnt.com/tin_advertiser_stats.xml";
$newstable    = "news_ad_cat" . $yy ;   
$user     = "--http-user=reps --http-passwd";
$timeout  = " --timeout=30 --tries=1  ";
   
$i=1;
use DBI;
require "/usr/wt/trd-reload.ph";


open(wf, ">badimg.txt") || die (print "Could not open badimg.txt"); 
open(wf2, ">scpimg-all") || die (print "Could not open scpimg-all") ;
  
$query  = "select BannerImageURL as url, AdvertiserCid, substring_index(BannerImageURL, '/', -1)   from  thom$newstable where date='$fdate'  ";
#$query .= " and AdvertiserCid = 588687 ";
#$query .= "and badimg='Y' ";
$query .= "group by BannerImageURL ";
$query .= "  order by url ";
print "$query\n"; exit; 
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
    {                    
     $img    = $$row[0];
     $img    =~ s|https://rsweb2.usabusiness.net/reports/adreport-images/||g ;
     $img    =~ s|http://adweb.news.c.net/www/reports/adreport-images/||g ;
     $img    =~ s|http://rpt.news.c.net/adreports/adreport-images/||g ;
     $img    =~ s|http://cfnewsads.tnt.com/||g ;
     $img    =~ s|http://cdn.tnt.com/pad/||g ;
     $img    =~ s|http://cfnewsads.tnt.com/||g ;
   
      
     $imgloc = "/usr/pdf/imagesx/" . $img; 

 


     if (( -e "$imgloc" ) && ( -s "$imgloc" ))  # check for image if doesn't exist pull
      { 
        #print "$i) EXISTS $$row[0]\t$$row[1]\n";
       }
     else
       { 
        print "$i) GET $$row[0]\t$$row[1]\n";
        if($showerr eq "")
         {
          $cmd = "wget  --no-check-certificate $user $timeout \"$$row[0]\" -O $imgloc";  
          system("$cmd");
         }
        $i++; 
       }
  
     if (( -e "$imgloc") && ( -s "$imgloc" )) # check for image again if doesn't exist flag it
      { 
       # print "$i)  $$row[0]\t AdvertiserCid = $$row[1] - Exists\n";
       print wf2 "scp phobus:/usr/pdf/imagesx/$$row[2]  /usr/pdf/imagesx/ \n";
       } 
     else
       { 
        print "BAD IMAGE\n";
        print wf "$$row[0]\n";
        $subq  = "update thom$newstable set badimg='Y' where BannerImageURL='$$row[0]' and date='$fdate' ";
        #print "$subq\n";
        if($showerr eq "")
          {
           my $subr = $dbh->prepare($subq);
           if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
           $subr->finish;
          } 
      }
    }
$sth->finish;
close(wf);
close(wf2);
 
