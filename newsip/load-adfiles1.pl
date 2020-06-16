#!/usr/bin/perl
#
# 
# makes a table of all files adclicks & views for the month
# run this first 
# run as ./load-adfiles1.pl YYMM

#require "ads.ph";
 
use DBI;
require "/usr/wt/trd-reload.ph"; 

# get a list of adveiw files, loop through and insert file info into a table
# seems to be only one lately
system ( "ls  /usr/wt/newsip/adviews  > adfiles.ls"  ); 
open(rf, "adfiles.ls") || die (print "Could not open adfiles.ls\n");
open(wf, ">adfiles.txt") || die (print "Could not open adfiles.txt\n");
while (!eof(rf))  
 { 
  $file = <rf>;
  chop($file); 

  #($archive, $report, $yyyy, $mm) =  split("_", $file);
  ($archive, $report, $dt) =  split("_", $file);
  $yyyy = substr($dt, 0, 4);
  $mm   = substr($dt, 4, 2);		 	
  $report = "reportviews";
  $mm     =~ s/.txt//;
  $fdate   =  substr($yyyy, 2, 2) . $mm ;
  print "$file | $fdate \n";
  if($file =~ /.txt/) { print wf "$file\t$report\t$fdate\t0\n"; }  
}  
close(rf);
close(wf);
system ( "mysqlimport -L thomas $DIR/newsip/adfiles.txt" ); 


# get a list of adclick files, loop through and insert file info into a table
system ( "ls /usr/wt/newsip/adclicks > adfiles.ls"  ); 
open(rf, "adfiles.ls") || die (print "Could not open adfiles.ls\n");
open(wf, ">adfiles.txt") || die (print "Could not open adfiles.txt\n");
while (!eof(rf))  
 { 
  $file = <rf>;
  chop($file); 
  #($archive, $report, $yyyy, $mm) =  split("_", $file);
  ($archive, $report, $dt) =  split("_", $file);
   
  $yyyy = substr($dt, 0, 4);
  $mm   = substr($dt, 4, 2);
  $report = "reportclicks";
  $mm     =~ s/.txt//;
  $fdate   =  substr($yyyy, 2, 2) . $mm ;
  print "$file | $fdate \n";
  if($file =~ /.txt/) { print wf "$file\t$report\t$fdate\t0\n"; }  
 } 
close(rf);
close(wf);
system ( "mysqlimport -L thomas $DIR/newsip/adfiles.txt" ); 

$rc = $dbh->disconnect;

  
