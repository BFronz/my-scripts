#!/usr/bin/perl
#
#  
# Run this second
# inserts missing records
# change date
# check output then
# mysql thomas < Campaign_Daily_Activity_update.txt


  
$fdate = " '1203' ";
#$fdate = " '1201','1202','1203','1204','1205','1206','1207','1208','1209','1210','1211','1212'  ";
 
use DBI;
$dbh      = DBI->connect("", "", "");
                           
open(wf,  ">Campaign_Daily_Activity_update.txt")  || die (print "Could not open Campaign_Daily_Activity_update.txt\n");

$query = " select  distinct(adv_code)  from Campaign_Daily_Activity where  date in ($fdate) and adv_code>0   ";
#$query = " select  distinct(adv_code)  from Campaign_Daily_Activity where  date in ($fdate) and adv_code=1282676   ";
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
        
 $q  = " select substring(report_date, 1, 10) as report_date, visits, calls, emails, web_events ";
 $q .= " from thomCampaign_Daily_Activity where ";
 $q .= " adv_code=$account and date in ($fdate) order by report_date asc"; 
 #print "\n\n$q\n\n";
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {      
   $date    = $$row[0];
   $visits  = $$row[1];
   $calls   = $$row[2];
   $emails  = $$row[3];
   $web     = $$row[4]; 

  #  print "live: $date\t$calls\t$emails\t$web\n";
                
  $subq = "select substring(report_date, 1, 10), sum(if(event_type_name='Call',1,0)) as calls, sum(if(event_type_name='Email',1,0)) as emails, sum(if(event_type_name='Web_Event',1,0)) as web_events ";
  $subq .= "from thomCampaign_Event_Detail_v2 "; 
  $subq .= "where  adv_code =$account and substring(report_date, 1, 10)='$date'   group by adv_code";
  #print "\n\n$subq\n\n";
  my $subr = $dbh->prepare($subq);
  if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
  while (my $srow = $subr->fetchrow_arrayref)
   { 
     $dateu   = $$srow[0];
     $callsu  = $$srow[1];
     $emailsu = $$srow[2];
     $webu    = $$srow[3];
 
    if($callsu ne $calls ||  $emailsu ne $emails || $webu ne $web)
    {   
     print "live  : $date\t$calls\t$emails\t$web\n";
     print "update: $dateu\t$callsu\t$emailsu\t$webu\n";  

     print wf "update  thomCampaign_Daily_Activity set ";
     print wf "calls='$callsu',  emails='$emailsu', web_events='$webu' "; 
     print wf "where adv_code =$account and  substring(report_date, 1, 10)='$date';\n";
     print "\n----------------------------------\n";
    } 
   }
  $subr->finish; 
 

   $dateu= $callsu = $emailsu = $webu ="";
  
 }    
 $sth->finish;   

$z++;
}

close(wf);

$dbh->disconnect;

print "\n\Done...\n" 




