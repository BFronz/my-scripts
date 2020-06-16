#!/usr/bin/perl
#
# Special year to date ReachLocal Report
# Run this script every quarter 
# Post at orion:/www/tnetadmin/webtraxs for Leandro
# Run as ./rlocal-special-rpt.pl startdate(yymmdd) enddate(yymmdd)  
# Example: ./rlocal-special-rpt.pl 100101 100531
# Example: ./rlocal-special-rpt.pl 140101 140331
# ./rlocal-special-rpt.pl 170101 17030

$sdate = $ARGV[0];
$edate = $ARGV[1];
if($sdate eq "" || $edate eq "") {print "\n\nForgot to add dates yymmdd\n\n"; exit;}

$outfile = "rlocal-rpt-$sdate-$edate.txt";
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");

use DBI;
use POSIX;
require "/usr/wt/trd-reload.ph";
 
$i=0;
$query  = "SELECT adv_code from thomCampaign_Event_Detail_v2 ";
$query .= "WHERE adv_code  >0 AND DATE_FORMAT(report_date, '%y%m%d')>= '$sdate' ";
$query .= "AND DATE_FORMAT(report_date, '%y%m%d')<='$edate' ";
$query .= "GROUP BY adv_code";
#$query .= "LIMIT 20 ";
print "$query";
  
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $record[$i] = "$$row[0]";
  #print "$i) $record[$i]\n";
  $i++;
 } 
$sth->finish;

# TGRAMS ID
# TRANSACTION
# DATE_OF_TRANSACTION
# COUNT

$j=0;
foreach $record (@record)
{  
  print "$j)\t$record\n";
   
  # visits 
  $query   = "SELECT DATE_FORMAT(report_date, '%Y-%m-%d') as d, sum(visits) ";
  $query  .= "FROM Campaign_Daily_Activity WHERE adv_code='$record' AND visits>0  "; 
  $query  .= "AND ( DATE_FORMAT(report_date, '%y%m%d')>='$sdate'  && DATE_FORMAT(report_date, '%y%m%d')<='$edate') ";
  $query  .= "GROUP BY d ORDER BY d ";
  # print "\n$query\n\n";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
   { 
     print wf "$record\tVisit\t$$row[0]\t$$row[1]\n";
   } 

  # email
  $query   = "SELECT DATE_FORMAT(report_date, '%Y-%m-%d') as d, count(*) ";
  $query  .= "FROM Campaign_Event_Detail_v2 WHERE adv_code='$record' AND event_type_name='Email'  "; 
  $query  .= "AND ( DATE_FORMAT(report_date, '%y%m%d')>='$sdate'  && DATE_FORMAT(report_date, '%y%m%d')<='$edate') ";
  $query  .= "GROUP BY d ORDER BY d ";
  # print "\n$query\n\n";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
   { 
     print wf "$record\tEmail\t$$row[0]\t$$row[1]\n";
   }   

  # call
  $query   = "SELECT DATE_FORMAT(report_date, '%Y-%m-%d') as d, count(*) ";
  $query  .= "FROM Campaign_Event_Detail_v2 WHERE adv_code='$record' AND event_type_name='Call'  "; 
  $query  .= "AND ( DATE_FORMAT(report_date, '%y%m%d')>='$sdate'  && DATE_FORMAT(report_date, '%y%m%d')<='$edate') ";
  $query  .= "GROUP BY d ORDER BY d  ";
  # print "\n$query\n\n";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
   {                        
     print wf  "$record\tCall\t$$row[0]\t$$row[1]\n";
   }   


  # contact us submitted
  $query   = "SELECT DATE_FORMAT(report_date, '%Y-%m-%d') as d, count(*) "; 
  $query  .= "FROM Campaign_Event_Detail_v2 WHERE adv_code='$record' AND event_type_name='Web_Event' AND web_event_submitted='Submitted'  "; 
  $query  .= "AND ( DATE_FORMAT(report_date, '%y%m%d')>='$sdate'  && DATE_FORMAT(report_date, '%y%m%d')<='$edate') ";
  $query  .= "GROUP BY d ORDER BY d ";
  # print "\n$query\n\n";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
   {                        
     print wf "$record\tWeb Event Submitted\t$$row[0]\t$$row[1]\n";
   }   
 
 $j++;
}

close(wf);

$dbh->disconnect;

print "\nDone...\n";

=for comment
=cut
