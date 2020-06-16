#!/usr/bin/perl
#  
#  Syncs "Product Catalog Pages Viewed" between All Report & Catnav Report

$fdate  = $ARGV[0];
if($fdate eq "") {print "\n\nForgot to add date yymm or file\n\n"; exit;}

$year  = substr($fdate, 0, 2);
$yy    = $year  ;
$year  = "20" . $year ;
$month = substr($fdate, 2, 2);
$dt    = time();  
 
use DBI;
use POSIX;
$dbh = DBI->connect("", "", "");    
     
# Loop through catalog accounts and update    
$j=0;
$query  = "select acct from tgrams.main ";
$query .= "where (premiums like '%O%' || premiums like '%V%' || premiums like '%T%' ||  premiums like '%U%' ) ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {         
  # Get tnet catalog views  
  $subq  = "select totalpageviews from thomcatnav_summmary$yy ";
  $subq .= "where tgramsid='$$row[0]' and isactive='yes' and date='$fdate' ";
  my $subr = $dbh->prepare($subq);
  if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
  while (my $srow = $subr->fetchrow_arrayref)
    { 
     $catnavpc  = $$srow[0];
    }
   $subr->finish;
  
  # update   
  $subq  = "update thomtnetlogARTU$yy set pc='$catnavpc' where acct='$$row[0]' and date='$fdate' and covflag='t'"; 
  print "$subq\n";
  my $subr = $dbh->prepare($subq); 
  if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
  $subr->finish;
  $j++;      
  $catnavpc = $tnetpc = 0;
 }
$sth->finish; 

$rc = $dbh->disconnect; 
close(wf2); 
 

print "\n\nTotal Updates: $j \n\n";
