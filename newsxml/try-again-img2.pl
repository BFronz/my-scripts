#!/usr/bin/perl 
#                   
  
# Use this var to test for errors. If AdvertiserCid = 0 don't worry about it  
#$showerr = 1;
  
$fdate  = $ARGV[0]; 
$yy = substr($fdate, 0, 2);

if($fdate eq "") {print "\n\nMissing Date YYMM\n\n"; exit;}

$BASEURL     = "http://news.tnt.com/tin_advertiser_stats.xml";
$TESTURL     = "http://rpt.news.c.net/adreports/adreport-images/newark-wire-cloth_rc_2.jpg";
$newstable    = "news_ad_cat" . $yy ;   
$user     = "--http-user=reps --http-passwd";
$timeout  = " --timeout=30 --tries=1  ";
   
$i=1;
use DBI;
$dbh    = DBI->connect("dbi:mysql:tgrams:localhost", "", "");
$query  = "select BannerImageURL as url, AdvertiserCid  from  thom$newstable  ";
$query .= "where AdvertiserCid in (00580020)  ";
$query .= "group by BannerImageURL order by url ";
print "$query\n";
   
$query  = "select BannerImageURL as url, AdvertiserCid  from  thom$newstable  ";
$query .= "where badimg='Y'  ";
$query .= "group by BannerImageURL order by url ";
print "$query\n";

$query  = "select BannerImageURL as url, AdvertiserCid  from  thom$newstable  ";
$query .= "where badimg='N' and date=$fdate ";
#$query .= "and BannerImageURL='$TESTURL'";
print "$query\n"; 

my $sth = $dbh->prepare($query);
#print "$query\n";
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
    {                    
     $img    = $$row[0];
     $img    =~ s|http://rpt.news.c.net/adreports/adreport-images/||g ;
     $imgloc = "/usr/pdf/imagesx/" . $img; 
     #$imgloc = "/usr/tnetlogs/wt/newsxml/" . $img; 

     print "$i)  $$row[0]\t AdvertiserCid = $$row[1]\n";
     if($showerr eq "")
         {
          $cmd = "wget  --no-check-certificate $user $timeout \"$$row[0]\" -O $imgloc";  
          system("$cmd");
         }
        $i++; 

 
     if ( -z "$imgloc") # check for image again if doesn't exist flag it
       { 
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
