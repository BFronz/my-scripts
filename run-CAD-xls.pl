#!/usr/bin/perl
#
# Makes xls cad reports fro Client Center
# run as ./run-CAD-xls.pl M YYMM

$type  = $ARGV[0]; 
$fdate = $ARGV[1]; 
$yy = substr($fdate, 0, 2);
$logdate = "$type$fdate"; 
$limit=3800;
$dom      = "http://tnetrpt.c.net"; 
$runpage  = "cadreportrun.html"; 


if($fdate eq "" )  {  print "\nMissing date YYMM\n\n";  exit; }
if($type eq "" )   {  print "\nMissing type M Q Y\n\n"; exit; } 

# Connect to mysql database
use DBI;  
use URI::Escape;
$db          = "tgrams";
$data_source = "dbi:mysql:$db:localhost";
$user     = "";
$auth     = "";  
$dbh      = DBI->connect($data_source, $user, $auth);
$unixtime = time();
                    
# Put cad accts into an array
$query = "SELECT acct,company FROM main WHERE adv='Y' and acct>0  and premiums like '%A%' order by company  ";  
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
$i = 0;
while (my $row = $sth->fetchrow_arrayref)
 {       
  $record[$i] =  $$row[0];
  $comp[$$row[0]] = $$row[1];
  $i++; 
 }
$sth->finish;

$z=1;  
# Run through sales id, formant url and curl
foreach $record (@record) 
{   
 $count=0;
 $query = "select count(*) as n from thomtnetlogCADDET$yy where acct = $record and date='$fdate' ";
 my $sth = $dbh->prepare($query); 
 if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
 $i = 0;
 while (my $row = $sth->fetchrow_arrayref)
  {        
   $count = $$row[0];
  }
 $sth->finish;
  
 if($count > $limit)
   { 
    # Curl the page
     $VARS    = "cid=$record&"; 
     $VARS   .= "logdate=$logdate&"; 
     $VARS   .= "PDF=1&csv=1&fromscript=1";  

     $VARS = uri_escape($VARS);
     $URL  = $dom . "/" . $runpage . "?" . $VARS ;

     # Curl the page
     @lines = `curl  $URL`;
     #foreach $lines (@lines) { print "$lines\n"; }
     undef(@lines);
 
    print "$z) $record $comp[$record]\n";
    print "    $URL\n\n";
    $z++; 
   }
}

$rc = $dbh->disconnect;



