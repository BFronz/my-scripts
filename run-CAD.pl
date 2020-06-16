#!/usr/bin/perl
#
# run as ./run-CAD.pl M YYMM

$type  = $ARGV[0]; 
$fdate = $ARGV[1]; 
$logdate = "$type$fdate"; 

if($fdate eq "" )  {  print "\nMissing date YYMM\n\n";  exit; }
if($type eq "" )   {  print "\nMissing type M Q Y\n\n"; exit; } 

$dom      = "http://tnetrpt.c.net"; 
$runpage  = "cadreport.html"; 

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
$query = "SELECT acct,company FROM main WHERE adv='Y' and acct>0  and premiums like '%A%' order by company ";
#$query .= "limit 5 "; 
#$query = "SELECT acct,company FROM main WHERE adv='Y' and acct=34359 ";  

 
  
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
 $VARS    = "cid=$record&"; 
 $VARS   .= "logdate=$logdate&"; 
 $VARS   .= "PDF=1"; 
 #$VARS    = uri_escape($VARS);
 $URL     = $dom . "/" . $runpage . "?" . $VARS ;  
 $pdfdir  = "/usr/pdf/$record";
 $rpt     = $pdfdir . "/" . $record . "_ALL". $logdate . "_X" .  ".pdf";
 $cordurl = "http://crater.c.net:8001/?\@_DOC_LOAD" . $URL . "\@_PDF";

 @lines = `curl -s -o $rpt \"$cordurl\"`;
 foreach $lines (@lines) { print "$lines\n"; }  
 undef(@lines);   
   
 print "$z) $record $comp[$record]\n";
 $z++; 
}

$rc = $dbh->disconnect;



