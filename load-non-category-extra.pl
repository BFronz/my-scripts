#!/usr/bin/perl
#
# update links catalog cad for non-cat data
    
$fdate  = $ARGV[0];
if($fdate eq "" ) {print "\n\nForgot to add date yymm or file\n\n"; exit;}

use DBI;
use POSIX;
require "/usr/wt/trd-reload.ph";

$year    = substr($fdate, 0, 2);
$yy      = $year  ;
$year    = "20" . $year ;
$month   = substr($fdate, 2, 2);
$outfile = "load-non-category-extra.txt";
$dt      = time();  
   
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");

$i=0;
$query  = "SELECT distinct(acct) FROM  thomNonCatConversions$yy WHERE fdate='$fdate' AND ( link_catalog_cad > '0' || cad_library > '0' ) ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $record[$i] = $$row[0];
  $i++;
 }
$sth->finish;

 
# Set counts to 0
$query = "update thomNonCatConversions$yy set  link_catalog_cad = '0', cad_library = '0'  where fdate='$fdate'  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;


# loop through all accounts     
$j=1; 
 
foreach $record (@record)
{
 #print "$j) $record\n";
         
   # TOTAL links
   # cl Links to CADRegister 
   # lc Catalog links 
   $totallinks =  $tcadlinks = $tcataloglinks = 0;  
   $subq  = " SELECT SUM(cl) AS cadlinks,  SUM(lc) AS cataloglinks, SUM(cl)+SUM(lc) AS totallinks ";
   $subq .= " from thomtnetlogARTU$yy where  acct='$record' and date='$fdate' and covflag='t' ";
   #print "\n$subq\n"; 
   my $subr = $dbh->prepare($subq);
   if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
   while (my $srow = $subr->fetchrow_arrayref)
    { 
     $tcadlinks     = $$srow[0];
     $tcataloglinks = $$srow[1];
     $totallinks   = $$srow[2];
    }
   $subr->finish;
   #print "tcadlinks:  $tcadlinks\ntcataloglinks: $tcataloglinks\ntotallinks: $totallinks\n";
  
   
   # Links at headings
   # cd Links to CADRegister  
   # lc Catalog links         
   $hcadlinks =  $hcataloglinks =  $htotallinks = 0;
   $qtable =  "thomqlog" . $yy . "Y";
   $subq  = "SELECT SUM(cd) AS hcadlinks, SUM(lc) AS hcataloglinks, SUM(cd)+SUM(lc) AS htotallinks ";
   $subq .= "from $qtable as u , headings_history as h where acct='$record' and u.heading=h.heading and date='$fdate' and covflag='t' ";
   #print "\n$subq\n";
   my $subr = $dbh->prepare($subq);
   if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
   while (my $srow = $subr->fetchrow_arrayref)
    { 
     $hcadlinks     = $$srow[0];
     $hcataloglinks = $$srow[1];
     $htotallinks   = $$srow[2];
    }
   $subr->finish;
   #print "\nhcadlinks:  $hcadlinks\nhcataloglinks: $hcataloglinks\nhtotallinks: $htotallinks\n";
   #print "----------------------------\n";



 # update General Links to Catalog
 $noncataloglinks = 0; 
 if($tcataloglinks >= $hcataloglinks)
  {
   $noncataloglinks =  $tcataloglinks - $hcataloglinks;  
  }
 elsif($tcataloglinks < $hcataloglinks)
  {
   # do nothing update will be 0 
  }  
 $update  = "update thomNonCatConversions$yy set link_catalog_cad = '$noncataloglinks' where acct='$record' and fdate='$fdate' ";
 print  wf "$update ;\n"; 


  # update CAD Library
  $noncadlinks = 0;
  if($tcadlinks >= $hcadlinks)
   {
    $noncadlinks =  $tcadlinks - $hcadlinks;
   }
  elsif($tcadlinks <= $hcadlinks)
  {
     # do nothing update will be 0 
  } 
 $update  = "update thomNonCatConversions$yy set cad_library = '$noncadlinks' where acct='$record' and fdate='$fdate' ";
 print  wf "$update ;\n";
   


  $j++;

 }
$sth->finish; 
 
system("mysql thomas < $DIR/$outfile");

$rc = $dbh->disconnect; 
 


 
 
