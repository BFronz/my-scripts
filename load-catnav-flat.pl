#!/usr/bin/perl
#
#

$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
require "/usr/wt/trd-reload.ph";

$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);  
$outfile  = "flat_catnav_summmarylog.txt";
$outfile2 = "flat_catnav_summmary$yy.txt";

# Summary   
$file[0]  = "totalpageviews:CatFlatTotalPagesViewed";  # Total Catalog Pages Viewed        - date, acct, cnt                
$file[1]  = "totalses:CatFlatUserSessions";            # Catalog User Sessions             - date, acct, visits, visitors   
$file[2]  = "avgpagesperses:CatFlatAvePagePerSession"; # Average Pages Viewed per Session  - date, acct, pgspervisit
$file[3]  = "avgsesdur:CatFlatAveSesDuration";         # Average Session Duration (min.)   - date, acct, avgminutes
         
#$file[4]  = "totalitemdetailviews:CatFlatItemDetailPages";  # Item Detail Pages Viewed  - date, acct, cnt
$file[4]  = "totalassetdlviews:CatFlatAssetDlViews";        # Asset Downloads/Views     - date,acct, cnt
$file[5]  = "totalprintpages:CatFlatPrintPages";            # Printable Pages           - date, acct, cnt
$file[6]  = "totalinq:CatFlatRequestInformation";           # Request for Information   - date, acct, cnt 
$file[7]  = "totalordrfqs:CatFlatRequestQuoteOrders";       # E-Mail to Colleague       - date, acct, cnt
$file[8]  = "totalcad:CatFlatCAD";                          # CAD Downloads/Inserts     - date, acct, cnt
 
$file[9] = "totalsearchend:CatFlatUsersSearchEng";         # Total users from Search Engines - date, acct, cnt
  
#  Compare Items Side-By-Side   totalitemcomparison NOT AVAILABLE IN FLAT VERSION
#  E-mail Pages                 totalemailpage      NOT AVAILABLE IN FLAT VERSION
#  Save to Favorites            totalsavefav        NOT AVAILABLE IN FLAT VERSION
# Note ??? Request for Information totalInq SOURCE: CMG CONTACT TABLE (table but won't be availalbe for all of March 2013)
   
# Delete from tables
$query = "delete from thomflat_catnav_summmarylog";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
              
$query = "delete from thomflat_catnav_summmary$yy where date='$fdate'";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

# Load files into log file
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
foreach $file (@file)        
 {                               
   ($type,$f) = split(/\:/, $file);
   $infile    = $fyear . "/" . $f . "-" . $fdate . ".txt";
   print "$infile\n";
   
   open(rf, "$infile")  || die (print "Could not open $infile\n");
   while (!eof(rf))
    {
      $instr = <rf>;
      chop($instr);
 
      ($d,$a,$ct,$ex) = split(/\t/,$instr);

      if($infile =~ /CatFlatUserSessions/) { $ct = $ex; }
  
      print wf "$d\t$a\t$ct\t$type\n"; 
      $d = $a = $ct = $ex = ""; 
   } 
   close(rf); 
 }
close(wf);



system("mysqlimport -diL thomas $DIR/$outfile"); 
   
# Query and load summary table 
open(wf,  ">$outfile2")  || die (print "Could not open $outfile2\n");

