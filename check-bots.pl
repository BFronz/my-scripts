#!/usr/bin/perl
#
# checks total us & conv

use DBI;
use POSIX;
$dbh = DBI->connect("", "", "");

$outfile = "checkbots.txt";
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");

$type = "new"; 
#$debug=1;
$debug2=1;
 
$i=0; 
#$query  = "SELECT company,acct FROM tgrams.main WHERE adv>'' and acct=587988   ORDER BY company ";
$query  = "SELECT company,acct FROM tgrams.main WHERE adv>''   ORDER BY company ";
#$query  .= "LIMIT 100";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $record[$i]="$$row[0]|$$row[1]";
  $i++;
 }
$sth->finish;

$z=1;
foreach $record (@record)
 {
   print "$z)\t$record\n";
   ($comp,$acct) = split(/\|/,$record);


   ######### 1212 ##########
   $dd = 1212;
   $yy = 12;  
   # total sessions
   $query = "select sum(us) as us from thomtnetlogARTU$yy where acct='$acct' and date='$dd' and covflag='t' ";
   if($debug == 1){print "\n$query;\n";}
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {       
     $us = $$row[0];  
    } 
   $sth->finish; 
 
  # total convsrsions
  $query  = "select sum(pv) + sum(ln) + sum(cl) + sum(cv) + sum(ec) + sum(ca) + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv) + sum(lc) + sum(cd) + sum(pc), ";
  $query .= " sum(ln) as links, ";
  $query .= " sum(pv) as profile, ";
  $query .= "  sum(vv) as video, ";
  $query .= "  sum(dv) as document, ";
  $query .= "  sum(iv) as image, ";
  $query .= "  sum(sm) as social, ";
  $query .= "  sum(pp) as print,  ";
  $query .= "  sum(mv) as map, ";
  $query .= "  sum(lc)+sum(cl) as linkscad, ";
  $query .= "  sum(cd) as cad ";
  $query .= "from thomtnetlogARTU$yy where acct='$acct' and date='$dd' and covflag='t' "; 
   if($debug == 1){print "\n$query;\n";}
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {      
     $conv     = $$row[0];
     $links    =  $$row[1];	
     $profile  =  $$row[2];
     $video    = $$row[3];
     $document = $$row[4];
     $image    = $$row[5];
     $social   = $$row[6];
     $print    = $$row[7];
     $map      = $$row[8];
     $linkscad = $$row[9]; 
     $cad      = $$row[10]; 
   
     # news conv
     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot, ";
     $subq .= "sum(nsv) as newsrelviews, sum(nlw) as newslinks  ";
     $subq .= "from thomnews_conversions$yy where  date='$dd' and acct='$acct' ";
     if($debug == 1){print "\n$subq;\n";}
     my $subr2 = $dbh->prepare($subq); 
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0];  $newsrelviews= $$srow2[1]; $newslinks = $$srow2[2];  }
     $subr2->finish; 

     # banner clicks
     $subq   = "select sum(BannerClicks), sum(BannerViews) from thomnews_ad_cat$yy ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$dd' ";
     if($debug == 1){print "\n$subq;\n";}
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; $totaladclicks = $$srow2[0];  $BannerViews= $$srow2[1];  }
     $subr2->finish;
    
     # pai clicks
     $subq   = "select sum(clicks), sum(views) from thomtnetlogADviewsServer$yy where acct='$acct' and adtype ='pai' and fdate='$dd'  ";
     if($debug == 1){print "\n$subq;\n";}
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; $totaladclicks += $$srow2[0]; $viewsPAI= $$srow2[1];  }
     $subr2->finish;
   
     # bad clicks
     $subq   = "select sum(clicks), sum(views)  from thomtnetlogADviewsServer$yy where acct='$acct' and adtype ='bad' and fdate='$dd'  ";
     if($debug == 1){print "\n$subq;\n";}
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0];  $totaladclicks += $$srow2[0]; $viewsBAD= $$srow2[1];  }
     $subr2->finish;
    
     # off catalog
     $subq  = "SELECT SUM(totalpageviews) AS totalpageviews, sum(totalemailpage) as totalemailpage, sum(totalses) as totalses, sum(totalItemdetailviews + totalassetdlviews + totalitemcomparison + totalprintpages + totalsavefav + totalemailpage) as totalconv ";
     $subq .= "FROM thomcatnav_summmary$yy WHERE tgramsid ='$acct' and isactive='yes' and date='$dd' ";
     if($debug == 1){print "\n$subq;\n";}        
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) 
      {  
       #$conv += $$srow2[0]; 
       $totalpageviewsoff=$$srow2[0]; 
       #$RequestQuoteoff =  $$srow2[1];
      }
     $subr2->finish;   
 
     # on catalog 
     $subq   = "SELECT SUM(totalpageviews) AS totalpageviews, sum(totalemailpage) as totalemailpage, sum(totalses) as totalses, sum(totalItemdetailviews + totalassetdlviews + totalitemcomparison + totalprintpages + totalsavefav + totalemailpage) as totalconv ";
     $subq   .= "FROM thomflat_catnav_summmary$yy WHERE tgramsid ='$acct' and isactive='yes' and date='$dd' ";
     if($debug == 1){print "\n$subq;\n";}       
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) 
      {  
      #  $conv += $$srow2[0]; 
      #  $totalpageviewson=$$srow2[0];  
      #  $RequestQuoteon =  $$srow2[1]; 
      }
     $subr2->finish;

   } 
   $sth->finish;
   if($us eq "")           { $us='0';   }
   if($conv eq "")         { $conv='0'; }
   if($links eq "")        { $links='0'; }
   if($profile eq "")      { $profile='0'; }
   if($totaladclicks eq ""){ $totaladclicks='0'; }
   if($newsrelviews eq "") { $newsrelviews='0'; }
   if($newslinks eq "")    { $newslinks='0'; }    
   if($BannerViews eq "")  { $BannerViews='0'; }  
   if($viewsPAI eq "")     { $viewsPAI='0'; }
   if($viewsBAD eq "")     { $viewsBAD='0'; }
   if($linkscad eq "")     { $linkscad='0'; }
   if($totalpageviewson eq "")  { $totalpageviewson='0'; }
   if($RequestQuoteon eq "")    { $RequestQuoteon='0'; }
   if($totalpageviewsoff eq "") { $totalpageviewsoff='0'; }
   if($RequestQuoteoff eq "")   { $RequestQuoteoff='0'; }
   if($cad eq "")               { $cad='0'; }
 
   if($debug2 ne "") {
   print  "$comp\t$acct\n"; 
   print  "us: $us\tconv: $conv\n";   
   print  "links: $links\tprof: $profile\ttotalad: $totaladclicks\n";	
   print  "vid: $video\tdoc: $document\timg: $image\tsoc: $social\tprint: $print\tmap: $map\n";
   print  "newrel: $newsrelviews\tnewslink: $newslinks\n";
   print  "ban :$BannerViews\tviewsPAI: $viewsPAI\tviewsBAD: $viewsBAD\n"; 
   print  "ON cadlinks: $linkscad\ttotpage: $totalpageviewson\treq: $RequestQuoteon\n";
   print  "OFF page: $totalpageviewsoff\treq: $RequestQuoteoff\tcad: $cad\n";
   print  "$type\t$dd\n";
   print "----------------------------\n";
   }
 
   print wf "$comp\t$acct\t"; 
   print wf "$us\t$conv\t";   
   print wf "$links\t$profile\t$totaladclicks\t";	
   print wf "$video\t$document\t$image\t$social\t$print\t$map\t";
   print wf "$newsrelviews\t$newslinks\t";
   print wf "$BannerViews\t$viewsPAI\t$viewsBAD\t"; 
   print wf "$linkscad\t$totalpageviewson\t$RequestQuoteon\t";
   print wf "$totalpageviewsoff\t$RequestQuoteoff\t$cad\t";
   print wf "$type\t$dd\n";
     
   $us=$conv=0;                                     
   $links=$profile=$totaladclicks=0;                
   $video=$document=$image=$social=$print=$map=0;   
   $newsrelviews=$newslinks=0;                      
   $BannerViews=$viewsPAI=$viewsBAD=0;              
   $linkscad=$totalpageviewson=$RequestQuoteon=0;   
   $totalpageviewsoff=$RequestQuoteoff=$cad=0;      

   ######### 1301 ##########
   $dd = 1301;
   $yy = 13;  
   # total sessions
   $query = "select sum(us) as us from thomtnetlogARTU$yy where acct='$acct' and date='$dd' and covflag='t' ";
   if($debug == 1){print "\n$query;\n";}
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {       
     $us = $$row[0];  
    } 
   $sth->finish; 
 
  # total convsrsions
  $query  = "select sum(pv) + sum(ln) + sum(cl) + sum(cv) + sum(ec) + sum(ca) + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv) + sum(lc) + sum(cd) + sum(pc), ";
  $query .= " sum(ln) as links, ";
  $query .= " sum(pv) as profile, ";
  $query .= "  sum(vv) as video, ";
  $query .= "  sum(dv) as document, ";
  $query .= "  sum(iv) as image, ";
  $query .= "  sum(sm) as social, ";
  $query .= "  sum(pp) as print,  ";
  $query .= "  sum(mv) as map, ";
  $query .= "  sum(lc)+sum(cl) as linkscad, ";
  $query .= "  sum(cd) as cad ";
  $query .= "from thomtnetlogARTU$yy where acct='$acct' and date='$dd' and covflag='t' "; 
   if($debug == 1){print "\n$query;\n";}
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {      
     $conv     = $$row[0];
     $links    =  $$row[1];	
     $profile  =  $$row[2];
     $video    = $$row[3];
     $document = $$row[4];
     $image    = $$row[5];
     $social   = $$row[6];
     $print    = $$row[7];
     $map      = $$row[8];
     $linkscad = $$row[9]; 
     $cad      = $$row[10]; 
   
     # news conv
     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot, ";
     $subq .= "sum(nsv) as newsrelviews, sum(nlw) as newslinks  ";
     $subq .= "from thomnews_conversions$yy where  date='$dd' and acct='$acct' ";
     if($debug == 1){print "\n$subq;\n";}
     my $subr2 = $dbh->prepare($subq); 
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0];  $newsrelviews= $$srow2[1]; $newslinks = $$srow2[2];  }
     $subr2->finish; 

     # banner clicks
     $subq   = "select sum(BannerClicks), sum(BannerViews) from thomnews_ad_cat$yy ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$dd' ";
     if($debug == 1){print "\n$subq;\n";}
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; $totaladclicks = $$srow2[0];  $BannerViews= $$srow2[1];  }
     $subr2->finish;
    
     # pai clicks
     $subq   = "select sum(clicks), sum(views) from thomtnetlogADviewsServer$yy where acct='$acct' and adtype ='pai' and fdate='$dd'  ";
     if($debug == 1){print "\n$subq;\n";}
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; $totaladclicks += $$srow2[0]; $viewsPAI= $$srow2[1];  }
     $subr2->finish;
   
     # bad clicks
     $subq   = "select sum(clicks), sum(views)  from thomtnetlogADviewsServer$yy where acct='$acct' and adtype ='bad' and fdate='$dd'  ";
     if($debug == 1){print "\n$subq;\n";}
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0];  $totaladclicks += $$srow2[0]; $viewsBAD= $$srow2[1];  }
     $subr2->finish;
   
     # off catalog
     $subq  = "SELECT SUM(totalpageviews) AS totalpageviews, sum(totalemailpage) as totalemailpage, sum(totalses) as totalses, sum(totalItemdetailviews + totalassetdlviews + totalitemcomparison + totalprintpages + totalsavefav + totalemailpage) as totalconv ";
     $subq .= "FROM thomcatnav_summmary$yy WHERE tgramsid ='$acct' and isactive='yes' and date='$dd' ";
     if($debug == 1){print "\n$subq;\n";}        
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) 
      {  
       #$conv += $$srow2[0]; 
       $totalpageviewsoff=$$srow2[0]; 
       #$RequestQuoteoff =  $$srow2[1];  
      } 
     $subr2->finish;  
 
     # on catalog 
     $subq   = "SELECT SUM(totalpageviews) AS totalpageviews, sum(totalemailpage) as totalemailpage, sum(totalses) as totalses, sum(totalItemdetailviews + totalassetdlviews + totalitemcomparison + totalprintpages + totalsavefav + totalemailpage) as totalconv ";
     $subq   .= "FROM thomflat_catnav_summmary$yy WHERE tgramsid ='$acct' and isactive='yes' and date='$dd' ";
     if($debug == 1){print "\n$subq;\n";}       
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) 
      {  
       #$conv += $$srow2[0]; 
       #$totalpageviewson=$$srow2[0];  
       #$RequestQuoteon =  $$srow2[1];
      }
     $subr2->finish;

   } 
   $sth->finish;
   if($us eq "")           { $us='0';   }
   if($conv eq "")         { $conv='0'; }
   if($links eq "")        { $links='0'; }
   if($profile eq "")      { $profile='0'; }
   if($totaladclicks eq ""){ $totaladclicks='0'; }
   if($newsrelviews eq "") { $newsrelviews='0'; }
   if($newslinks eq "")    { $newslinks='0'; }    
   if($BannerViews eq "")  { $BannerViews='0'; }  
   if($viewsPAI eq "")     { $viewsPAI='0'; }
   if($viewsBAD eq "")     { $viewsBAD='0'; }
   if($linkscad eq "")     { $linkscad='0'; }
   if($totalpageviewson eq "")  { $totalpageviewson='0'; }
   if($RequestQuoteon eq "")    { $RequestQuoteon='0'; }
   if($totalpageviewsoff eq "") { $totalpageviewsoff='0'; }
   if($RequestQuoteoff eq "")   { $RequestQuoteoff='0'; }
   if($cad eq "")               { $cad='0'; }
 
   if($debug2 ne "") {
   print  "$comp\t$acct\n"; 
   print  "us: $us\tconv: $conv\n";   
   print  "links: $links\tprof: $profile\ttotalad: $totaladclicks\n";	
   print  "vid: $video\tdoc: $document\timg: $image\tsoc: $social\tprint: $print\tmap: $map\n";
   print  "newrel: $newsrelviews\tnewslink: $newslinks\n";
   print  "ban :$BannerViews\tviewsPAI: $viewsPAI\tviewsBAD: $viewsBAD\n"; 
   print  "ON cadlinks: $linkscad\ttotpage: $totalpageviewson\treq: $RequestQuoteon\n";
   print  "OFF page: $totalpageviewsoff\treq: $RequestQuoteoff\tcad: $cad\n";
   print  "$type\t$dd\n";
   print "----------------------------\n";
   }
 
   print wf "$comp\t$acct\t"; 
   print wf "$us\t$conv\t";   
   print wf "$links\t$profile\t$totaladclicks\t";	
   print wf "$video\t$document\t$image\t$social\t$print\t$map\t";
   print wf "$newsrelviews\t$newslinks\t";
   print wf "$BannerViews\t$viewsPAI\t$viewsBAD\t"; 
   print wf "$linkscad\t$totalpageviewson\t$RequestQuoteon\t";
   print wf "$totalpageviewsoff\t$RequestQuoteoff\t$cad\t";
   print wf "$type\t$dd\n";
     
   $us=$conv=0;                                     
   $links=$profile=$totaladclicks=0;                
   $video=$document=$image=$social=$print=$map=0;   
   $newsrelviews=$newslinks=0;                      
   $BannerViews=$viewsPAI=$viewsBAD=0;              
   $linkscad=$totalpageviewson=$RequestQuoteon=0;   
   $totalpageviewsoff=$RequestQuoteoff=$cad=0;      




   ######### 1302 ##########
   $dd = 1302;
   $yy = 13;  
   # total sessions
   $query = "select sum(us) as us from thomtnetlogARTU$yy where acct='$acct' and date='$dd' and covflag='t' ";
   if($debug == 1){print "\n$query;\n";}
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {       
     $us = $$row[0];  
    } 
   $sth->finish; 
 
  # total convsrsions
  $query  = "select sum(pv) + sum(ln) + sum(cl) + sum(cv) + sum(ec) + sum(ca) + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv) + sum(lc) + sum(cd) + sum(pc), ";
  $query .= " sum(ln) as links, ";
  $query .= " sum(pv) as profile, ";
  $query .= "  sum(vv) as video, ";
  $query .= "  sum(dv) as document, ";
  $query .= "  sum(iv) as image, ";
  $query .= "  sum(sm) as social, ";
  $query .= "  sum(pp) as print,  ";
  $query .= "  sum(mv) as map, ";
  $query .= "  sum(lc)+sum(cl) as linkscad, ";
  $query .= "  sum(cd) as cad ";
  $query .= "from thomtnetlogARTU$yy where acct='$acct' and date='$dd' and covflag='t' "; 
   if($debug == 1){print "\n$query;\n";}
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {      
     $conv     = $$row[0];
     $links    =  $$row[1];	
     $profile  =  $$row[2];
     $video    = $$row[3];
     $document = $$row[4];
     $image    = $$row[5];
     $social   = $$row[6];
     $print    = $$row[7];
     $map      = $$row[8];
     $linkscad = $$row[9]; 
     $cad      = $$row[10]; 
   
     # news conv
     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot, ";
     $subq .= "sum(nsv) as newsrelviews, sum(nlw) as newslinks  ";
     $subq .= "from thomnews_conversions$yy where  date='$dd' and acct='$acct' ";
     if($debug == 1){print "\n$subq;\n";}
     my $subr2 = $dbh->prepare($subq); 
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0];  $newsrelviews= $$srow2[1]; $newslinks = $$srow2[2];  }
     $subr2->finish; 

     # banner clicks
     $subq   = "select sum(BannerClicks), sum(BannerViews) from thomnews_ad_cat$yy ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$dd' ";
     if($debug == 1){print "\n$subq;\n";}
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; $totaladclicks = $$srow2[0];  $BannerViews= $$srow2[1];  }
     $subr2->finish;
    
     # pai clicks
     $subq   = "select sum(clicks), sum(views) from thomtnetlogADviewsServer$yy where acct='$acct' and adtype ='pai' and fdate='$dd'  ";
     if($debug == 1){print "\n$subq;\n";}
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; $totaladclicks += $$srow2[0]; $viewsPAI= $$srow2[1];  }
     $subr2->finish;
   
     # bad clicks
     $subq   = "select sum(clicks), sum(views)  from thomtnetlogADviewsServer$yy where acct='$acct' and adtype ='bad' and fdate='$dd'  ";
     if($debug == 1){print "\n$subq;\n";}
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0];  $totaladclicks += $$srow2[0]; $viewsBAD= $$srow2[1];  }
     $subr2->finish;
   
     # off catalog 
     $subq  = "SELECT SUM(totalpageviews) AS totalpageviews, sum(totalemailpage) as totalemailpage, sum(totalses) as totalses, sum(totalItemdetailviews + totalassetdlviews + totalitemcomparison + totalprintpages + totalsavefav + totalemailpage) as totalconv ";
     $subq .= "FROM thomcatnav_summmary$yy WHERE tgramsid ='$acct' and isactive='yes' and date='$dd' ";
     if($debug == 1){print "\n$subq;\n";}        
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) 
       {  
         #$conv += $$srow2[0]; 
         $totalpageviewsoff=$$srow2[0]; 
         #$RequestQuoteoff =  $$srow2[1];
       }
     $subr2->finish;  
 
     # on catalog
     $subq   = "SELECT SUM(totalpageviews) AS totalpageviews, sum(totalemailpage) as totalemailpage, sum(totalses) as totalses, sum(totalItemdetailviews + totalassetdlviews + totalitemcomparison + totalprintpages + totalsavefav + totalemailpage) as totalconv ";
     $subq   .= "FROM thomflat_catnav_summmary$yy WHERE tgramsid ='$acct' and isactive='yes' and date='$dd' ";
     if($debug == 1){print "\n$subq;\n";}       
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) 
      {  
        #$conv += $$srow2[0]; 
        #$totalpageviewson=$$srow2[0];  
        #$RequestQuoteon =  $$srow2[1];
      }
     $subr2->finish;

   } 
   $sth->finish;
   if($us eq "")           { $us='0';   }
   if($conv eq "")         { $conv='0'; }
   if($links eq "")        { $links='0'; }
   if($profile eq "")      { $profile='0'; }
   if($totaladclicks eq ""){ $totaladclicks='0'; }
   if($newsrelviews eq "") { $newsrelviews='0'; }
   if($newslinks eq "")    { $newslinks='0'; }    
   if($BannerViews eq "")  { $BannerViews='0'; }  
   if($viewsPAI eq "")     { $viewsPAI='0'; }
   if($viewsBAD eq "")     { $viewsBAD='0'; }
   if($linkscad eq "")     { $linkscad='0'; }
   if($totalpageviewson eq "")  { $totalpageviewson='0'; }
   if($RequestQuoteon eq "")    { $RequestQuoteon='0'; }
   if($totalpageviewsoff eq "") { $totalpageviewsoff='0'; }
   if($RequestQuoteoff eq "")   { $RequestQuoteoff='0'; }
   if($cad eq "")               { $cad='0'; }
 
   if($debug2 ne "") {
   print  "$comp\t$acct\n"; 
   print  "us: $us\tconv: $conv\n";   
   print  "links: $links\tprof: $profile\ttotalad: $totaladclicks\n";	
   print  "vid: $video\tdoc: $document\timg: $image\tsoc: $social\tprint: $print\tmap: $map\n";
   print  "newrel: $newsrelviews\tnewslink: $newslinks\n";
   print  "ban :$BannerViews\tviewsPAI: $viewsPAI\tviewsBAD: $viewsBAD\n"; 
   print  "ON cadlinks: $linkscad\ttotpage: $totalpageviewson\treq: $RequestQuoteon\n";
   print  "OFF page: $totalpageviewsoff\treq: $RequestQuoteoff\tcad: $cad\n";
   print  "$type\t$dd\n";
   print "----------------------------\n";
   }
 
   print wf "$comp\t$acct\t"; 
   print wf "$us\t$conv\t";   
   print wf "$links\t$profile\t$totaladclicks\t";	
   print wf "$video\t$document\t$image\t$social\t$print\t$map\t";
   print wf "$newsrelviews\t$newslinks\t";
   print wf "$BannerViews\t$viewsPAI\t$viewsBAD\t"; 
   print wf "$linkscad\t$totalpageviewson\t$RequestQuoteon\t";
   print wf "$totalpageviewsoff\t$RequestQuoteoff\t$cad\t";
   print wf "$type\t$dd\n";
     
 
   $us=$conv=0;                                     
   $links=$profile=$totaladclicks=0;                
   $video=$document=$image=$social=$print=$map=0;   
   $newsrelviews=$newslinks=0;                      
   $BannerViews=$viewsPAI=$viewsBAD=0;              
   $linkscad=$totalpageviewson=$RequestQuoteon=0;   
   $totalpageviewsoff=$RequestQuoteoff=$cad=0;      


   ######### 1303 ##########
   $dd = 1303;
   $yy = 13;  
   # total sessions
   $query = "select sum(us) as us from thomtnetlogARTU$yy where acct='$acct' and date='$dd' and covflag='t' ";
   if($debug == 1){print "\n$query;\n";}
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {       
     $us = $$row[0];  
    } 
   $sth->finish; 
  
  # total convsrsions
  #$query  = "select sum(pv) + sum(ln) + sum(cl) + sum(cv) + sum(ec) + sum(ca) + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv) + sum(lc) + sum(cd) + sum(pc), ";
  $query  = "select sum(pv) + sum(ln) + sum(cl) + sum(cv) + sum(ec) + sum(ca) + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv) + sum(lc) + sum(cd), ";
  $query .= " sum(ln) as links, ";
  $query .= " sum(pv) as profile, ";
  $query .= "  sum(vv) as video, ";
  $query .= "  sum(dv) as document, ";
  $query .= "  sum(iv) as image, ";
  $query .= "  sum(sm) as social, ";
  $query .= "  sum(pp) as print,  ";
  $query .= "  sum(mv) as map, ";
  $query .= "  sum(lc)+sum(cl) as linkscad, ";
  $query .= "  sum(cd) as cad ";
  $query .= "from thomtnetlogARTU$yy where acct='$acct' and date='$dd' and covflag='t' "; 
   if($debug == 1){print "\n$query;\n";}
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {      
     $conv     = $$row[0];
     $links    =  $$row[1];	
     $profile  =  $$row[2];
     $video    = $$row[3];
     $document = $$row[4];
     $image    = $$row[5];
     $social   = $$row[6];
     $print    = $$row[7];
     $map      = $$row[8];
     $linkscad = $$row[9]; 
     $cad      = $$row[10]; 
   
     # news conv
     $subq  = "select sum(nsv) + sum(ncc) + sum(nes) +  sum(nlw) as tot, ";
     $subq .= "sum(nsv) as newsrelviews, sum(nlw) as newslinks  ";
     $subq .= "from thomnews_conversions$yy where  date='$dd' and acct='$acct' ";
     if($debug == 1){print "\n$subq;\n";}
     my $subr2 = $dbh->prepare($subq); 
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) { $conv += $$srow2[0];  $newsrelviews= $$srow2[1]; $newslinks = $$srow2[2];  }
     $subr2->finish; 

     # banner clicks
     $subq   = "select sum(BannerClicks), sum(BannerViews) from thomnews_ad_cat$yy ";
     $subq  .= "where AdvertiserCid = '$acct' and date='$dd' ";
     if($debug == 1){print "\n$subq;\n";}
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; $totaladclicks = $$srow2[0];  $BannerViews= $$srow2[1];  }
     $subr2->finish;
    
     # pai clicks
     $subq   = "select sum(clicks), sum(views) from thomtnetlogADviewsServer$yy where acct='$acct' and adtype ='pai' and fdate='$dd'  ";
     if($debug == 1){print "\n$subq;\n";}
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; $totaladclicks += $$srow2[0]; $viewsPAI= $$srow2[1];  }
     $subr2->finish;
   
     # bad clicks
     $subq   = "select sum(clicks), sum(views)  from thomtnetlogADviewsServer$yy where acct='$acct' and adtype ='bad' and fdate='$dd'  ";
     if($debug == 1){print "\n$subq;\n";}
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0];  $totaladclicks += $$srow2[0]; $viewsBAD= $$srow2[1];  }
     $subr2->finish;
   
     # off catalog
     $subq  = "SELECT SUM(totalpageviews) AS totalpageviews, sum(totalemailpage) as totalemailpage, sum(totalses) as totalses, sum(totalItemdetailviews + totalassetdlviews + totalitemcomparison + totalprintpages + totalsavefav + totalemailpage) as totalconv ";
     $subq .= "FROM thomcatnav_summmary$yy WHERE tgramsid ='$acct' and isactive='yes' and date='$dd' ";
     if($debug == 1){print "\n$subq;\n";}        
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0]; $conv += $$srow2[1];  $totalpageviewsoff=$$srow2[0]; $RequestQuoteoff =  $$srow2[1]; }
     $subr2->finish;  
 
     # on catalog (only use one here)
     $subq   = "SELECT SUM(totalpageviews) AS totalpageviews, sum(totalemailpage) as totalemailpage, sum(totalses) as totalses, sum(totalItemdetailviews + totalassetdlviews + totalitemcomparison + totalprintpages + totalsavefav + totalemailpage) as totalconv ";
     $subq   .= "FROM thomflat_catnav_summmary$yy WHERE tgramsid ='$acct' and isactive='yes' and date='$dd' ";
     if($debug == 1){print "\n$subq;\n";}        
     my $subr2 = $dbh->prepare($subq);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; } 
     if (my $srow2 = $subr2->fetchrow_arrayref) {  $conv += $$srow2[0];  $conv += $$srow2[1];  $totalpageviewson=$$srow2[0];  $RequestQuoteon =  $$srow2[1]; }
     $subr2->finish;

   } 
   $sth->finish;
   if($us eq "")           { $us='0';   }
   if($conv eq "")         { $conv='0'; }
   if($links eq "")        { $links='0'; }
   if($profile eq "")      { $profile='0'; }
   if($totaladclicks eq ""){ $totaladclicks='0'; }
   if($newsrelviews eq "") { $newsrelviews='0'; }
   if($newslinks eq "")    { $newslinks='0'; }    
   if($BannerViews eq "")  { $BannerViews='0'; }  
   if($viewsPAI eq "")     { $viewsPAI='0'; }
   if($viewsBAD eq "")     { $viewsBAD='0'; }
   if($linkscad eq "")     { $linkscad='0'; }
   if($totalpageviewson eq "")  { $totalpageviewson='0'; }
   if($RequestQuoteon eq "")    { $RequestQuoteon='0'; }
   if($totalpageviewsoff eq "") { $totalpageviewsoff='0'; }
   if($RequestQuoteoff eq "")   { $RequestQuoteoff='0'; }
   if($cad eq "")               { $cad='0'; }
 
   if($debug2 ne "") {
   print  "$comp\t$acct\n"; 
   print  "us: $us\tconv: $conv\n";   
   print  "links: $links\tprof: $profile\ttotalad: $totaladclicks\n";	
   print  "vid: $video\tdoc: $document\timg: $image\tsoc: $social\tprint: $print\tmap: $map\n";
   print  "newrel: $newsrelviews\tnewslink: $newslinks\n";
   print  "ban :$BannerViews\tviewsPAI: $viewsPAI\tviewsBAD: $viewsBAD\n"; 
   print  "ON cadlinks: $linkscad\ttotpage: $totalpageviewson\treq: $RequestQuoteon\n";
   print  "OFF page: $totalpageviewsoff\treq: $RequestQuoteoff\tcad: $cad\n";
   print  "$type\t$dd\n";
   print "----------------------------\n";
   }
  
   print wf "$comp\t$acct\t"; 
   print wf "$us\t$conv\t";   
   print wf "$links\t$profile\t$totaladclicks\t";	
   print wf "$video\t$document\t$image\t$social\t$print\t$map\t";
   print wf "$newsrelviews\t$newslinks\t";
   print wf "$BannerViews\t$viewsPAI\t$viewsBAD\t"; 
   print wf "$linkscad\t$totalpageviewson\t$RequestQuoteon\t";
   print wf "$totalpageviewsoff\t$RequestQuoteoff\t$cad\t";
   print wf "$type\t$dd\n";
     

   $us=$conv=0;                                     
   $links=$profile=$totaladclicks=0;                
   $video=$document=$image=$social=$print=$map=0;   
   $newsrelviews=$newslinks=0;                      
   $BannerViews=$viewsPAI=$viewsBAD=0;              
   $linkscad=$totalpageviewson=$RequestQuoteon=0;   
   $totalpageviewsoff=$RequestQuoteoff=$cad=0;      



  $z++;
}

close(wf);

$dbh->disconnect;

system("mysqlimport -i thomas $outfile");

print "\n\nDone...\n\n";
