#!/usr/bin/perl
#
#
         
use Digest::MD5 qw(md5 md5_hex md5_base64);
require "trd-reload.ph";

$fdate   = $ARGV[0]; 
if($fdate eq "") { print "\n\nForgot to add date yymm\n\n"; exit; }
print "\n$fdate\n\n";

$fyear     = "20" . substr($fdate, 0, 2);
$yy        = substr($fdate, 0, 2);             
$mm        = substr($fdate, 2, 2);
$intable   = "tnetlogREG" . $yy;
$table     = "tnetlogORGREG" . $yy . "W";
$tablefile = "tnetlogORGREG" . $yy . "W.txt";

open(wf, ">$tablefile")  || die (print "Could not open $tablefile\n");

use DBI;
$dbh      = DBI->connect("", "", "");
  
# get country       0    1      2  
$query  = "select iso2,iso3,countryname from thomnetacuitycountry ";
#print "\n\n$query\n\n";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
  $countryname{$$row[0]} = $$row[2]; # countryname from 2 char country
  $country3{$$row[0]}    = $$row[1]; # 3 char countrycode from 2 
 }       
$sth->finish;
 
# get block  
$query  = "SELECT orgblock FROM thomtnetlogORGflagBLOCK   WHERE orgblock>'' ";
#print "\n\n$query\n\n";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $$row[0] =~ s/^\s+//;
  $$row[0] =~ s/\s+$//;
  $$row[0] =~ tr/[A-Z]/[a-z]/; 
  $badorg{$$row[0]} = $$row[0]; 
 }  
$sth->finish;
 
# extra isp flags
$query  = "SELECT trim(org)  FROM thomtnetlogORGflagExtra WHERE org>''  ";
#print "\n\n$query\n\n";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {  
  $$row[0] =~ tr/[A-Z]/[a-z]/; 
  $isporg{$$row[0]} = $$row[0]; 
 }  
$sth->finish;
    
# delete from table     
$query = "DELETE FROM $table WHERE date='$fdate' ";
#print "\n\n$query\n\n";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
 
# pull data           0         1      2          3        4        5            6            7       8        9
$query  = "SELECT m.company, m.city, m.state, m.country, m.zip, m.industry, m.jobfunction, m.phone, count(*), r.acct ";
$query .= "FROM   tgrams.mt_profile_history as m, $intable as r   ";
$query .= "WHERE  m.tinid=r.tinid  AND date='$fdate' ";
$query .= "GROUP  by r.acct, r.tinid  ";  
#print "\n\n$query\n\n";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {  
    $$row[3] =~ tr/[A-Z]/[a-z]/; 
    $org                   = &CleanForeign($$row[0]); 
    $org                   = &CleanOrg($org); 
    $dom                   = ""; 
    $city                  = $$row[1]; 
    $state                 = $$row[2]; 
    $zip                   = $$row[4];
    $ip                    = "";
    $naics                 = "";
    $country               = $countryname{$$row[3]};
    $primary_sic           = "";
    $duns_number           = 0;
    $domestichqdunsnumber  = 0;
    $hqdunsnumber          = 0;
    $gltdunsnumber         = 0;
    $countrycode           = $$row[3];
    $countrycode3          = $country3{$$row[3]};
    $audience              = "";
    $audiencesegment       = "";
    $b2b                   = "";
    $employee_range        = "";
    $forbes2k              = "";
    $fortune1k             = "";
    $industry              = $$row[5];
    $informationlevel      = "basic";
    $latitude              = "0.0000";
    $longitude             = "0.0000";
    $phone                 = $$row[7];
    $revenue_range         = "";
    $subindustry           = "";
    $cov                   = 'NA';
           
    if($isporg{$org}  ne "")     { $isp="Y";  } else { $isp="N";  }     
    if($badorg{$org} ne "")      { $block="Y";} else { $block="N";}
          
    $orgid  = "$fdate$acct$org$dom$countrycode$city$state$zip$cov";                                        
    $orgid  =  md5_hex($orgid); 
    $orgmd5 =  md5_hex($org); 

    $cnt  = $$row[8];
    $acct = $$row[9];
 

    if($city  eq "NULL")    { $city = $state = ""; }
    #if($state eq "NULL")   { $state=""; }
    if( ($$row[1] eq "" || $$row[2] eq "" || $$row[1]==NULL || $$row[2] eq "NU")  && $$row[4] ne "" )
    {
	# primary first 
        $squery  = "SELECT City, State  FROM thomzipcodes WHERE Zipcode='$$row[4]' AND LocationType='PRIMARY' limit 1 ";
        my $ssth = $dbh->prepare($squery);
        if (!$ssth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
        if (my $srow = $ssth->fetchrow_arrayref)
        {  
        $city  =  $$srow[0];
        $state =  $$srow[1];
        }  
        $ssth->finish;

        if($city eq "") { # try for secondary
        $squery  = "SELECT City, State  FROM thomzipcodes WHERE Zipcode='$$row[4]' AND LocationType='ACCEPTABLE' limit 1 ";
        my $ssth = $dbh->prepare($squery);
        if (!$ssth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
        if (my $srow = $ssth->fetchrow_arrayref)
        {   
        $city  =  $$srow[0];
        $state =  $$srow[1];
        }  
        $ssth->finish;
        }

     }
    $city  =~ tr/[A-Z]/[a-z]/;
    $state =~ tr/[A-Z]/[a-z]/;

  
    if($org ne "?"  &&  $org ne ""  &&  $org ne "#NAME?"  &&  $org ne "unknown"  &&  $org ne "-" && $block ne "Y" && $org ne "no company") {   
 	print wf "$fdate\t$acct\t$org\t$dom\t$country\t$city\t$state\t$zip\t$cnt\t$isp\t$block\t$orgid\t$orgmd5\t$ip\t$naics\t$primary_sic\t$countrycode\t$duns_number\t$domestichqdunsnumber\t$hqdunsnumber\t$gltdunsnumber\t$countrycode3\t$audience\t$audiencesegment\t$b2b\t$employee_range\t$forbes2k\t$fortune1k\t$industry\t$informationlevel\t$latitude\t$longitude\t$phone\t$revenue_range\t$subindustry\t$cov\n";        
    }     
 
    $acct = $org = $dom = $country = $city = $state = $zip = $cnt = $orgid = $ip = $naics = $primary_sic = $countrycode  = $orgmd5  = "";
    $duns_number=$domestichqdunsnumber=$hqdunsnumber=$gltdunsnumber=$countrycode3=$country=$audience=$audiencesegment="";             
    $b2b=$employee_range=$forbes2k=$fortune1k=$industry=$informationlevel=$latitude=$longitude=$phone=$revenue_range=$subindustry=$cov="";
 }
$sth->finish;


system("mysqlimport thomas $tablefile");   

 
# check rec counts
$query  = "SELECT count(*)  FROM  $table  WHERE date='$fdate' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
if (my $row = $sth->fetchrow_arrayref)
 { 
  print "\nCount from  $table: $$row[0]\n";
 } 
$sth->finish;

$rc = $dbh->disconnect;
            
print "\n\nProcessing complete.\nCheck for errors.\n";

exit;
 