$query  = " select date, '', acct, '', 'Yes', '', '', '', ";
$query .= " sum(if(type='totalses',cnt,0))                 as    totalses                  , ";
$query .= " sum(if(type='totalpageviews',cnt,0))           as    totalpageviews            , ";
$query .= " sum(if(type='totalitemdetailviews',cnt,0))     as    totalitemdetailviews      , ";
$query .= " sum(if(type='totalassetdlviews',cnt,0))        as    totalassetdlviews         , ";
$query .= " sum(if(type='totalinq',cnt,0))                 as    totalinq                  , ";
$query .= " sum(if(type='totalprintpages',cnt,0))          as    totalprintpages           , ";
$query .= " sum(if(type='totalemailpage',cnt,0))           as    totalemailpage            , ";
$query .= " sum(if(type='totalsavefav',cnt,0))             as    totalsavefav              , ";
$query .= " sum(if(type='totalitemcomparison',cnt,0))      as    totalitemcomparison       , ";
$query .= " sum(if(type='totalprintablepdf',cnt,0))        as    totalprintablepdf         , ";
$query .= " sum(if(type='totalcaddownload',cnt,0))         as    totalcaddownload          , ";
$query .= " sum(if(type='totalordrfqs',cnt,0))             as    totalordrfqs              , ";
$query .= " sum(if(type='percentsesitemdetailview',cnt,0)) as    percentsesitemdetailview  , ";
$query .= " sum(if(type='percentsesassetdlview',cnt,0))    as    percentsesassetdlview     , ";
$query .= " sum(if(type='percentsesinq',cnt,0))            as    percentsesinq             , ";
$query .= " sum(if(type='percentsesprintpage',cnt,0))      as    percentsesprintpage       , ";
$query .= " sum(if(type='percentsesemailpage',cnt,0))      as    percentsesemailpage       , ";
$query .= " sum(if(type='percentsessavefav',cnt,0))        as    percentsessavefav         , ";
$query .= " sum(if(type='percentsesitemcomparison',cnt,0)) as    percentsesitemcomparison  , ";
$query .= " sum(if(type='percentsesprintablepdf',cnt,0))   as    percentsesprintablepdf    , ";
$query .= " sum(if(type='percentsescaddownload',cnt,0))    as    percentsescaddownload     , ";
$query .= " sum(if(type='percentsesordrfq',cnt,0))         as    percentsesordrfq          , ";
$query .= " sum(if(type='avgpagesperses',cnt,0))           as    avgpagesperses            , ";
$query .= " sum(if(type='avgsesdur',cnt,0))                as    avgsesdur                 , ";
$query .= " sum(if(type='percentsesclientsiteref',cnt,0))  as    percentsesclientsiteref   , ";
$query .= " sum(if(type='percentsestnetref',cnt,0))   as    percentsestnetref    , ";
$query .= " sum(if(type='percentsesgoogleref',cnt,0))      as    percentsesgoogleref       , ";
$query .= " sum(if(type='percentsesothersengref',cnt,0))   as    percentsesothersengref    , ";
$query .= " sum(if(type='percentsesotherref',cnt,0))       as    percentsesotherref        , ";
$query .= " sum(if(type='percentsesdirectcatalog',cnt,0))  as    percentsesdirectcatalog   , ";
$query .= " sum(if(type='totalsearchend',cnt,0))           as    totalsearchend            , ";
$query .= " sum(if(type='totalcad',cnt,0))                 as    totalcad                    ";
$query .= " from thomflat_catnav_summmarylog       ";
$query .= " where date='$fdate' and acct>0  ";
$query .= " group by acct ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
 $date                     = $$row[0];  
 $cnid                     = $$row[1];  
 $tgramsid                 = $$row[2];  
 $company                  = $$row[3];  
 $isactive                 = $$row[4];  
 $isecommerce              = $$row[5];  
 $datepublish              = $$row[6];  
 $datequickpublish         = $$row[7];  
 $totalses                 = $$row[8];  
 $totalpageviews           = $$row[9]; 
 $totalitemdetailviews     = $$row[10]; 
 $totalassetdlviews        = $$row[11]; 
 $totalinq                 = $$row[12]; 
 $totalprintpages          = $$row[13]; 
 $totalemailpage           = $$row[14]; 
 $totalsavefav             = $$row[15]; 
 $totalitemcomparison      = $$row[16]; 
 $totalprintablepdf        = $$row[17]; 
 $totalcaddownload         = $$row[18]; 
 $totalordrfqs             = $$row[19]; 
 $percentsesitemdetailview = $$row[20]; 
 $percentsesassetdlview    = $$row[21]; 
 $percentsesinq            = $$row[22]; 
 $percentsesprintpage      = $$row[23]; 
 $percentsesemailpage      = $$row[24]; 
 $percentsessavefav        = $$row[25]; 
 $percentsesitemcomparison = $$row[26]; 
 $percentsesprintablepdf   = $$row[27]; 
 $percentsescaddownload    = $$row[28]; 
 $percentsesordrfq         = $$row[29]; 
 $avgpagesperses           = $$row[30]; 
 $avgsesdur                = $$row[31]; 
 $percentsesclientsiteref  = $$row[32]; 
 $percentsestnetref   = $$row[33]; 
 $percentsesgoogleref      = $$row[34]; 
 $percentsesothersengref   = $$row[35]; 
 $percentsesotherref       = $$row[36]; 
 $percentsesdirectcatalog  = $$row[37]; 
 $totalsearchend           = $$row[38]; 
 $totalcad                 = $$row[39];
 print wf "$date\t$cnid\t$tgramsid\t$company\t$isactive\t$isecommerce\t$datepublish\t$datequickpublish\t$totalses\t";
 print wf "$totalpageviews\t$totalitemdetailviews\t$totalassetdlviews\t$totalinq\t$totalprintpages\t$totalemailpage\t";
 print wf "$totalsavefav\t$totalitemcomparison\t$totalprintablepdf\t$totalcaddownload\t$totalordrfqs\t$percentsesitemdetailview\t";
 print wf "$percentsesassetdlview\t$percentsesinq\t$percentsesprintpage\t$percentsesemailpage\t$percentsessavefav\t";
 print wf "$percentsesitemcomparison\t$percentsesprintablepdf\t$percentsescaddownload\t$percentsesordrfq\t$avgpagesperses\t";
 print wf "$avgsesdur\t$percentsesclientsiteref\t$percentsestnetref\t$percentsesgoogleref\t$percentsesothersengref\t";
 print wf "$percentsesotherref\t$percentsesdirectcatalog\t$totalsearchend\t$totalcad\n";
 }   
