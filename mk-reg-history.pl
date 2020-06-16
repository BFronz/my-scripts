#!/usr/bin/perl
#

$fdate   = $ARGV[0];
$outfile = "mt_profile_history.txt";
$yy      =  substr($fdate, 0, 2);             

use DBI;
require "/usr/wt/trd-reload.ph";

$query  = " select trim(tinid) ";
$query .= " from thomtnetlogREG$yy ";
$query .= " where date='$fdate' and  length(tinid) < 32 group by tinid ";

$rec=0;
$i=0;
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
  {
   $record[$i]=$$row[0];
   $cookie{$$row[0]}=$$row[0];
   $i++;      
   $rec++;
  }
$sth->finish;
#$rc = $dbh->disconnect;


$query  = " select trim(tinid) ";
$query .= " from thomtnetlogREGCAT$yy ";
$query .= " where date='$fdate' and  length(tinid) < 32 group by tinid ";

my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
  {
   if($cookie{$$row[0]} eq "")
    {
     $record[$i]=$$row[0];
     $i++;      
     $rec++;
    }
  }
$sth->finish;


print "\nCookies $rec \n";



# Run through each record checking the TR and TRD tables for records. If found write out. TR first then TRD
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
foreach $record (@record)
 { 
  $record =~ s/\s//g;
  #print "$record\n";
     
  # Check TR registry. Need to split member_name into fname and lname if found                   
  $trq    = " select member_id,password,trim(user_id),email,member_name,'',title,company,department,industry,job,address_1,address_2,city, state,";
  $trq    .= " country,zip,phone,fax,create_date,'','','','TR','',''  from  thomtrregistry where user_id='$record' order by create_date  limit 1 ";
  my $sth = $dbh->prepare($trq);                                 
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  if (my $row = $sth->fetchrow_arrayref)
     {
      @mn           = split(/\s/,$$row[4]);
      $mn[0]        =~ s/\s+$//;
      $mn[1]        =~ s/^\s+//;
      $mn[0]        =~ s/\s+$//;
      $mn[0]        =~ s/^\s+//;
      # print "$trq\n\n";
 
      print wf "$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$mn[0]\t$mn[1]\t$$row[6]\t$$row[7]\t$$row[8]\t$$row[9]\t$$row[10]\t";
      print wf "$$row[11]\t$$row[12]\t$$row[13]\t$$row[14]\t$$row[15]\t$$row[16]\t$$row[17]\t$$row[18]\t$$row[19]\t$$row[20]\t$$row[21]\t$$row[22]\t$$row[23]\t$$row[24]\t$$row[25]\n";
      $found=1; 
 
      undef($mn);      

     } 
    $sth->finish;


  # Check TRD registry if not found in TR
  if($found eq "") 
   {
    $trdq  = " select uid,passwd,trim(cookie),email,fname,lname,title,company,department,activity,role,addr1,addr2,city,state,";
    $trdq .= " country,zip,phone,fax,created,'',lastlogin,'','TRD','','' from  thomregistry where cookie='$record' order by created desc limit 1 "; 

    my $sth = $dbh->prepare($trdq);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    if (my $row = $sth->fetchrow_arrayref)
      { 
       print wf "$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$$row[5]\t$$row[6]\t$$row[7]\t$$row[8]\t$$row[9]\t$$row[10]\t";
       print wf "$$row[11]\t$$row[12]\t$$row[13]\t$$row[14]\t$$row[15]\t$$row[16]\t$$row[17]\t$$row[18]\t$$row[19]\t$$row[20]\t$$row[21]\t$$row[22]\t$$row[23]\t$$row[24]\t$$row[25]\n"; 
      } 
     $sth->finish;
    } 

   $found=""; 

  }  
close(wf);

$rc = $dbh->disconnect;
 
system("mysqlimport -iL tgrams $DIR/$outfile"); 
 
