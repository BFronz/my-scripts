#!/usr/bin/perl 
#                   
# Get data based on Jobs obtained in get-jobid.pl
# Wait a while before running this, if not jobs may fail.
# Also retrieves audio files based on new links in table. 

$datapath="/home/tnet/src/reachlocal/data"; 
  
use DBI;
$data_source = "dbi:mysql:thomas:";
$user = "";
$auth = "";
$dbh  = DBI->connect($data_source, $user, $auth);
 
   
get_data("Campaign_Summary_Activity","Campaign_Daily_Activity","Campaign_Event_Detail_v2","Advertiser_Summary_Activity");
 
sub get_data {
 $i   = 1;
 $UID = "PDaloisio\@tnt.com";
 $PW  = "045f9b825e0cc449";
 foreach (@_) 
  { 
   print "$_\t";    
   $readfile = "$datapath/$_" . "_ID.txt";      
   $USERJOB = "cmgtest" . $i;
   $FILE     = "$datapath/$_" . ".txt";

   $URL   = "http://report.reachlocal.com/report/download/?";
   $URL  .= "login_id=$UID&api_key=$PW";
   $URL  .= "&job_name=$USERJOB";

   open (rf,  "$readfile")   || die (print "Could not open readfile: $readfile\n");
   while (!eof(rf))
    {
      $jobid = <rf>;
      chop($jobid);
      if($jobid =~ /Ok: jobid=/ )
       {
        $jobid =~ s/Ok: jobid=//g;
        $cmd = "wget --no-check-certificate --tries=1  \"$URL\" -O $FILE";  
        system("$cmd");
      }
      else { print  "\n\n!Problem with Job! \t $_ \t $jobid\n\n";  }
   }
   close(rf);
 
   $i++;
   sleep 5;
  }
}

 
# process text files 
if (-s "$datapath/Campaign_Summary_Activity.txt" > 60) { system("mysqlimport -rL thomas $datapath/Campaign_Summary_Activity.txt"); }

if (-s "$datapath/Campaign_Daily_Activity.txt" > 60) 
  { 
   system("mysqlimport -rL thomas $datapath/Campaign_Daily_Activity.txt"); 

   $query = "UPDATE thomCampaign_Daily_Activity SET  date=CONCAT(SUBSTRING(report_date,3,2),SUBSTRING(report_date,6,2)) WHERE date='' ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
   $sth->finish;
  }

if (-s "$datapath/Advertiser_Summary_Activity.txt" > 60) { system("mysqlimport -rL thomas $datapath/Advertiser_Summary_Activity.txt"); }
 
# Log file (so no -r) here, make sure not to dupe records
if (-s "$datapath/Campaign_Event_Detail_v2.txt" > 60)  
 {  
  system("mysqlimport -rL thomas $datapath/Campaign_Event_Detail_v2.txt"); 
 
  $query = "UPDATE thomCampaign_Event_Detail_v2 SET date=CONCAT(SUBSTRING(report_date,3,2),SUBSTRING(report_date,6,2)) WHERE date='' AND  report_date!=0 ";
  my $sth = $dbh->prepare($query);                      
  if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
  $sth->finish;
 } 


$dbh->disconnect;
  
if($ERR > 0) {
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year    = "20" . sprintf("%02d", $year % 100);
$mon    += 1;
$month   = sprintf("%02d", $mon % 100);
$day     = sprintf("%02d", $mday % 100);
$to      = $FROM = "robertf\@c.net";
$SUBJECT =  "NOTE: rlocal-flag-ip.pl MISSING KEYS";
#$cc     = "robertf\@c.net";
#open(SENDMAIL, "|/usr/sbin/sendmail -oi -t -f $FROM") or die "Can't fork for sendmail: $!\n";
#print SENDMAIL "To:  $to\n";
#print SENDMAIL "Subject:  $SUBJECT\n";
#if($cc) { print SENDMAIL "CC: $cc\n"; }
#print SENDMAIL "X-Mailer: CMG Targeted Email, Administration, $tag\n";
#print SENDMAIL "\n";
#print SENDMAIL "Finished $mday/$mon/$year  $hour:$min:$sec\n";
#print SENDMAIL "\n";
#close(SENDMAIL) or warn "sendmail didn't close nicely\n";
}

