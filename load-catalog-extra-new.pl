#!/usr/bin/perl
#
#  Updates  Product Catalog Pages Viewed (pc) in tnetlogARTU table  (where covflag = t)
#  based on numbers from the "catalog team's" file 
#  Make sure of spreadsheets field order 
#  Run as: ./load-catalog-extra.pl yymm 
     

$fdate  = $ARGV[0];
if($fdate eq "" ) {print "\n\nForgot to add date yymm or file\n\n"; exit;}

$year    = substr($fdate, 0, 2);
$yy      = $year  ;
$year    = "20" . $year ;
$month   = substr($fdate, 2, 2);
$outfile = "load-catalog-extra-update.txt";   
system("rm -f $outfile");
$dt      = time();  
$backup  = "catnavlog" .  ".bak2";

use DBI;
use POSIX;
$dbh = DBI->connect("", "", "");   
    
open(wf2, ">$backup")  || die (print "Could not open $backup\n"); # This is backup
 
$j=0;
$query = "select acct,company from tgrams.main where (premiums like '%O%' || premiums like '%V%' || premiums like '%T%' ||  premiums like '%U%' ) ";
# new: use catnav data not main table to determine  a catalog's legitimacy
$query = "select tgramsid, company  from  thomcatnav_summmary$yy where date='$fdate' and isactive='Yes' group by tgramsid  ";
#print "$query";
#$query .=" and acct=588687";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {         
  # Get tnet catalog views 

   $subq  = " select pc from thomtnetlogARTU$yy where covflag='t' and acct='$$row[0]' and date='$fdate' ";
   #print "\n$subq\n";
   my $subr = $dbh->prepare($subq);
   if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
   while (my $srow = $subr->fetchrow_arrayref)
    {
     $tnetpc  = $$srow[0];
    }
   $subr->finish;

 
  # Get catnav views
   $subq  = " select sum(TotalPageViews) as totalviews from thomcatnav_summmary$yy where TGRAMSID='$$row[0]' and date='$fdate' and IsActive='Yes' ";
   #print "\n$subq\n";
   my $subr = $dbh->prepare($subq);
   if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
   while (my $srow = $subr->fetchrow_arrayref)
    {
     $catnavpc  = $$srow[0];
    }
   $subr->finish;

  # Get catalog views  at headings 
  $qtable =  "qlog" . $yy . "Y";
  $subq  = " select sum(pc) as pc from $qtable as u , headings_history as h ";
  $subq .= "where acct='$$row[0]' and date='$fdate' and u.heading=h.heading  and covflag='t' "; 
  #print "\n$subq\n";
  my $subr = $dbh->prepare($subq);  
  if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
  while (my $srow = $subr->fetchrow_arrayref)
    {
     $tnetpchd  = $$srow[0]; 
    }
   $subr->finish;
  
  $total = $catnavpc; # baseline #

  if( $catnavpc > $tnetpc ) # catnav > webtrends 
      { 
       $subq2  = "update thomtnetlogARTU$yy set pc='$catnavpc' where covflag='t' and acct='$$row[0]' and date='$fdate' ";
       print wf2 "# catnav > webtrends\n";
       print  wf2 "$subq2 ;\n";
       $total = $catnavpc;
      }   
  elsif( $tnetpc > $catnavpc ) # webtrends > catnav
      {    
       $subq2  = "update thomcatnav_summmary$yy set TotalPageViews='$tnetpc' where TGRAMSID='$$row[0]' and date='$fdate' and IsActive='Yes' ";
       print wf2 "# webtrends > catnav\n";
       print  wf2 "$subq2 ;\n"; 
       $total =  $tnetpc;
      } 

  if( $tnetpchd > $total )  # broken out by heading > the above
      {  
       $subq2  = "update thomtnetlogARTU$yy set pc='$tnetpchd' where covflag='t' and acct='$$row[0]' and date='$fdate' ";
       print wf2 "#  broken out by heading > the above\n";
       print  wf2 "$subq2 ;\n"; 
       $subq2  = "update thomcatnav_summmary$yy set TotalPageViews='$tnetpchd' where TGRAMSID='$$row[0]' and date='$fdate' and IsActive='Yes' ";
       print  wf2 "$subq2 ;\n";
      } 
      
  #print "$j) $$row[0]\t$$row[1]\t";  
  # print "all:$tnetpc\tCat:$catnavpc\tAthead:$tnetpchd\n";
  $catnavpc = $tnetpc = $catnavpchd = $tnetpchd = $total = 0;

  $cnt++;
  $j++;

 }
$sth->finish; 


system("mysql thomas < catnavlog.bak2");

 
$subq = "SELECT SUM(totalpageviews) AS totalpageviews FROM thomcatnav_summmary$yy WHERE  isactive='yes' and date='fdate' ";  
$subq  = " select sum(pc) from thomtnetlogARTU$yy where covflag='t' and date='$fdate' ";
#print "\n$subq\n";
my $subr = $dbh->prepare($subq);
if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
if (my $srow = $subr->fetchrow_arrayref)
 { 
  $totalpc  = $$srow[0];
 }
$subr->finish; 

$subq  = " update tnetlogSITEN set cv = '$totalpc'  where date='$fdate' ";
my $subr = $dbh->prepare($subq);
if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
$subr->finish; 


 
system("mysql thomas < catnavlog.bak2");


$rc = $dbh->disconnect; 

#print "total recs \n$cnt | $z\n";
 
 
