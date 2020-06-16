#!/usr/bin/perl
#
# loads master summary table
# run 4th
# this process was added march 2010
# ./load-adfiles4.pl 1003

$fdate = $ARGV[0];
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

#require "ads.ph";
use DBI;
require "/usr/wt/trd-reload.ph";

$year    = substr($fdate, 0, 2);
$yy      = $year  ;
$year    = "20" . $year ;
$month   = substr($fdate, 2, 2);
$dt      = time();  
 
$query = "DELETE FROM thomadcvmaster WHERE fdate='$fdate' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish; 

$outfile = "adcvmaster.txt";   
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
  
$query  = "SELECT DISTINCT bannerid FROM thomadcv$fdate WHERE fdate='$fdate'  ";
#$query .= "AND bannerid=2501 ";
#$query .= "limit 10 ";
print "\n$query\n";
$i = 1;  
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{     
 print "$i)\t$fdate\t$$row[0]\n";

 $j = 1; 
 $subq  = "SELECT org, regionname, city, countrycode3, sum(cnt) as cnt, zip, ";  
 $subq  .= "dma as domain,countryname,naics,primary_sic,countrycode,dunsnum,domestichqdunsnumber,hqdunsnumber,gltdunsnumber,audience,audiencesegment,b2b,employeerange,forbes2k,fortune1k,industry,informationlevel,lat,lon,phone,revenuerange,subindustry, ip ";
 $subq .= "FROM adcv$fdate AS c, adip$fdate AS i ";
 $subq .= "WHERE bannerid='$$row[0]' AND host=ip AND action='V' AND isp='N' ";
 $subq .= "GROUP BY org ORDER BY cnt DESC LIMIT 500 ";
 #print "$subq\n";
 my $subr = $dbh->prepare($subq);
 if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
 while (my $srow = $subr->fetchrow_arrayref)
  {         # date    ip       org         state          
   print wf "$fdate\t$$row[0]\t$$srow[0]\t$$srow[1]\t$$srow[2]\t$$srow[3]\t$$srow[4]\t$$srow[5]\t$$srow[6]\t$$srow[7]\t$$srow[8]\t$$srow[9]\t$$srow[10]\t$$srow[11]\t$$srow[12]\t$$srow[13]\t$$srow[14]\t$$srow[15]\t$$srow[16]\t$$srow[17]\t$$srow[18]\t$$srow[19]\t$$srow[20]\t$$srow[21]\t$$srow[22]\t$$srow[23]\t$$srow[24]\t$$srow[25]\t$$srow[26]\t$$srow[27]\t$$srow[28]\n";
   $j++;  
  }
 $subr->finish;
 
 $i++; 
}
$sth->finish; 

close(wf);      

$rc = $dbh->disconnect; 

system ( "mysqlimport -L thomas $DIR/newsip/$outfile" );
 

 
