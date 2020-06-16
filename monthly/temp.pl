#!/usr/bin/perl
#           
# run as ./get-cad-new.pl start{mm/dd/yyyy} end{mm/dd/yyyy} 
# nohup ./get-cad-new-2014.pl 06/01/2014 06/30/2014 &
# get records now with individual company pulls
 
  
# WebTrand CatalogNavigator 
# -------------------------
# tinid    UserCookie
# ip       UserIP
# ht       EventDateTime
# hd       EventDateTime
# v        -
# pp       Breadcrumb
# pd       PartName
# cid      CID (need conversion)
# f        CADType
# pn       PartNumber
# act      Action
   
use Time::Local;
#use Switch;

## Get CAD CID's need to match these to tnet acct numbers
$proc  = "advCADActive";
$infile  = "reports/$proc";       
$BASEURL = "MainAPI/Service.asmx/CompanyGetListEx?cIDs=&showFields=[TGRAMSID]&isActiveCustomerOnly=1";
$BASEURL = "MainAPI/Service.asmx/CompanyGetListEx?cIDs=&showFields=[TGRAMSID]&isActiveCustomerOnly=";
$BASEURL = "http:///MainAPI/Service.asmx/CompanyGetListEx?cIDs=&showFields=[TGRAMSID]&isActiveCustomerOnly=";
$BASEURL = "http:///MainAPI/Service.asmx/CompanyGetListEx?cIDs=&showFields=[isFCI],[TGRAMSID]&isActiveCustomerOnly=";

   
$timeout = " --timeout=14400 --tries=1  "; 
$cmd     = "wget $user $timeout \"$BASEURL\" -O reports/$proc";

print "$cmd\n";
 


# now get data  
#$proc  = "advCADActionDetail";
$proc  = "advCADActionDetail-new";
$start = $ARGV[0]; 
$end   = $ARGV[1]; 
  
($Smonth, $Sday, $Syear) = split(/\//, $start);
($Emonth, $Eday, $Eyear) = split(/\//, $end);

if($Syear < 100) { $Syear = $Syear + 2000; }
if($Eyear < 100) { $Eyear = $Eyear + 2000; }
$fdate = substr($Syear, 2, 2) . sprintf('%02d', $Smonth);
 
$infile  = "reports/$proc"; 
$outfile = "reports/$proc-$fdate.txt"; 

$BASEURL = "MainAPI/AuditService.asmx/GetCADActivity";
$BASEURL = "http:///MainAPI/AuditService.asmx/GetCADActivity";
$params = "cIDs=$allcids"; 
$params .= "&dateBegin=$Smonth/$Sday/$Syear";
$params .= "&dateEnd=$Emonth/$Eday/$Eyear"; 
$params .= "&sessionIDs=";

#$user    = "--http-user=wtuser --http-passwd=";   
$timeout = " --timeout=14400 --tries=1  ";
$cmd     = "wget $user $timeout \"$BASEURL?$params\" -O  reports/$proc"; 
print "\n$cmd\n"; exit;
system("$cmd");
 
# now parse infile data       
$i=0;
open(INFILE ,"$infile") || die "not found";
open(OUTFILE,">$outfile") || "Error...";
 
#Header  
$str  = "fdate";
$str .= "\tcid";
$str .= "\tip";   
$str .= "\thddate";
$str .= "\thtime";   
$str .= "\taction";
$str .= "\tpart number";   
$str .= "\tpart name";
$str .= "\tpart desc";
$str .= "\tf";
$str .= "\ttinid\n";

print OUTFILE "$str\n";

while (!eof(INFILE)  ) {
   
  $line = <INFILE>;
  if(!$line =~ /<Audit /) { next; }
  #if($line =~ /dbi:null-columns/) { next; } # null tinid values 
  
  $cid = $ip = $act = $pn = $pd = $pp = $tinid = $f =  $cm  = $cd = $cy = "";    
 
  # cad
    if ($line =~ / CID=\"([^\"]+)\"/)       
    { 
      $cidorg = $1; 
      $cid = $tnetmatch{$cidorg};
    } 
    if ($line =~ / UserIP=\"([^\"]+)\"/)    { $ip = $1;  }
    if ($line =~ / EventDateTime=\"([^\"]+)\"/)        
      { 
       $cy = substr($1,  0, 4);       
       $cm = substr($1,  5, 2);             
       $cd = substr($1,  8, 2);       
       $hd = $cm . "/" . $cd . "/" . $cy;
       $ht = substr($1, 11, 8);
      } 
    if ($line =~ / Action=\"([^\"]+)\"/)    { $act = $1; }
    if ($line =~ / PartNumber=\"([^\"]+)\"/){ $pn = $1;  }
    if ($line =~ / PartName=\"([^\"]+)\"/)  { $pd = $1;  }
    if ($line =~ / Breadcrumb=\"([^\"]+)\"/){ $pp = $1;  } 
    if ($line =~ / UserCookie=\"([^\"]+)\'/){ $tinid = $1; } 
    if ($line =~ / CADType=\"([^\"]+)\"/)   { $f = $1; }
            
 ## Now build record - order always important 

  # cad  
  # $date, $acct, $ipaddress, $action_date, $action_time, $action, $partnum, $partname, $partdes, $tinid, $format
 
 
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

  
  if($cid) 
   { 
     print OUTFILE "$str\n";  $i++; 
   }
  else 
   {
     $z++; 
     if($cidorg){$badcid{$cidorg}=$cidorg;} 
   } 
}

close(INFILE);
close(OUTFILE);


foreach $k (keys(%badcid)) 
{ 
        print $k, ": ", $badcid{$k}, "\n"; 
} 

 

print "\nTotal records $z found $i\n";
print "\nDone...\n";
