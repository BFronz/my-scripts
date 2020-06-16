#!/usr/bin/perl
#
# create a report of multi month reverse ip data based on a company
# set month(s) needed for the report
# get banner ids for the months associated with the account
# run as ./paul-rpt.pl 
# then query table

# >> set up dates and banner ids <<
$fdate[0] = 1001;
$fdate[1] = 1002;
$fdate[2] = 1003;
$fdate[3] = 1004;
$fdate[4] = 1005;
$fdate[5] = 1006;
$bannerids = " '3573','3574','3577','3578','3587','3589','3793','3795','3824','3825','3827','3830','3847','3848','3849','3850','3851','3852','3853','3854','3855','3856','3857','3858' ";  

=for comment
=cut

$outfile = "adcvmaster_rpt.txt";   
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");

require "ads.ph";
use DBI;
use DBD::mysql;
use Digest::MD5 qw(md5 md5_hex md5_base64);
$dsn  = "dbi:mysql:$db:localhost:3306";
$dbh  = DBI->connect($dsn, $user, $pw);

$year    = substr($fdate, 0, 2);
$yy      = $year  ;
$year    = "20" . $year ;
$month   = substr($fdate, 2, 2);
$dt      = time();   
 
$query = "DELETE FROM bob.adcvmaster_rpt  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish; 

foreach $fdate (@fdate)
{
 print "$fdate\n";

 $subq  = "SELECT org, regionname, city, countrycode3, action, sum(cnt) as cnt ";
 $subq .= "FROM adcv$fdate AS c, adip$fdate AS i ";
 $subq .= "WHERE bannerid in ($bannerids) AND host=ip AND action='C' AND isp='N' ";
 $subq .= "GROUP BY org, action ORDER BY cnt DESC  ";
 $subq .= "LIMIT 3000 ";
 #print "$subq\n";
 my $subr = $dbh->prepare($subq);
 if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
 while (my $srow = $subr->fetchrow_arrayref)
  {                   
   print wf "$$srow[0]\t$$srow[1]\t$$srow[2]\t$$srow[3]\t$$srow[4]\t$$srow[5]\n";
   $j++;
  }
 $subr->finish;

 $subq  = "SELECT org, regionname, city, countrycode3, action, sum(cnt) as cnt ";
 $subq .= "FROM adcv$fdate AS c, adip$fdate AS i ";
 $subq .= "WHERE bannerid in ($bannerids) AND host=ip AND action='V' AND isp='N' ";
 $subq .= "GROUP BY org, action ORDER BY cnt DESC  ";
 $subq .= "LIMIT 3000 ";
 #print "$subq\n";
 my $subr = $dbh->prepare($subq);
 if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
 while (my $srow = $subr->fetchrow_arrayref)
  {                   
   print wf "$$srow[0]\t$$srow[1]\t$$srow[2]\t$$srow[3]\t$$srow[4]\t$$srow[5]\n";
   $j++;
  }
 $subr->finish;

}

close(wf);      
system ( "mysqlimport -u robertf -pcmg -i bob /mnt/bob/$outfile" );


$outfile2 = "Newsroom_Report.txt";   
open(wf2,  ">$outfile2")  || die (print "Could not open $outfile2\n");
  
#print "org\tregionname\tcity\tcountry\taction\tcount\n"; 
print wf2 "organization\tcity\tcountry\taction(view or click)\n"; 

$subq  = "SELECT org, regionname, city, countrycode3, action, sum(cnt) AS cnt ";
$subq .= "FROM adcvmaster_rpt "; 
$subq .= "WHERE  org>'' AND cnt>0 "; 
$subq .= "GROUP BY org, action ORDER BY action, cnt DESC "; 
my $subr = $dbh->prepare($subq);
if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
while (my $srow = $subr->fetchrow_arrayref)
 {                   
  #print wf2 "$$srow[0]\t$$srow[1]\t$$srow[2]\t$$srow[3]\t$$srow[4]\t$$srow[5]\n";
  print wf2 "$$srow[0]\t$$srow[2]\t$$srow[3]\t$$srow[4]\n";
  $j++;
 }
$subr->finish;

close(wf2); 

$rc = $dbh->disconnect; 


 
 
 
