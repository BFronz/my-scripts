#!/usr/bin/perl
#
#
# Creates Advertiser Contact Conversions Report to be posted in on admin.tnt.com
# Run once a month after data had been QC'ed

 
if($ARGV[0]  eq "") {print "\nMissing report date YYMM \n\n";  exit;}
$rdate     = $ARGV[0]; # report date YYMM
$yy        = substr($rdate, 0, 2);
$mm        = substr($rdate, 2, 2);   
#$limit    = 10; # for testing 
$limit     = 1000000;  
$rptdate   = "Report: " . $mm . "/" . "20" . $yy;
$outfile   = "accr_rpt_new_" . $rdate   .  ".txt";
$rlpgm[1]  = "RLocal";
$estpgm[1] = "eStara";
$j         = 1;

use DBI;
use POSIX;
$dbh = DBI->connect("", "", "");
 
           
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
print wf "$rptdate\n";
 
print wf "Company Name - acct#\tProgram\tInternet Dollars before Credits\tTotal Contract Dollars\tCalls from tnet Listings\tEmails from tnet\t";
print wf "Calls from Website\tEmails From Website\tWeb Forms Submitted\tTotal Contacts\tWebsite Calls Connected\tNo Answer\tBusy\t";
print wf "Abandoned\t% Connected\t% No Answer\t% Busy\t% Abandoned\tSum of Calls (hh:mm:ss)\tAvg. Call (mm:ss)\t";
print wf "Listing Calls Connected\tNo Answer\tBusy\tAbandoned\t% Connected\t% No Answer\t% Busy\t% Abandoned\t";
print wf "Sum of Calls (hh:mm:ss)\tAvg. Call (mm:ss)\tVisits to Websites\tWeb Forms Views\tWeb Forms Submitted\t";
print wf "%Web Forms Submitted\ttnet User Sessions\tAdv. Website Conversion / Visits\tConversions / Session\t(Dollars/12)  /Total contacts\n";
 
print wf "Data Source\tCMG\tCMG\tCMG\teStara/ATG\tCMG\tReachLocal\tReachLocal\tReachLocal\tCalculation\tReachLocal\tReachLocal\tReachLocal\t";
print wf "ReachLocal\tReachLocal\tReachLocal\tReachLocal\tReachLocal\tReachLocal\tReachLocal\teStara/ATG\teStara/ATG\t";
print wf "eStara/ATG\teStara/ATG\teStara/ATG\teStara/ATG\teStara/ATG\teStara/ATG\teStara/ATG\teStara/ATG\tReachLocal\t";
print wf "ReachLocal\tReachLocal\tCalculated\tCMG All Traffic Report\tCalculated\tCalculated\tCalculated\n";

$i=0;  
$query  = "SELECT *  FROM thomaccr WHERE rdate='$rdate' ORDER BY company  ";
$query .= " LIMIT $limit ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {  
   #rdate                 = $$row[0];
   #acct                  = $$row[1];
   #company               = $$row[2];
   #internet_dollars      = $$row[3];
   #total_dollars         = $$row[4];
   #estara_calls_conn     = $$row[5];
   #tnet_email            = $$row[6];
   #rl_calls              = $$row[7];
   #rl_emails             = $$row[8];
   #rl_webevents          = $$row[9];
   #total_contacts        = $$row[10];
   #rl_connected          = $$row[11];
   #rl_noanswer           = $$row[12];
   #rl_busy               = $$row[13];
   #rl_abandoned          = $$row[14];
   #rl_connected_pc       = $$row[15];
   #rl_noanswer_pc        = $$row[16];
   #rl_busy_pc            = $$row[17];
   #rl_abandoned_pc       = $$row[18];
   #rl_dur                = $$row[19];
   #rl_avecall            = $$row[20];
   #estara_calls_conn2    = $$row[21];
   #estara_no_ans         = $$row[22];
   #estara_busy           = $$row[23];
   #estara_abandoned      = $$row[24];
   #estara_connected_pc   = $$row[25];
   #estara_noanswer_pc    = $$row[26];
   #estara_busy_pc        = $$row[27];
   #estara_abandoned_pc   = $$row[28];
   #estara_dur            = $$row[29];
   #estara_avecall        = $$row[30];
   #rl_visits             = $$row[31];
   #rl_web_form_views     = $$row[32];
   #rl_websubmit          = $$row[33];
   #rl_websubmit_pc       = $$row[34];
   #tnet_user_ses         = $$row[35];
   #advwebsite_con_visits = $$row[36];
   #conversions_session   = $$row[37];
   #dollar_total_contacts = $$row[38];
 
   $query  = "SELECT sum(if(rlocal='Y', 1,0)) AS rlocal, sum(if(estara='Y', 1,0)) AS estara ";
   $query .= "FROM thomaccr_accts WHERE acct=$$row[1] AND  rdate='$rdate'  GROUP BY acct";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   if (my $row = $sth->fetchrow_arrayref)
    {
     $program = "$rlpgm[$$row[0]] $estpgm[$$row[1]]";
    }
   $sth->finish; 
 
  print wf "$$row[2] - $$row[1]\t$program\t$$row[3]\t$$row[4]\t$$row[5]\t$$row[6]\t$$row[7]\t$$row[8]\t$$row[9]\t$$row[10]\t";
  print wf "$$row[11]\t$$row[12]\t$$row[13]\t$$row[14]\t$$row[15]\t$$row[16]\t$$row[17]\t$$row[18]\t$$row[19]\t$$row[20]\t";
  print wf "$$row[21]\t$$row[22]\t$$row[23]\t$$row[24]\t$$row[25]\t$$row[26]\t$$row[27]\t$$row[28]\t$$row[29]\t$$row[30]\t";
  print wf "$$row[31]\t$$row[32]\t$$row[33]\t$$row[34]\t$$row[35]\t$$row[36]\t$$row[37]\t$$row[38]\n";
  $program = "";
 }
$sth->finish;

close(wf);

$dbh->disconnect;


