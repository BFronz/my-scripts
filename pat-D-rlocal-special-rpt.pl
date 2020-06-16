#!/usr/bin/perl
#
$outfile = "rlocal-estara-Feb2012-April2013-rpt-new.txt";
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
print wf "TGRAMS #\tAccount Name\tRep Name\tSenior Name\tProfile Views Count\tLinks to Website Count\t";
print wf "CT Calls Count\tMST Visits Count\tMST Calls Count\tMST Emails Count\tMST Web Events Count\t";
print wf "MST Web Events Submitted\n";

use DBI;
use POSIX;
$dbh = DBI->connect("", "", "");
  
$i=0;              
$query  = "SELECT company, a.acct, salesman, seniorid from thomadvcode as a, tgrams.main as m where a.acct=m.acct group by a.acct order by company ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $record[$i] = "$$row[0]|$$row[1]|$$row[2]|$$row[3]|";
  print "$i) $record[$i]\n";
  $i++;
 } 
$sth->finish;


$j=0;
foreach $record (@record)
{  
  print "$j)\t$record\n";
 ($acct,$company,$senior,$salesman) = split(/\|/,$ctacct);
 




    
  # visits 
  $query   = "SELECT DATE_FORMAT(report_date, '%Y-%m-%d') as d, sum(visits) ";
  $query  .= "FROM Campaign_Daily_Activity WHERE adv_code='$record' AND visits>0  "; 
  $query  .= "AND ( DATE_FORMAT(report_date, '%y%m%d')>='$sdate'  && DATE_FORMAT(report_date, '%y%m%d')<='$edate') ";
  $query  .= "GROUP BY d ORDER BY d ";
   print "\n$query\n\n";
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

=for comment
=cut
