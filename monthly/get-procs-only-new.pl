#!/usr/bin/perl
#
# PROCESS BUT NO PULL   ./get-procs-only-new.pl  proc date
#
# $1=proc $2=dset $3=group $4=national ${FROM} ${TO} ${SITE}

use DBI;
require "/usr/wt/trd-reload.ph";

use Time::Local;
#use Switch;
use utf8;


$proc     = $ARGV[0];
$fdate    = $ARGV[1];
if($proc eq "" || $fdate eq "") { print "\n\nMissing proc and/or date var!\n\n"; exit; }


$infile  = "reports/$proc-$fdate.xml";
$outfile = "reports/$proc-$fdate.txt";
print "$infile\t$outfile\n";



$i=0;
open(INFILE ,"$infile") || die "$infile not found";
open(OUTFILE,">$outfile") || "Error...";
open(OUTFILE2,">ERROR.txt") || "Error...";

if( $proc =~ /Drill/ )  { $orgproc=1; }

  
while (!eof(INFILE)  ) {
     
  $line = <INFILE>;
  #print "$line\n\n";   
 
  utf8::encode($line);
  if(!$line =~ /<row /) { next; }
  #if( $line =~ /[^\x00-\x7e]/  && $proc =~ /CatFlatSearchEngRefKeyword/ )  { next; } 
  #if($line =~ /dbi:null-columns/) { next; } # null tinid values
  if($line =~ /error/ || $line =~ /ERROR/ || $line =~ /Error/ ) {  print OUTFILE2 "$proc|$line\n";  } # 
  #$line =~ s/pid/prid/;   
  


  $v = $cid = $cov = $tinid = $hdg = $freq = "";
  $ht = $hd = $d = $act = $ip = $isp = $e = $i = $t = $f = $pn = $pd = $pp = $se ="";    
  $cg = $cs = $alink = ""; 
  $org = $dom = $prid= $pid = $SearchEngineName = "";
  $city = $state = $zip = $zipcode = $region = $domain_name = $ip_address = "";
  $Heading = $naics = $clicks = $conv = $prod = $offer = "";
  $hits = $convs = $rfi = $PrdS_PROD_ID = $PrdS_ITEM_Name = $PrdS_ITEM_ID =  $keyword = "";
  $conversions = $convertedvisits = $visits = $visitors = $pgspervisit = $avgminutes = $printcat = $adov = $frequency = $rfq = $CADDownloads  =  $pv = "";
  $avgpagespersession = $avgviewtime = "";
  $naics = $country = $primary_sic = $countrycode ="";
  $duns_number = $DomesticHQDunsNumber = $HQDunsNumber = $GLTDunsNumber = $CountryCode = $Country = $Audience = $AudienceSegment = $b2b = "";
  $employee_range = $forbes2k = $fortune1k = $industry = $InformationLevel = $latitude = $longitude = $phone = $revenue_range = $subindustry = $reg ="";    
 
  # value     
  if ($line =~ / v=\'([^\']+)\'/) { $v = $1; }
  if ($line =~ / sum\(v\)=\'([^\']+)\'/) { $v = $1;  }
  #if ($line =~ / clicks=\'([^\']+)\'/) { $clicks = $1; }    
  if ($line =~ / conv=\'([^\']+)\'/) { $conv = $1; }        

  if ($line =~ / hits=\'([^\']+)\'/)  { $hits = $1; }    
  if ($line =~ / convs=\'([^\']+)\'/) { $convs = $1; }    
  if ($line =~ / rfi=\'([^\']+)\'/)   { $rfi = $1; }    
 
  if ($line =~ / freq=\'([^\']+)\'/)   { $freq = $1; }    
 
  if ($line =~ / conversions=\'([^\']+)\'/) { $conversions = $1; }    
  if ($line =~ / convertedvisits=\'([^\']+)\'/) { $convertedvisits = $1; }    
  if ($line =~ / visits=\'([^\']+)\'/) { $visits = $1; }
  if ($line =~ / visitors=\'([^\']+)\'/) { $visitors = $1; } 
  if ($line =~ / pgspervisit=\'([^\']+)\'/) { $pgspervisit = $1; } 
  if ($line =~ / avgminutes=\'([^\']+)\'/) { $avgminutes = $1; } 
  if ($line =~ / printcat=\'([^\']+)\'/) { $printcat = $1; } 
  if ($line =~ / adov=\'([^\']+)\'/) { $adov = $1; } 
  if ($line =~ / frequency=\'([^\']+)\'/)   { $frequency = $1; }           
  if ($line =~ / rfq=\'([^\']+)\'/)   { $rfq = $1; }  
  if ($line =~ / CADDownloads=\'([^\']+)\'/)   { $CADDownloads = $1; }  
  if ($line =~ / pv=\'([^\']+)\'/)   { $pv = $1; }     
  if ($line =~ / avgpagespersession=\'([^\']+)\'/)   { $avgpagespersession = $1; }     
  if ($line =~ / avgviewtime=\'([^\']+)\'/)   { $avgviewtime = $1; }       

  # account no
  if ($line =~ / cid=\'([^\']+)\'/) { $cid = $1; }

  # coverage
  if ($line =~ / cov=\'([^\']+)\'/) { $cov = $1; }
                     
  # tinid & cleanup  
   if ($line =~ / reg=\'([^\']+)\'/) { $tinid = $1;  }
   $line =~ s/trid=\"trguest\"//;
   $line =~ s/trid=\"thezsrch\"//;
   $line =~ s/trid=\"thtrguest\"//;
   if( $proc =~ /Drill/  || $proc =~ /CatFlat/ )  { $tinid=""; } 
 
  # heading    
  if ($line =~ / hdg=\'([^\']+)\'/) { $hdg = $1;  } 
  if ($line =~ / Heading=\'([^\']+)\'/) { $hdg = $1;  } 
 
  # web links     
  if ($line =~ / cg=\'([^\']+)\'/) { $cg = $1;  }       # link type
  if ($line =~ / cs=\'([^\']+)\'/) { $cs = $1;  }       # link id
  if ($line =~ / alink=\'([^\']+)\'/) { $alink = $1;  } # link 
    
  # organization  
  #if ($line =~ / org=\'([^\']+)\'/) { $org = $1;                   if($org eq "")  { $org = "-";} }
  #if ($line =~ / dom=\'([^\']+)\'/) { $dom = $1;                   if($dom eq "")  { $dom="No Value Found";} }
  #if ($line =~ / domain_name=\'([^\']+)\'/) { $domain_name = $1;  }
  #if ($line =~ / city=\'([^\']+)\'/)  { $city = $1;                if($city eq "")  { $city="-";}   }
  #if ($line =~ / state=\'([^\']+)\'/) { $state = $1;               if($state eq "") { $state="-"; }  }
  #if ($line =~ / region=\'([^\']+)\'/) { $region = $1; } 
  #if ($line =~ / zip=\'([^\']+)\'/)   { $zip = $1;                 if($zip eq "")   { $zip="-"; } }
  #if ($line =~ / zipcode=\'([^\']+)\'/)   { $zipcode = $1;  }
  #if ($naics=~ / naics=\'([^\']+)\'/)   { $naics = $1;   } # forget this
  #if ($line =~ / ISP=\'([^\']+)\'/)   { $isp = $1;                 if($isp eq "")   { $isp="ISP"; }  }
  # due to demand base      
  if ($line =~ / org=\'\'/         || $line =~ / org=\'([^\']+)\'/)         { $org = $1;         $org = &CleanForeign($org);  if($org eq "")  { $org = "-";}   }
  if ($line =~ / dom=\'\'/         || $line =~ / dom=\'([^\']+)\'/)         { $dom = $1;         if($dom eq "")         { $dom="No Value Found"; } }
  if ($line =~ / domain_name=\'\'/ || $line =~ / domain_name=\'([^\']+)\'/) { $domain_name = $1; if($domain_name eq "") { $domain_name="-"; } }
  if ($line =~ / city=\'\'/        || $line =~ / city=\'([^\']+)\'/)        { $city = $1;        $city   = &CleanForeign($city);      if($city eq "")        { $city="-";    } }
  if ($line =~ / state=\'\'/       || $line =~ / state=\'([^\']+)\'/)       { $state = $1;       $state  = &CleanForeign($state);      if($state eq "")       { $state="-";   } }
  if ($line =~ / region=\'\'/      || $line =~ / region=\'([^\']+)\'/)      { $region = $1;      $region = &CleanForeign($region);     if($region eq "")      { $region="-";  } }
  if ($line =~ / zip=\'\'/         || $line =~ / zip=\'([^\']+)\'/)         { $zip = $1;         $zip    = &CleanForeign($zip);  if($zip eq "")         { $zip="-";     } }
  if ($line =~ / zipcode=\'\'/     || $line =~ / zipcode=\'([^\']+)\'/)     { $zipcode = $1;     $zipcode= &CleanForeign($zipcode);  if($zipcode eq "")     { $zipcode="-"; } }
  if ($line =~ / ISP=\'\'/         || $line =~ / ISP=\'([^\']+)\'/)         { $isp = $1;         if($isp eq "")         { $isp="ISP";   } }
  if ($line =~ / ip=\'\'/          || $line =~ / ip=\'([^\']+)\'/)          { $ip = $1;          if($ip eq "")          { $ip="-";   } }
  if ($line =~ / ip_address=\'\'/  || $line =~ / ip_address=\'([^\']+)\'/)   { $ip = $1;          if($ip eq "")          { $ip="-";   } }
  if($line =~ / naics=\'\'/ || $line =~ / naics=\'([^\']+)\'/)
    { $naics = $1; $naics= &CleanForeign($naics); if($naics eq "") { $naics="-"; } }
  if($line =~ / Country=\'\'/ || $line =~ / Country=\'([^\']+)\'/)
    { $country = $1; $country= &CleanForeign($country); if($country eq "" || country eq "No Country" ) { $country="-"; } }
  if($line =~ / primary_sic=\'\'/ || $line =~ / primary_sic=\'([^\']+)\'/)
    { $primary_sic = $1; $primary_sic= &CleanForeign($primary_sic); if($primary_sic eq "") { $primary_sic="-"; } }
  if($line =~ / CountryCode=\'\'/ || $line =~ / CountryCode=\'([^\']+)\'/)
    { $countrycode = $1; $countrycode= &CleanForeign($countrycode); if($countrycode eq "") { $countrycode="-"; } }  
   
  if ($line =~ / duns_number=\'\'/           || $line =~ / duns_number=\'([^\']+)\'/)          { $duns_number         = $1; if($duns_number           eq "" ) { $duns_number          = "0"; } }
  if ($line =~ / DomesticHQDunsNumber=\'\'/  || $line =~ / DomesticHQDunsNumber=\'([^\']+)\'/) { $DomesticHQDunsNumber= $1; if($DomesticHQDunsNumber  eq "" ) { $DomesticHQDunsNumber = "0"; } }  
  if ($line =~ / HQDunsNumber=\'\'/          || $line =~ / HQDunsNumber=\'([^\']+)\'/)         { $HQDunsNumber        = $1; if($HQDunsNumber          eq "" ) { $HQDunsNumber         = "0"; } }
  if ($line =~ / GLTDunsNumber=\'\'/         || $line =~ / GLTDunsNumber=\'([^\']+)\'/)        { $GLTDunsNumber       = $1; if($GLTDunsNumber         eq "" ) { $GLTDunsNumber        = "0"; } }
  if ($line =~ / CountryCode=\'\'/           || $line =~ / CountryCode=\'([^\']+)\'/)          { $CountryCode         = $1; if($CountryCode           eq "" ) { $CountryCode          = "-"; } }
  #if ($line =~ / Country=\'\'/               || $line =~ / Country=\'([^\']+)\'/)              { $Country             = $1; if($Country               eq "" ) { $Country              = "-"; } }
  if ($line =~ / Audience=\'\'/              || $line =~ / Audience=\'([^\']+)\'/)             { $Audience            = $1; if($Audience              eq "" ) { $Audience             = "-"; } }
  if ($line =~ / AudienceSegment=\'\'/       || $line =~ / AudienceSegment=\'([^\']+)\'/)      { $AudienceSegment     = $1; if($AudienceSegment       eq "" ) { $AudienceSegment      = "-"; } }
  if ($line =~ / b2b=\'\'/                   || $line =~ / b2b=\'([^\']+)\'/)                  { $b2b                 = $1; if($b2b                   eq "" ) { $b2b                  = "-"; } }
  if ($line =~ / employee_range=\'\'/        || $line =~ / employee_range=\'([^\']+)\'/)       { $employee_range      = $1; if($employee_range        eq "" ) { $employee_range       = "-"; } }
  if ($line =~ / forbes2k=\'\'/              || $line =~ / forbes2k=\'([^\']+)\'/)             { $forbes2k            = $1; if($forbes2k              eq "" ) { $forbes2k             = "-"; } }
  if ($line =~ / fortune1k=\'\'/             || $line =~ / fortune1k=\'([^\']+)\'/)            { $fortune1k           = $1; if($fortune1k             eq "" ) { $fortune1k            = "-"; } }
  if ($line =~ / industry=\'\'/              || $line =~ / industry=\'([^\']+)\'/)             { $industry            = $1; if($industry              eq "" ) { $industry             = "-"; } }
  if ($line =~ / InformationLevel=\'\'/      || $line =~ / InformationLevel=\'([^\']+)\'/)     { $InformationLevel    = $1; if($InformationLevel      eq "" ) { $InformationLevel     = "-"; } }
  if ($line =~ / latitude=\'\'/              || $line =~ / latitude=\'([^\']+)\'/)             { $latitude            = $1; if($latitude              eq "" ) { $latitude             = "0.00000000" } }
  if ($line =~ / longitude=\'\'/             || $line =~ / longitude=\'([^\']+)\'/)            { $longitude           = $1; if($longitude             eq "" ) { $longitude            = "0.00000000" ;} }
  if ($line =~ / phone=\'\'/                 || $line =~ / phone=\'([^\']+)\'/)                { $phone               = $1; if($phone                 eq "" ) { $phone                = "-" ;} }
  if ($line =~ / revenue_range=\'\'/         || $line =~ / revenue_range=\'([^\']+)\'/)        { $revenue_range       = $1; if($revenue_range         eq "" ) { $revenue_range        = "-" ;} }
  if ($line =~ / subindustry=\'\'/           || $line =~ / subindustry=\'([^\']+)\'/)          { $subindustry         = $1; if($subindustry           eq "" ) { $subindustry          = "-"; }  } 
  if ($line =~ / reg=\'\'/                   || $line =~ / reg=\'([^\']+)\'/)          
   { 
     $reg         = $1; 
    # if($reg  eq "" ) { $reg= "-"; $regnct++ ; }  
    # else             { $regct++ ;  } 
   }  
   
 
     
 
  # News 
  if ($line =~ / prid=\'([^\"]+)\'/) { $prid = $1; }   
  if ($line =~ /pid=\'([^\']+)\'/)  { $pid = $1; }   
   
  # PS  
  if ($line =~ / PrdS_PROD_ID=\'([^\']+)\'/)   { $PrdS_PROD_ID  = $1;  }
  if ($line =~ / PrdS_ITEM_Name=\'([^\']+)\'/) { $PrdS_ITEM_Name = $1;  }
  if ($line =~ / PrdS_ITEM_ID=\'([^\']+)\'/)   { $PrdS_ITEM_ID = $1;  }
 
  # cad
  if($proc eq "advCADActionDetail" || $proc eq "advCADActionDetail-old") {
    if ($line =~ / cid=\'([^\']+)\'/)   { $cid = $1; }
    if ($line =~ / ip=\'([^\']+)\'/)    { $ip = $1; }
    if ($line =~ / hd=\'([^\']+)\'/)    { $hd = $1; }
    if ($line =~ / ht=\'([^\']+)\'/)    { $ht = $1; }
    if ($line =~ / act=\'([^\']+)\'/)   { $act = $1; }
    if ($line =~ / pn=\'([^\']+)\'/)    { $pn = $1; }
    if ($line =~ / pd=\'([^\']+)\'/)    { $pd = $1; }
    if ($line =~ / pp=\'([^\']+)\'/)    { $pp = $1; } 
    if ($line =~ / tinid=\'([^\']+)\'/) { $tinid = $1; } 
    if ($line =~ / f=\'([^\']+)\'/)     { $f = $1; }
   }
 
  
  # search engine
  if ($line =~ / SearchEngineName=\'([^\']+)\'/) 
     { 
      $SearchEngineName = $1; 
      $SearchEngineName = &CleanField($SearchEngineName);
     }  
    
 
 # prod used in social media type
 if ($line =~ / prod=\'([^\']+)\'/)    { $prod = $1; } 

 # ad clicks
 if ($line =~ / offer=\'([^\']+)\'/)    { $offer = $1; } 

 # keyword
 if ($line =~ / keyword=\'([^\']+)\'/)    { $keyword = $1; } 

 # company
 if ($line =~ / company=\'([^\']+)\'/)    { $company = $1; } 

 
 ## Now build record - order always important 

  # date
  $str = "$fdate";  

  # search engine
  if($SearchEngineName ne "") { $str .= "\t$SearchEngineName"; }  
 

  
  # account no   
  if($cid ne "") { $str .= "\t$cid"; }

  # org
  if($org ne "") { $str .= "\t$org"; }



  # values
  if($v ne "") { $str .= "\t$v"; }
  #if($clicks ne "") { $str .= "\t$clicks"; } 
  if($conv ne "") { $str .= "\t$conv"; } 
  if($freq ne "") { $str .= "\t$freq"; } 
    
  if($hits ne "")  { $str .= "\t$hits"; } 
  if($convs ne "") { $str .= "\t$convs"; }  
  if($rfi ne "")   { $str .= "\t$rfi"; } 
  
  if($conversions ne "") { $str .= "\t$conversions"; }
  if($convertedvisits ne "") { $str .= "\t$convertedvisits"; }
  if($visits      ne "") { $str .= "\t$visits"; }      
  if($visitors    ne "") { $str .= "\t$visitors"; }    
  if($pgspervisit ne "") { $str .= "\t$pgspervisit"; } 
  if($avgminutes  ne "") { $str .= "\t$avgminutes"; }  
  if($printcat  ne "")   { $str .= "\t$printcat"; }  
  if($adov  ne "")       { $str .= "\t$adov"; }  
  if($frequency ne "") { $str .= "\t$frequency"; }   
  if($rfq ne "") { $str .= "\t$rfq"; }   
  if($CADDownloads ne "") { $str .= "\t$CADDownloads"; }   
  if($pv ne "")   { $str .= "\t$pv"; }   
  if($avgpagespersession ne "")   { $str .= "\t$avgpagespersession"; }   
  if($avgviewtime ne "")   { $str .= "\t$avgviewtime"; }     
 
  # tinid
  if($tinid ne "") { $str .= "\t$tinid"; }

  # heading 
  if($hdg ne "") { $str .= "\t$hdg"; }



  # org
  if($dom ne "")           { $str .= "\t$dom"; }
  if($domain_name ne "")   { $str .= "\t$domain_name"; }
  if($city ne "")          { $str .= "\t$city"; }
  if($region ne "")        { $str .= "\t$region"; }
  if($state ne "")         { $str .= "\t$state"; } 
  if($zip ne "")           { $str .= "\t$zip"; }
  if($zipcode ne "")       { $str .= "\t$zipcode"; }
  if($isp ne "")           { $str .= "\t$isp"; }
  if($ip ne "")            { $str .= "\t$ip"; }
  if($naics ne "")         { $str .= "\t$naics"; }
  if($country ne "")       { $str .= "\t$country"; }
  if($primary_sic ne "")   { $str .= "\t$primary_sic"; }
  if($countrycode ne "")   { $str .= "\t$countrycode"; }
  if($duns_number          ne "")   { $str .= "\t$duns_number";          } 
  if($DomesticHQDunsNumber ne "")   { $str .= "\t$DomesticHQDunsNumber"; } 
  if($HQDunsNumber         ne "")   { $str .= "\t$HQDunsNumber";         } 
  if($GLTDunsNumber        ne "")   { $str .= "\t$GLTDunsNumber";        } 
  if($CountryCode          ne "")   { $str .= "\t$CountryCode";          } 
  if($Country              ne "")   { $str .= "\t$Country";              } 
  if($Audience             ne "")   { $str .= "\t$Audience";             } 
  if($AudienceSegment      ne "")   { $str .= "\t$AudienceSegment";      } 
  if($b2b                  ne "")   { $str .= "\t$b2b";                  } 
  if($employee_range       ne "")   { $str .= "\t$employee_range";       } 
  if($forbes2k             ne "")   { $str .= "\t$forbes2k";             } 
  if($fortune1k            ne "")   { $str .= "\t$fortune1k";            } 
  if($industry             ne "")   { $str .= "\t$industry";             } 
  if($InformationLevel     ne "")   { $str .= "\t$InformationLevel";     } 
  if($latitude             ne "")   { $str .= "\t$latitude";             } 
  if($longitude            ne "")   { $str .= "\t$longitude ";           } 
  if($phone                ne "")   { $str .= "\t$phone";                } 
  if($revenue_range        ne "")   { $str .= "\t$revenue_range";        } 
  if($subindustry          ne "")   { $str .= "\t$subindustry";          } 
  

          
  # coverage
  if($cov ne "") { $cov =~ tr/[a-z]/[A-Z]/;  $str .= "\t$cov"; }

  if($reg                  ne "")   { $str .= "\t$reg";             } 
  


  # extra fld for total
  if($proc =~ /_t/ ) { $str .= "\tt"; } 
   
  # web links
  if($cg ne "") { $str .= "\t$cg"; }
  if($cs ne "") { $str .= "\t$cs"; }
  if($alink ne "") { $str .= "\t$alink"; }

  # news
   if($prid ne "")  { $str .= "\t$prid"; }
   if($pid ne "")   { $str .= "\t$pid"; }
  
  #if($proc ne "advCADActionDetail" && $proc ne "advCADActionDetail-old") { if ($ip ne "")    { $str .= "\t$ip"; }   } 
  
  # PS   
  if($PrdS_PROD_ID ne "")   { $str .= "\t$PrdS_PROD_ID"; }
  if($PrdS_ITEM_Name ne "") { $str .= "\t$PrdS_ITEM_Name"; }
  if($PrdS_ITEM_ID ne "")   { $str .= "\t$PrdS_ITEM_ID"; }
   

 
  # cad  
  # $date, $acct, $ipaddress, $action_date, $action_time, $action, $partnum, $partname, $partdes, $tinid, $format
  if($proc eq "advCADActionDetail" || $proc eq "advCADActionDetail-old") {
    # $str = "$fdate";
    # if ($cid ne "")   { $str .= "\t$cid"; }     
    # if ($ip ne "")    { $str .= "\t$ip"; }      
    # if ($hd ne "")    { $str .= "\t$hd"; }      
    # if ($ht ne "")    { $str .= "\t$ht"; }      
    # if ($act ne "")   { $str .= "\t$act"; }     
    # if ($pn ne "")    { $str .= "\t$pn"; }      
    # if ($pd ne "")    { $str .= "\t$pd"; }      
    # if ($pp ne "")    { $str .= "\t$pp"; }      
    # if ($tinid ne "") { $str .= "\t$tinid"; }   
    # if ($f ne "")     { $str .= "\t$f"; }
    # needed to hard code this so as not to lose var order:
    $str  = "$fdate";
    $str .= "\t$cid";  
    $str .= "\t$ip";   
    $str .= "\t$hd";   
    $str .= "\t$ht";   
    $str .= "\t$act";  
    $str .= "\t$pn";   
    $str .= "\t$pd";   
    $str .= "\t$pp";   
    $str .= "\t$f";
    $str .= "\t$tinid";
   }


 
  #if ($ip ne "")    { $str .= "\t$ip"; } # moved above

  if ($prod ne "")    { $str .= "\t$prod"; }

  if ($offer ne "")    { $str .= "\t$offer"; }
 
  if($keyword ne "")   { $str  .= "\t$keyword"; }

  if($company ne "")   { $str  .= "\t$company"; }

   
  if($v ne "" || $conv || $cid ne "" || $hdg ne "") { print OUTFILE "$str\n";  $i++; }
  #if($reg ne "-" && $reg ne "") {   print OUTFILE "$str\n";  }
 
 #sleep 1
}

close(INFILE);
close(OUTFILE);
 
#system("nice gzip $infile");
 
 
#print "\n\nreg:$regct\nnoreg: $regnct\n\n";
