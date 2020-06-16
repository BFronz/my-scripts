#!/usr/bin/perl
#
# Makes xls cad reports fro Client Center
# for month  ./run-CAD-xls.pl M YYMM $acct 
# for quarter ./run-CAD-xls.pl Q YY0Q $acct 
# for year ./run-CAD-xls.pl Y YY0Q $acct 
   

$type  = $ARGV[0]; 
$fdate = $ARGV[1]; 
$record = $ARGV[2];
$yy = substr($fdate, 0, 2);
$logdate = "$type$fdate"; 
$limit=3800; 
$dom  = "http://tnetrpt.c.net"; 
$runpage  = "cadreportrun.html"; 


if($fdate eq "" )  {  print "\nMissing date YYMM\n\n";  exit; }
if($type eq "" )   {  print "\nMissing type M Q Y\n\n"; exit; } 
if($record eq "" )   {  print "\nMissing acct #\n\n"; exit; } 
 
# Connect to mysql database
use DBI;  
use URI::Escape;
$db          = "tgrams";
$data_source = "dbi:mysql:$db:localhost";
$user     = "";
$auth     = "";  
$dbh      = DBI->connect($data_source, $user, $auth);
$unixtime = time();
                    

if($record)
   { 
    # Curl the page
     $VARS    = "cid=$record&"; 
     $VARS   .= "logdate=$logdate&"; 
     $VARS   .= "PDF=1&csv=1&fromscript=1&user_appid=9999";  

     $VARS = uri_escape($VARS);
     $URL  = $dom . "/" . $runpage . "?" . $VARS ;

     # Curl the page
     @lines = `curl  $URL`;
     foreach $lines (@lines) { print "$lines\n"; }
     undef(@lines);
 
    #print "$z) $record $comp[$record]\n";
    print "    $URL\n\n";
    $z++; 
   }


$rc = $dbh->disconnect;