$sth->finish; 
close(wf);

system("mysqlimport -iL thomas $DIR/$outfile2");
print "\n"; 



# Top Search Engine Referring Keyword Searches
$outfile = "flat_catnav_ref_keyword_searches" . $yy . ".txt";  #date, cnid, tgramsid, keyword_phrase, frequency     
$cind=""; 

$query = "delete from thomflat_catnav_ref_keyword_searches$yy where date='$fdate'";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
   
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
 
# FILE 1
$infile    = $fyear . "/" . "CatFlatSearchEngRefKeyword" . "-" . $fdate . ".txt"; #date, tgramsid, frequency, keyword_phrase
print "$infile\n";
open(rf, "$infile")  || die (print "Could not open $infile\n");
while (!eof(rf))
    {
      $instr = <rf>;
      chop($instr);
      ($d,$a,$ct,$ex) = split(/\t/,$instr);
      print wf "$d\t$cind\t$a\t$ex\t$ct\n"; 
      $d = $a = $ct = $ex = ""; 
   } 
close(rf); 

# FILE 2
$infile    = $fyear . "/" . "CatFlatSearchEngRefKeywordOSS" . "-" . $fdate . ".txt"; #date, tgramsid, frequency, keyword_phrase
print "$infile\n";
open(rf, "$infile")  || die (print "Could not open $infile\n");
while (!eof(rf))
    {
      $instr = <rf>;
      chop($instr);
      ($d,$a,$ct,$ex) = split(/\t/,$instr);
      print wf "$d\t$cind\t$a\t$ex\t$ct\n"; 
      $d = $a = $ct = $ex = ""; 
   } 
close(rf); 

close(wf);
system("mysqlimport -L thomas $DIR/$outfile"); 


# Top Catalog Keyword/Part Number Searches
$outfile = "flat_catnav_keyword_search" . $yy . ".txt";  #date, cnid, tgramsid, keyword_phrase, frequency     
$cind=""; 

$query = "delete from thomflat_catnav_keyword_search$yy where date='$fdate'";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
   
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
$infile    = $fyear . "/" . "CatFlatKeywordSearches" . "-" . $fdate . ".txt"; #date, tgramsid, frequency, keyword_phrase
print "$infile\n";
   
open(rf, "$infile")  || die (print "Could not open $infile\n");
while (!eof(rf))
    {
      $instr = <rf>;
      chop($instr);  
      ($d,$a,$ct,$ex) = split(/\t/,$instr);
      print wf "$d\t$cind\t$a\t$ex\t$ct\n"; 
      $d = $a = $ct = $ex = ""; 
   } 
close(rf); 
close(wf);
system("mysqlimport -L thomas $DIR/$outfile"); 


# Companies Using Your Advanced Web Solution
# see  load-org-drill-tnet-flatcatnav.pl 



# Top Product & Services Lines
$outfile = "flat_catnav_lines" . $yy . ".txt";  #date, acct, frequency, keyword_phrase,

$query = "delete from thomflat_catnav_lines$yy where date='$fdate'";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
$infile    = $fyear . "/" . "CatFlatProductServicesLines" . "-" . $fdate . ".txt"; #date, acct, frequency, keyword_phrase,
print "$infile\n";

open(rf, "$infile")  || die (print "Could not open $infile\n");
while (!eof(rf))
    {
      $instr = <rf>;
      chop($instr);
      ($d,$a,$freq,$kwp) = split(/\t/,$instr);
      print wf "$d\t$a\t$freq\t$kwp\n";
      $d = $a = $freq = $kwp = "";
   }
close(rf);
close(wf);
system("mysqlimport -L thomas $DIR/$outfile");



# User Engagement
$outfile = "flat_catnav_engagement" . $yy . ".txt";  #date, acct, pageviews, visits

$query = "delete from thomflat_catnav_engagement$yy where date='$fdate'";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
$infile    = $fyear . "/" . "CatFlatUserEngagement" . "-" . $fdate . ".txt"; #date, acct, pageviews, visits
print "$infile\n";

open(rf, "$infile")  || die (print "Could not open $infile\n");
while (!eof(rf))
    {
      $instr = <rf>;
      chop($instr);
      ($d,$a,$pv,$v) = split(/\t/,$instr);
      #print wf "$d\t$a\t$pv\t$v\n";
      print wf "$d\t$a\t$v\t$pv\n";
      $d = $a = $pv = $v = "";
   } 
close(rf);
close(wf);
system("mysqlimport -L thomas $DIR/$outfile");

$rc = $dbh->disconnect;



