#!/usr/bin/perl
#
#
# run as  ./load-visitor-tool-new.pl  YYMM 


 
use DBI;
require "/usr/wt/trd-reload.ph";

$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);             
$mm       =  substr($fdate, 2, 2);             
$checked  = "";
 
$i=0;
$outfile = "visitor_tool.txt";
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");

$table = "tnetlogORGSITED" . $yy . "_" . $mm;
$query  = "select org, domain, city, state, zip, md5(CONCAT(org, city, state, zip)), oid, count(*) as n, ";
$query .= "ip, naics, primary_sic, countrycode, country, ";
$query .= "dunsnum,domestichqdunsnumber,hqdunsnumber,gltdunsnumber,countrycode3,audience,audiencesegment,b2b,";
$query .= "employeerange,forbes2k,fortune1k,industry,informationlevel,latitude,longitude,phone,revenuerange,subindustry ";
$query .= "from $table ";
$query .= "where( org>'' && org!='?') and domain!='?' ";
$query .= "and isp='N' and block='N' ";
$query .= "and date='$fdate' group by org order by n desc ";
#$query .= "limit 200000 "; 
#print "\n$query\n";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
   $oclean = &CleanName($$row[0]);
   if($oclean ne ""){ $oclean .= " ."; }     
 
   ($dclean,$dom1,$dom2) = split(/\./, $$row[1]);
   $dclean =~ s/[^A-Za-z0-9]//g;
   if($dclean ne ""){ $dclean .= " ."; }
   
   #org,domain,city,state,zip,ocleanname,dcleanname,orgid,oid,checked,ip,naics,primary_sic,countrycode,country
   #dunsnum,domestichqdunsnumber,hqdunsnumber,gltdunsnumber,countrycode3,audience,audiencesegment,b2b,
   #employeerange,forbes2k,fortune1k,industry,informationlevel,latitude,longitude,phone,revenuerange,subindustry
 
   
               #org0,   domain1,   city2,   state3,    zip4, 
   print wf "$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t";
            #ocleanname, dcleanname  
   print wf "$oclean\t$dclean\t";
            #orgid5   ,oid6,       checked7  
   print wf "$$row[5]\t$$row[6]\t$checked\t";
             #   ip8,  naics9,   primary_sic10, countrycode11, country12 
   print wf "$$row[8]\t$$row[9]\t$$row[10]\t$$row[11]\t$$row[12]\t";
 
   print wf "$$row[13]\t$$row[14]\t$$row[15]\t$$row[16]\t$$row[17]\t$$row[18]\t$$row[19]\t$$row[20]\t";
   print wf "$$row[21]\t$$row[22]\t$$row[23]\t$$row[24]\t$$row[25]\t$$row[26]\t$$row[27]\t$$row[28]\t$$row[29]\t$$row[30]\n";

   $oclean = $dclean = "";
 }
$sth->finish;
system("mysqlimport -rL thomas $DIR/visitor/$outfile");



$i=0; 
$outfile = "visitor_cat_tool.txt";
$table = "tnetlogORGCATD" . $yy . "_" . $mm;
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
   
# this is not really correct it limits to 1 org
$query  = "select heading, org, domain, city, state, zip, md5(CONCAT(heading, org, city, state, zip)), oid , count(*) as n, ";
$query .= "ip, naics, primary_sic, countrycode, country, ";
$query .= "dunsnum,domestichqdunsnumber,hqdunsnumber,gltdunsnumber,countrycode3,audience,audiencesegment,b2b,";
$query .= "employeerange,forbes2k,fortune1k,industry,informationlevel,latitude,longitude,phone,revenuerange,subindustry, cov ";
$query .= "from $table "; 
$query .=" where( org>'' && org!='?') and domain!='?' ";
$query .= "and isp='N' and block='N' ";
$query .= "and heading>0 ";
$query .= "and date='$fdate' group by org, heading order by n desc ";
#$query .= "limit 200000 "; 
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
   $oclean = &CleanName($$row[1]);
   if($oclean ne ""){ $oclean .= " ."; }     
   ($dclean,$dom1,$dom2) = split(/\./, $$row[2]);
   $dclean =~ s/[^A-Za-z0-9]//g;
   if($dclean ne ""){ $dclean .= " ."; }
 
   #heading,org,domain,city,state,zip,ocleanname,dcleanname,orgid,oid,checked,ip,naics,primary_sic,countrycode,country 
   #dunsnum,domestichqdunsnumber,hqdunsnumber,gltdunsnumber,countrycode3,audience,audiencesegment,b2b,
   #employeerange,forbes2k,fortune1k,industry,informationlevel,latitude,longitude,phone,revenuerange,subindustry,cov
 
             # heading0,   org1,    domain2,   city3,    state4,    zip5    
   print wf "$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$$row[5]\t";
             #ocleanname  dcleanname
   print wf "$oclean\t$dclean\t";
              # orgid6,    oid7       8               
   print wf "$$row[10]\t$$row[11]\t$checked\t";
             #   ip9,    naics10,   primary_sic11, countrycode12, country13 
   print wf "$$row[9]\t$$row[10]\t$$row[11]\t$$row[12]\t$$row[13]\t";

   print wf "$$row[14]\t$$row[15]\t$$row[16]\t$$row[17]\t$$row[18]\t$$row[19]\t$$row[20]\t";
   print wf "$$row[21]\t$$row[22]\t$$row[23]\t$$row[24]\t$$row[25]\t$$row[26]\t$$row[27]\t$$row[28]\t$$row[29]\t$$row[30]\t$$row[31]\t$$row[32]\n";
                     
   $oclean = $dclean = "";
 }
$sth->finish;
system("mysqlimport -rL thomas $DIR/visitor/$outfile");

 
$rc = $dbh->disconnect;

print "\nDone...\n";

exit;
 




