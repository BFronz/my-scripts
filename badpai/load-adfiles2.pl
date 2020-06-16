#!/usr/bin/perl
#
# 
# load adclicks & ad adview files for the month
# run this second
# run as ./load-adfiles2.pl YYMM

$fdate  = $ARGV[0];
if($fdate eq "") {print "\n\nForgot to add date YYMM\n\n"; exit;}

#require "ads.ph";
use DBI;
require "/usr/wt/trd-reload.ph";

$rpttable  = "adcv" . $fdate;
$rptfile   = "adcv" . $fdate . ".txt";
$temptable = "adlog";
$tempfile  = "adlog.txt";
open(wf, ">$rptfile")    || die (print "Could not open $rptfile\n");
open(wf2, ">$tempfile")  || die (print "Could not open $tempfile\n");
 

# clear temp table
$query = "DELETE FROM $temptable "; 
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
$sth->finish;

   
# create the report table
$query = "DROP TABLE IF EXISTS $rpttable "; 
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
$sth->finish;

$query = "
CREATE TABLE $rpttable (
  fdate    varchar(4) NOT NULL default '0',
  bannerid int(11) NOT NULL default '0',
  host     varchar(15) NOT NULL default '',
  cnt      int(11) NOT NULL default '0',
  action   char(1) NOT NULL default '',  
  primary KEY (bannerid,host,action),
  KEY (bannerid),
  KEY (host),
  KEY (bannerid,action)
) ENGINE=MyISAM DEFAULT CHARSET=latin1  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
$sth->finish;


### PROCESS AD CLICKS ###  
# get active adclick files for the month
$i = $j = 0 ;
$query = "SELECT files FROM adfiles WHERE $fdate='$fdate' AND processed=0 AND rtype='reportclicks' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {    
  $files[$i] = $$row[0]; 
  $i++; 
 } 
$sth->finish;
  
# loop through files, get records and load into a temporary table
foreach $files (@files)
{    
 print "$files\n"; 
 $cfile = "/usr/wt/newsip/adclicks/" . $files;
 
 open(rf, "$cfile") || die (print "Could not open $cfile\n");
 while (!eof(rf))
  {  
   $rec = <rf>;
   chop($rec);   
   $bannerid=$zoneid=$t_stamp=$host=$country=$domain=$page=$query=$referer=$user_agent=$geo_region=$geo_city=$geo_postal_code=$geo_dma_code=$geo_area_code=$include = "";
   ($host,$bannerid) = split(/\t/, $rec);
   #$yy =  substr($t_stamp, 2, 2); # can get from  $fdate but this is an extra check
   #$mm =  substr($t_stamp, 5, 2); 
   
   print wf2 "$bannerid\t$host\t$fdate\n";
  }   
  close(rf);
 
 # update to show file has been processed
 $query = "UPDATE adfiles SET processed = '1' WHERE files ='$files' ";
 my $sth = $dbh->prepare($query);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
 $sth->finish;
}   
close(wf2);
system ( "mysqlimport -L thomas $DIR/newsip/$tempfile" );

# now query temporary table to get summary data and write to file
$query = "SELECT bannerid, host, count(*) FROM $temptable WHERE fdate='$fdate' GROUP BY bannerid, host ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {                          
  print wf "$fdate\t$$row[0]\t$$row[1]\t$$row[2]\tC\n";
 }
$sth->finish;
undef(@files);


### PROCESS AD VIEWS ###  
# get active adclick files for the month
$i = $j = 0 ;
$query = "SELECT files FROM adfiles WHERE $fdate='$fdate' AND processed=0 AND rtype='reportviews' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {    
  $files[$i] = $$row[0]; 
  $i++; 
 } 
$sth->finish;
  
# loop through files, get records and load into a temporary table
open(wf2, ">$tempfile")  || die (print "Could not open $tempfile\n");
foreach $files (@files)
{    
 print "$files\n"; 
 $vfile = "/usr/wt/newsip/adviews/" . $files;
     
 open(rf, "$vfile") || die (print "Could not open $vfile\n");
 while (!eof(rf))
  {  
   $rec = <rf>;
   chop($rec); 
   $bannerid=$zoneid=$t_stamp=$host=$country=$domain=$page=$query=$referer=$user_agent=$geo_region=$geo_city=$geo_postal_code=$geo_dma_code=$geo_area_code=$include = "";
   ($host,$bannerid) = split(/\t/, $rec);
   #$yy =  substr($t_stamp, 2, 2); # can get from  $fdate but this is an extra check
   #$mm =  substr($t_stamp, 5, 2); 
   print wf2 "$bannerid\t$host\t$fdate\n";
  }  
  close(rf);

 # update to show file has been processed
 $query = "UPDATE adfiles SET processed = '1' WHERE files ='$files' ";
 my $sth = $dbh->prepare($query);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
 $sth->finish;
}   
close(wf2);
system ( "mysqlimport -L thomas  $DIR/newsip/$tempfile" );

# now query temporary table to get summary data and write to file
$query = "SELECT bannerid, host, count(*) FROM $temptable WHERE fdate='$fdate' GROUP BY bannerid, host ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {                          
  print wf "$fdate\t$$row[0]\t$$row[1]\t$$row[2]\tV\n";
 }
$sth->finish;
undef(@files);
close(wf);

# import
system ( "mysqlimport -L thomas  $DIR/newsip/$rptfile" );

# Make a list of unique IPs that will be used later on 
system("cut -f 3 $rptfile | sort -u > adcv.ls");


$rc = $dbh->disconnect;

  
