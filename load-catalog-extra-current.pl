#!/usr/bin/perl
#
#  Updates  Product Catalog Pages Viewed (pc) in tnetlogARTU table  (where covflag = t)
#  based on/off numbers
#  Make sure of spreadsheets field order 
# RUN THIS FROM MARCH 2013 FORWARD 
    

$fdate  = $ARGV[0];
if($fdate eq "" ) {print "\n\nForgot to add date yymm or file\n\n"; exit;}

$year    = substr($fdate, 0, 2);
$yy      = $year  ;
$year    = "20" . $year ;
$month   = substr($fdate, 2, 2);
$outfile = "load-catalog-extra-update.txt";   
$dt      = time();  
$backup  = "catnavlog" .  ".bak2";

use DBI;
use POSIX;
$dbh = DBI->connect("", "", "");   
     
open(wf, ">$outfile ")  || die (print "Could not open $outfile \n"); # This is backup
 
$j=0;

$query = "select tgramsid, company  from  thomcatnav_summmary$yy where date='$fdate' and isactive='Yes' group by tgramsid  ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {         
  $catnavpc = 0;
  
  # Get catnav views off
   $subq  = " select sum(TotalPageViews) as totalviews from thomcatnav_summmary$yy where TGRAMSID='$$row[0]' and date='$fdate' and IsActive='Yes' ";
   #print "\n$subq\n";
   my $subr = $dbh->prepare($subq);
   if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
   while (my $srow = $subr->fetchrow_arrayref)
    {
     $catnavpc  = $$srow[0];
    }
   $subr->finish;


  # Get catnav views off
   $subq  = " select sum(TotalPageViews) as totalviews from thomflat_catnav_summmary$yy where TGRAMSID='$$row[0]' and date='$fdate' and IsActive='Yes' ";
   #print "\n$subq\n";
   my $subr = $dbh->prepare($subq);
   if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
   while (my $srow = $subr->fetchrow_arrayref)
    {
     $catnavpc  += $$srow[0];
    }
   $subr->finish; 
   
   $subq2  = "update thomtnetlogARTU$yy set pc='$catnavpc' where covflag='t' and acct='$$row[0]' and date='$fdate' ";
   print  wf "$subq2 ;\n";
 
  $cnt++;
  $j++;

 }
$sth->finish; 

 
system("mysql thomas < $outfile");

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


$rc = $dbh->disconnect; 

#print "total recs \n$cnt | $z\n";
 
 
