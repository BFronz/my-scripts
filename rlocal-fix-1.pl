#!/usr/bin/perl
#
# Run this first 
# inserts missing records
# change date  
# check output
# mysqlimport thomas Campaign_Daily_Activity.txt


$fdate=" '1203' ";
# $fdate= " '1201','1202','1203','1204','1205','1206','1207','1208','1209','1210','1211','1212'  ";
 
use DBI;
$dbh      = DBI->connect("", "", "");
                          
open(wf,  ">Campaign_Daily_Activity.txt")  || die (print "Could not open Campaign_Daily_Activity.txt\n");

$query = " select  distinct(adv_code)  from Campaign_Daily_Activity where date in ($fdate)  ";   ###and adv_code=1282676 ";
#$query .= " limit 3 "; 
#print "$query\n";
$i=0;
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $account[$i] = $$row[0];
  #print "$account[$i]\n";
  $i++;
 }
$sth->finish;

$z=1;
foreach $account (@account)
{
 print "$z)\t$account\n";
   
 $q = "select * from thomCampaign_Daily_Activity where adv_code = $account and left(date,2)=12 limit 1 ";
 #print "\n\n$q\n\n";
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {          	
  $report_date_s       = $$row[0];  
  $adv_id_s            = $$row[1];  
  $adv_name_s          = $$row[2];  
  $adv_code_s          = $$row[3];  
  $camp_id_s           = $$row[4];  
  $camp_name_s         = $$row[5];  
  $camp_spend_s        = $$row[6];  
  $camp_adjustment_s   = $$row[7];  
  $camp_fees_s         = $$row[8];  
  $visits_s            = $$row[9];  
  $impressions_s       = $$row[10]; 
  $calls_s             = $$row[11]; 
  $emails_s            = $$row[12]; 
  $coupons_s           = $$row[13]; 
  $web_links_s         = $$row[14]; 
  $web_events_s        = $$row[15]; 
  $last_updated_s      = $$row[16]; 
  $date_s              = $$row[17]; 
 }   
 $sth->finish;   
 
 $q = "select substring(report_date, 1, 10) as d, ";
 $q .= "sum(if(event_type_name='Call',1,0)) as calls, sum(if(event_type_name='Email',1,0)) as emails, sum(if(event_type_name='Web_Event',1,0)) as web_events ";
 $q .= "from thomCampaign_Event_Detail_v2 ";   
 $q .= "where adv_code = $account and date in ($fdate) group by d";
 #print "\n\n$q\n\n"; 
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {         
   $date    = $$row[0];
   $calls   = $$row[1];
   $emails  = $$row[2];
   $web     = $$row[3]; 

   #print "live: $date\t$calls\t$emails\t$web\n";
      
   $subq = "select count(*) from thomCampaign_Daily_Activity where adv_code=$account and substring(report_date, 1, 10)='$date'  "; 
   # print "\n\n$subq\n\n"; 
   $cnt=0;
   my $subr = $dbh->prepare($subq);
   if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
   while (my $srow = $subr->fetchrow_arrayref)
    { 
     $cnt = $$srow[0];  
    }
   $subr->finish; 

  if($cnt eq 0)
  {  
   print "live: $date\t$calls\t$emails\t$web\n";
   $yymm    = substr($date, 2, 2) . substr($date, 5, 2);
   print " $yymm  \n";  
   print "adds: $date\t$calls\t$emails\t$web\n";
   print wf "$date\t";
   print wf "$adv_id_s\t";
   print wf "$adv_name_s *\t";
   print wf "$adv_code_s\t";
   print wf "$camp_id_s\t";
   print wf "$camp_name_s\t";
   print wf "0.0000\t";
   print wf "0.0000\t";
   print wf "0.0000\t";
   print wf "1\t";
   print wf "0\t";
   print wf "$calls\t";
   print wf "$emails\t";
   print wf "0\t";
   print wf "0\t";
   print wf "$web\t";
   print wf "0\t";
   print wf "$yymm\n";
   print "----------------------------------\n";
  } 
 $date = $calls = $emails = $web=""; 
   
 }   
 $sth->finish;   

$z++;
}

close(wf);

$dbh->disconnect;
 
#system("mysqlimport -i thomas Campaign_Daily_Activity.txt");
 

print "\n\Done...\n" 




