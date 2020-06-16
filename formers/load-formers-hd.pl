#!/usr/bin/perl
#
# Load conversions & user sessions for just turned non-adv at headings
# Use lastmod to determine new formers (so run data from 2006) or old formers (only run 2008 data)
# Will have to adjust script each Thomas (position) QUARTER & YEAR.

use DBI;
use POSIX;
require "/usr/wt/trd-reload.ph";

$rdate05 = " '0501','0502','0503','0504','0505','0506','0507','0508','0509','0510','0511','0512' ";
$rdate06 = " '0601','0602','0603','0604','0605','0606','0607','0608','0609','0610','0611','0612' ";
$rdate07 = " '0701','0702','0703','0704','0705','0706','0707','0708','0709','0710','0711','0712' ";
$rdate08 = " '0801','0802','0803','0804','0805','0806','0807','0808','0809','0810','0811','0812' ";
$rdate09 = " '0901','0902','0903','0904','0905','0906','0907','0908','0909','0910','0911','0912' ";
$rdate10 = " '1001','1002','1003','1004','1005','1006','1007','1008','1009','1010','1011','1012' ";
$rdate11 = " '1101','1102','1103','1104','1105','1106','1107','1108','1109','1110','1111','1112' ";
$rdate12 = " '1201','1202','1203','1204','1205','1206','1207','1208','1209','1210','1211','1212' ";
$rdate13 = " '1301','1302','1303','1304','1305','1306','1307','1308','1309','1310','1311','1312' ";
$rdate14 = " '1401','1402','1403','1404','1405','1406','1407','1408','1409','1410','1411','1412' ";
$rdate15 = " '1501','1502','1503','1504','1505','1506','1507','1508','1509','1510','1511','1512' ";
$rdate16 = " '1601','1602','1603','1604','1605','1606','1607','1608','1609','1610','1611','1612' ";
$rdate17 = " '1701','1702','1703','1704','1705','1706','1707','1708','1709','1710','1711','1712' ";
 
# get accounts from formers_main table
$i=0;
$query  = "select acct, lastmod from formers_main ";
#$query .= "limit 5";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $record[$i]  = "$$row[0]:$$row[1]";
  $i++;
 }
$sth->finish;



$outfile = "formers_hd.txt";
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
$j=0;
foreach $record (@record)
{
 ($cid,$lastmod) = split(/\:/,$record);

  # get the account mapping
  $acctmap="";
  $query  = " select dupe from tgrams.main_map where prime=$cid ";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
   {
     $acctmap .= "$$row[0],";
   }
  $acctmap = " $acctmap $cid ";


  if($lastmod eq 0) # only new formers need older data
      {

=for comment
        # get 2006 uses, conv, links & pop @ headings
        $query = "select heading, pop from position06Q1 where acct=$cid and heading>0  and cov='NA' ";
         my $sth = $dbh->prepare($query);
         if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
         while (my $row = $sth->fetchrow_arrayref)
          {
            # $key = date + heading + acct;
            $p{"0601$$row[0]$cid"} = $$row[1];
            $p{"0602$$row[0]$cid"} = $$row[1];
            $p{"0603$$row[0]$cid"} = $$row[1];
          }
         $sth->finish;
        $query = "select heading, pop from position06Q2 where acct=$cid and heading>0  and cov='NA'";
         my $sth = $dbh->prepare($query);
         if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
         while (my $row = $sth->fetchrow_arrayref)
          {
            # $key = date + heading + acct;
            $p{"0604$$row[0]$cid"} = $$row[1];
            $p{"0605$$row[0]$cid"} = $$row[1];
            $p{"0606$$row[0]$cid"} = $$row[1];
          }
         $sth->finish;
        $query = "select heading, pop from position06Q3 where acct=$cid and heading>0  and cov='NA' ";
         my $sth = $dbh->prepare($query);
         if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
         while (my $row = $sth->fetchrow_arrayref)
          {
            # $key = date + heading + acct;
            $p{"0607$$row[0]$cid"} = $$row[1];
            $p{"0608$$row[0]$cid"} = $$row[1];
            $p{"0609$$row[0]$cid"} = $$row[1];
          }
         $sth->finish;
        $query = "select heading, pop from position06Q4 where acct=$cid and heading>0  and cov='NA' ";
         my $sth = $dbh->prepare($query);
         if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
         while (my $row = $sth->fetchrow_arrayref)
          {
            # $key = date + heading + acct;
            $p{"0610$$row[0]$cid"} = $$row[1];
            $p{"0611$$row[0]$cid"} = $$row[1];
            $p{"0612$$row[0]$cid"} = $$row[1];
          }
         $sth->finish;
        $query  = "select date, heading,";
        $query .= "sum( us ) , ";
        $query .= "sum( cd  + ec + em + lw + mi + mt + pc + pv + lc ), ";
        $query .= "sum( lw ) ";
        $query .= "from qlog06Y ";
        $query .= "where acct in ( $acctmap ) and covflag='t' and  date in ($rdate06) ";
        $query .= "group by date, heading ";
        my $sth = $dbh->prepare($query);
        if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
        while (my $row = $sth->fetchrow_arrayref)
          {
           $key = $$row[0] . $$row[1] . $cid;
           print wf "$cid\t$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$p{$key}\n";
          }
         $sth->finish;
         undef (@$p);

        # get 2007 uses, conv, links & pop @ headings
        $query = "select heading, pop from position07Q1 where acct=$cid and heading>0  and cov='NA' ";
         my $sth = $dbh->prepare($query);
         if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
         while (my $row = $sth->fetchrow_arrayref)
          {
            # $key = date + heading + acct;
            $p{"0701$$row[0]$cid"} = $$row[1];
            $p{"0702$$row[0]$cid"} = $$row[1];
            $p{"0703$$row[0]$cid"} = $$row[1];
          }
         $sth->finish;
        $query = "select heading, pop from position07Q2 where acct=$cid and heading>0  and cov='NA'  ";
         my $sth = $dbh->prepare($query);
         if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
         while (my $row = $sth->fetchrow_arrayref)
          {
            # $key = date + heading + acct;
            $p{"0704$$row[0]$cid"} = $$row[1];
            $p{"0705$$row[0]$cid"} = $$row[1];
            $p{"0706$$row[0]$cid"} = $$row[1];
          }
         $sth->finish;
        $query = "select heading, pop from position07Q3 where acct=$cid and heading>0  and cov='NA'  ";
         my $sth = $dbh->prepare($query);
         if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
         while (my $row = $sth->fetchrow_arrayref)
          {
            # $key = date + heading + acct;
            $p{"0707$$row[0]$cid"} = $$row[1];
            $p{"0708$$row[0]$cid"} = $$row[1];
            $p{"0709$$row[0]$cid"} = $$row[1];
          }
         $sth->finish;
        $query = "select heading, pop from position07Q4 where acct=$cid and heading>0  and cov='NA'  ";
         my $sth = $dbh->prepare($query);
         if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
         while (my $row = $sth->fetchrow_arrayref)
          {
            # $key = date + heading + acct;
            $p{"0710$$row[0]$cid"} = $$row[1];
            $p{"0711$$row[0]$cid"} = $$row[1];
            $p{"0712$$row[0]$cid"} = $$row[1];
          }
         $sth->finish;
        $query  = "select date, heading,";
        $query .= "sum( us ) , ";
        $query .= "sum( cd  + ec + em + lw + mi + mt + pc + pv + lc ), ";
        $query .= "sum( lw ) ";
        $query .= "from qlog07Y ";
        $query .= "where acct in ( $acctmap ) and covflag='t' and  date in ($rdate07) ";
        $query .= "group by date, heading ";
        my $sth = $dbh->prepare($query);
        if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
        while (my $row = $sth->fetchrow_arrayref)
          {
           $key = $$row[0] . $$row[1] . $cid;
           print wf "$cid\t$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$p{$key}\n";
          }
         $sth->finish;
         undef (@$p);


     # get 2008 uses, conv, links & pop @ headings
     $query = "select heading, pop from position08Q1 where acct=$cid and heading>0  and cov='NA' ";
     my $sth = $dbh->prepare($query);
     if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
     while (my $row = $sth->fetchrow_arrayref)
      {
        # $key = date + heading + acct;
        $p{"0801$$row[0]$cid"} = $$row[1];
        $p{"0802$$row[0]$cid"} = $$row[1];
        $p{"0803$$row[0]$cid"} = $$row[1];
      }
     $sth->finish;
     $query = "select heading, pop from position08Q2 where acct=$cid and heading>0  and cov='NA'  ";
     my $sth = $dbh->prepare($query);
     if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
     while (my $row = $sth->fetchrow_arrayref)
      {
        # $key = date + heading + acct;
        $p{"0804$$row[0]$cid"} = $$row[1];
        $p{"0805$$row[0]$cid"} = $$row[1];
        $p{"0806$$row[0]$cid"} = $$row[1];
      }
     $sth->finish;
     $query = "select heading, pop from position08Q3 where acct=$cid and heading>0  and cov='NA'  ";
     my $sth = $dbh->prepare($query);
     if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
     while (my $row = $sth->fetchrow_arrayref)
      {
        # $key = date + heading + acct;
        $p{"0807$$row[0]$cid"} = $$row[1];
        $p{"0808$$row[0]$cid"} = $$row[1];
        $p{"0809$$row[0]$cid"} = $$row[1];
      }
     $sth->finish;
     $query = "select heading, pop from position08Q4 where acct=$cid and heading>0  and cov='NA'  ";
     my $sth = $dbh->prepare($query);
     if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
     while (my $row = $sth->fetchrow_arrayref)
      {
        # $key = date + heading + acct;
        $p{"0810$$row[0]$cid"} = $$row[1];
        $p{"0811$$row[0]$cid"} = $$row[1];
        $p{"0812$$row[0]$cid"} = $$row[1];
      }
    $sth->finish;

    $query  = "select date, heading,";
    $query .= "sum( us ) , ";
    $query .= "sum( cd  + ec + em + lw + mi + mt + pc + pv + lc ), ";
    $query .= "sum( lw ) ";
    $query .= "from qlog08Y ";
    $query .= "where acct in ( $acctmap ) and covflag='t' and  date in ($rdate08) ";
    $query .= "group by date, heading ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
      {
        $key = $$row[0] . $$row[1] . $cid;
        print  wf "$cid\t$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$p{$key}\n";
      }
     $sth->finish;
     undef (@$p);



 # get 2009 uses, conv, links & pop @ headings
   $query = "select heading, pop from position09Q1 where acct=$cid and heading>0  and cov='NA' ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
      # $key = date + heading + acct;
      $p{"0901$$row[0]$cid"} = $$row[1];
      $p{"0902$$row[0]$cid"} = $$row[1];
      $p{"0903$$row[0]$cid"} = $$row[1];
    }
   $sth->finish;

   $query = "select heading, pop from position09Q2 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
       # $key = date + heading + acct;
       $p{"0904$$row[0]$cid"} = $$row[1];
       $p{"0905$$row[0]$cid"} = $$row[1];
        $p{"0906$$row[0]$cid"} = $$row[1];
      }
    $sth->finish;


   $query = "select heading, pop from position09Q3 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
    {
       # $key = date + heading + acct;
       $p{"0907$$row[0]$cid"} = $$row[1];
       $p{"0908$$row[0]$cid"} = $$row[1];
       $p{"0909$$row[0]$cid"} = $$row[1];
     }
    $sth->finish;


   $query = "select heading, pop from position09Q4 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
      {
       # $key = date + heading + acct;
       $p{"0910$$row[0]$cid"} = $$row[1];
       $p{"0911$$row[0]$cid"} = $$row[1];
       $p{"0912$$row[0]$cid"} = $$row[1];
     }
     $sth->finish;

  $query  = "select date, heading,";
  $query .= "sum( us ) , ";
  $query .= "sum( cd  + ec + em + lw + mi + mt + pc + pv + lc ), ";
  $query .= "sum( lw ) ";
  $query .= "from qlog09Y ";
  $query .= "where acct in ( $acctmap ) and covflag='t' and  date in ($rdate09) ";
  $query .= "group by date, heading ";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
    {
     $key = $$row[0] . $$row[1] . $cid;
     print  wf "$cid\t$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$p{$key}\n";
    }
   $sth->finish;
   undef (@$p);



 # get 2010 uses, conv, links & pop @ headings
   $query = "select heading, pop from position10Q1 where acct=$cid and heading>0  and cov='NA' ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
      # $key = date + heading + acct;
      $p{"1001$$row[0]$cid"} = $$row[1];
      $p{"1002$$row[0]$cid"} = $$row[1];
      $p{"1003$$row[0]$cid"} = $$row[1];
    }
   $sth->finish;

   $query = "select heading, pop from position10Q2 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
       # $key = date + heading + acct;
       $p{"1004$$row[0]$cid"} = $$row[1];
       $p{"1005$$row[0]$cid"} = $$row[1];
       $p{"1006$$row[0]$cid"} = $$row[1];
      }
    $sth->finish;

   $query = "select heading, pop from position10Q3 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
    {
       # $key = date + heading + acct;
       $p{"1007$$row[0]$cid"} = $$row[1];
       $p{"1008$$row[0]$cid"} = $$row[1];
       $p{"1009$$row[0]$cid"} = $$row[1];
     }
    $sth->finish;

   $query = "select heading, pop from position10Q4 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
      {
       # $key = date + heading + acct;
       $p{"1010$$row[0]$cid"} = $$row[1];
       $p{"1011$$row[0]$cid"} = $$row[1];
       $p{"1012$$row[0]$cid"} = $$row[1];
     }
     $sth->finish;


  $query  = "select date, heading,";
  $query .= "sum( us ) , ";
  $query .= "sum( cd  + ec + em + lw + mi + mt + pc + pv + lc ), ";
  $query .= "sum( lw ) ";
  $query .= "from qlog10Y ";
  $query .= "where acct in ( $acctmap ) and covflag='t' and  date in ($rdate10) ";
  $query .= "group by date, heading ";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
    {
     $key = $$row[0] . $$row[1] . $cid;
     print  wf "$cid\t$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$p{$key}\n";
    }
   $sth->finish;
   undef (@$p);
 


  # get 2011 uses, conv, links & pop @ headings
   $query = "select heading, pop from position11Q1 where acct=$cid and heading>0  and cov='NA' ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
      # $key = date + heading + acct;
      $p{"1101$$row[0]$cid"} = $$row[1];
      $p{"1102$$row[0]$cid"} = $$row[1];
      $p{"1103$$row[0]$cid"} = $$row[1];
    }
   $sth->finish;


   $query = "select heading, pop from position11Q2 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
       # $key = date + heading + acct;
       $p{"1104$$row[0]$cid"} = $$row[1];
       $p{"1105$$row[0]$cid"} = $$row[1];
       $p{"1106$$row[0]$cid"} = $$row[1];
      }
    $sth->finish;


   $query = "select heading, pop from position11Q3 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
    {
       # $key = date + heading + acct;
       $p{"1107$$row[0]$cid"} = $$row[1];
       $p{"1108$$row[0]$cid"} = $$row[1];
       $p{"1109$$row[0]$cid"} = $$row[1];
     }
    $sth->finish;


   $query = "select heading, pop from position11Q4 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
      {
       # $key = date + heading + acct;
       $p{"1110$$row[0]$cid"} = $$row[1];
       $p{"1111$$row[0]$cid"} = $$row[1];
       $p{"1112$$row[0]$cid"} = $$row[1];
     }
     $sth->finish;


  $query  = "select date, heading,";
  $query .= "sum( us ) , ";
  $query .= "sum( cd  + ec + em + lw + mi + mt + pc + pv + lc ), ";
  $query .= "sum( lw ) ";
  $query .= "from qlog11Y ";
  $query .= "where acct in ( $acctmap ) and covflag='t' and  date in ($rdate11) ";
  $query .= "group by date, heading ";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
    {
     $key = $$row[0] . $$row[1] . $cid;
     print  wf "$cid\t$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$p{$key}\n";
    }
   $sth->finish;
   undef (@$p);
 


 # get 2012 uses, conv, links & pop @ headings
   $query = "select heading, pop from position12Q1 where acct=$cid and heading>0  and cov='NA' ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
      # $key = date + heading + acct;
      $p{"1201$$row[0]$cid"} = $$row[1];
      $p{"1202$$row[0]$cid"} = $$row[1];
      $p{"1203$$row[0]$cid"} = $$row[1];
    }
   $sth->finish;


   $query = "select heading, pop from position12Q2 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
       # $key = date + heading + acct;
       $p{"1204$$row[0]$cid"} = $$row[1];
       $p{"1205$$row[0]$cid"} = $$row[1];
       $p{"1206$$row[0]$cid"} = $$row[1];
      }
    $sth->finish;


   $query = "select heading, pop from position12Q3 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
    {
       # $key = date + heading + acct;
       $p{"1207$$row[0]$cid"} = $$row[1];
       $p{"1208$$row[0]$cid"} = $$row[1];
       $p{"1209$$row[0]$cid"} = $$row[1];
     }
    $sth->finish;


   $query = "select heading, pop from position12Q4 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
      {
       # $key = date + heading + acct;
       $p{"1210$$row[0]$cid"} = $$row[1];
       $p{"1211$$row[0]$cid"} = $$row[1];
       $p{"1212$$row[0]$cid"} = $$row[1];
     }
     $sth->finish;


 $query  = "select date, heading,";
  $query .= "sum( us ) , ";
  $query .= "sum( cd  + ec + em + lw + mi + mt + pc + pv + lc + vv + dv + iv + sm + pp + mv), ";
  $query .= "sum( lw ) ";
  $query .= "from qlog12Y ";
  $query .= "where acct in ( $acctmap ) and covflag='t' and  date in ($rdate12) ";
  $query .= "group by date, heading ";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
    {
     $key = $$row[0] . $$row[1] . $cid;
     print  wf "$cid\t$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$p{$key}\n";
    }
   $sth->finish;
   undef (@$p);

=cut

 # get 2013 uses, conv, links & pop @ headings
   $query = "select heading, pop from position13Q1 where acct=$cid and heading>0  and cov='NA' ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
      # $key = date + heading + acct;
      $p{"1301$$row[0]$cid"} = $$row[1];
      $p{"1302$$row[0]$cid"} = $$row[1];
      $p{"1303$$row[0]$cid"} = $$row[1];
    }
   $sth->finish;

   $query = "select heading, pop from position13Q2 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
       # $key = date + heading + acct;
       $p{"1304$$row[0]$cid"} = $$row[1];
       $p{"1305$$row[0]$cid"} = $$row[1];
       $p{"1306$$row[0]$cid"} = $$row[1];
      }
    $sth->finish;

   $query = "select heading, pop from position13Q3 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
    {
       # $key = date + heading + acct;
       $p{"1307$$row[0]$cid"} = $$row[1];
       $p{"1308$$row[0]$cid"} = $$row[1];
       $p{"1309$$row[0]$cid"} = $$row[1];
     }
    $sth->finish;

   $query = "select heading, pop from position13Q4 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
      {
       # $key = date + heading + acct;
       $p{"1310$$row[0]$cid"} = $$row[1];
       $p{"1311$$row[0]$cid"} = $$row[1];
       $p{"1312$$row[0]$cid"} = $$row[1];
     }
     $sth->finish;


  $query  = "select date, heading,";
  $query .= "sum( us ) , ";
  $query .= "sum( cd  + ec + em + lw + mi + mt + pc + pv + lc + vv + dv + iv + sm + pp + mv), ";
  $query .= "sum( lw ) ";
  $query .= "from qlog13Y ";
  $query .= "where acct in ( $acctmap ) and covflag='t' and  date in ($rdate13) ";
  $query .= "group by date, heading ";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
    {
     $key = $$row[0] . $$row[1] . $cid;
     print  wf "$cid\t$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$p{$key}\n";
    }
   $sth->finish;
   undef (@$p);

 # get 2014 uses, conv, links & pop @ headings
   $query = "select heading, pop from position14Q1 where acct=$cid and heading>0  and cov='NA' ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
      # $key = date + heading + acct;
      $p{"1401$$row[0]$cid"} = $$row[1];
      $p{"1402$$row[0]$cid"} = $$row[1];
      $p{"1403$$row[0]$cid"} = $$row[1];
    }
   $sth->finish;

   $query = "select heading, pop from position14Q2 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
       # $key = date + heading + acct;
       $p{"1404$$row[0]$cid"} = $$row[1];
       $p{"1405$$row[0]$cid"} = $$row[1];
       $p{"1406$$row[0]$cid"} = $$row[1];
      }
    $sth->finish;


   $query = "select heading, pop from position14Q3 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
    {
       # $key = date + heading + acct;
       $p{"1407$$row[0]$cid"} = $$row[1];
       $p{"1408$$row[0]$cid"} = $$row[1];
       $p{"1409$$row[0]$cid"} = $$row[1];
     }
    $sth->finish;

   $query = "select heading, pop from position14Q4 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
      {
       # $key = date + heading + acct;
       $p{"1410$$row[0]$cid"} = $$row[1];
       $p{"13411$$row[0]$cid"} = $$row[1];
       $p{"1412$$row[0]$cid"} = $$row[1];
     }
     $sth->finish;

 
  $query  = "select date, heading,";
  $query .= "sum( us ) , ";
  $query .= "sum( cd  + ec + em + lw + mi + mt + pc + pv + lc + vv + dv + iv + sm + pp + mv), ";
  $query .= "sum( lw ) ";
  $query .= "from qlog14Y ";
  $query .= "where acct in ( $acctmap ) and covflag='t' and  date in ($rdate14) ";
  $query .= "group by date, heading ";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
    {
     $key = $$row[0] . $$row[1] . $cid;
     print  wf "$cid\t$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$p{$key}\n";
    }
   $sth->finish;
  undef (@$p);

   $query = "select heading, pop from position15Q1 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     { 
       # $key = date + heading + acct;
       $p{"1501$$row[0]$cid"} = $$row[1];
       $p{"1502$$row[0]$cid"} = $$row[1];
       $p{"1503$$row[0]$cid"} = $$row[1];
      }
    $sth->finish;
 

   $query = "select heading, pop from position15Q2 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
       # $key = date + heading + acct;
       $p{"1504$$row[0]$cid"} = $$row[1];
       $p{"1505$$row[0]$cid"} = $$row[1];
       $p{"1506$$row[0]$cid"} = $$row[1];
      }
    $sth->finish;
 
   $query = "select heading, pop from position15Q3 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
    {
       # $key = date + heading + acct;
       $p{"1507$$row[0]$cid"} = $$row[1];
       $p{"1508$$row[0]$cid"} = $$row[1];
       $p{"1509$$row[0]$cid"} = $$row[1];
     }
    $sth->finish;

   $query = "select heading, pop from position15Q4 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
      {
       # $key = date + heading + acct;
       $p{"1510$$row[0]$cid"} = $$row[1];
       $p{"1511$$row[0]$cid"} = $$row[1];
       $p{"1512$$row[0]$cid"} = $$row[1];
     }
     $sth->finish;


  $query  = "select date, heading,";
  $query .= "sum( us ) , ";
  $query .= "sum( cd  + ec + em + lw + mi + mt + pc + pv + lc + vv + dv + iv + sm + pp + mv), ";
  $query .= "sum( lw ) ";
  $query .= "from qlog15Y ";
  $query .= "where acct in ( $acctmap ) and covflag='t' and  date in ($rdate15) ";
  $query .= "group by date, heading ";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
    {
     $key = $$row[0] . $$row[1] . $cid;
     print  wf "$cid\t$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$p{$key}\n";
    }
   $sth->finish; 
   undef (@$p);
    
   
   
   
     
## get 2016 uses, conv, links & pop @ headings
  
   $query = "select heading, pop from position16Q1 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     { 
       # $key = date + heading + acct;
       $p{"1601$$row[0]$cid"} = $$row[1];
       $p{"1602$$row[0]$cid"} = $$row[1];
       $p{"1603$$row[0]$cid"} = $$row[1];
      }
    $sth->finish;
 

   $query = "select heading, pop from position16Q2 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
       # $key = date + heading + acct;
       $p{"1604$$row[0]$cid"} = $$row[1];
       $p{"1605$$row[0]$cid"} = $$row[1];
       $p{"1606$$row[0]$cid"} = $$row[1];
      }
    $sth->finish;


   $query = "select heading, pop from position16Q3 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
    {
       # $key = date + heading + acct;
       $p{"1607$$row[0]$cid"} = $$row[1];
       $p{"1608$$row[0]$cid"} = $$row[1];
       $p{"1609$$row[0]$cid"} = $$row[1];
     }
    $sth->finish;



   $query = "select heading, pop from position16Q4 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
      {
       # $key = date + heading + acct;
       $p{"1610$$row[0]$cid"} = $$row[1];
       $p{"1611$$row[0]$cid"} = $$row[1];
       $p{"1612$$row[0]$cid"} = $$row[1];
     }
     $sth->finish;     
 
  $query  = "select date, heading,";
  $query .= "sum( us ) , ";
  $query .= "sum( cd  + ec + em + lw + mi + mt + pc + pv + lc + vv + dv + iv + sm + pp + mv), ";
  $query .= "sum( lw ) ";
  $query .= "from qlog16Y ";
  $query .= "where acct in ( $acctmap ) and covflag='t' and  date in ($rdate16) ";
  $query .= "group by date, heading ";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
    {
     $key = $$row[0] . $$row[1] . $cid;
     print  wf "$cid\t$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$p{$key}\n";
    }
   $sth->finish;
   undef (@$p);  
   
   
###### open up ad new rank becomes live #######

## get 2017 uses, conv, links & pop @ headings

   $query = "select heading, pop from position17Q1 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
       # $key = date + heading + acct;
       $p{"1701$$row[0]$cid"} = $$row[1];
       $p{"1702$$row[0]$cid"} = $$row[1];
       $p{"1703$$row[0]$cid"} = $$row[1];
      }
    $sth->finish;


   $query = "select heading, pop from position17Q2 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
       # $key = date + heading + acct;
       $p{"1704$$row[0]$cid"} = $$row[1];
       $p{"1705$$row[0]$cid"} = $$row[1];
       $p{"1706$$row[0]$cid"} = $$row[1];
      }
    $sth->finish;
    

    $query = "select heading, pop from position17Q3 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
    {
       # $key = date + heading + acct;
       $p{"1707$$row[0]$cid"} = $$row[1];
       $p{"1708$$row[0]$cid"} = $$row[1];
       $p{"1709$$row[0]$cid"} = $$row[1];
     }
    $sth->finish;


   $query = "select heading, pop from position17Q4 where acct=$cid and heading>0  and cov='NA'  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
      {
       # $key = date + heading + acct;
       $p{"1710$$row[0]$cid"} = $$row[1];
       $p{"1711$$row[0]$cid"} = $$row[1];
       $p{"1712$$row[0]$cid"} = $$row[1];
     }
     $sth->finish;

=for comment    
=cut   

  $query  = "select date, heading,";
  $query .= "sum( us ) , ";
  $query .= "sum( cd  + ec + em + lw + mi + mt + pc + pv + lc + vv + dv + iv + sm + pp + mv), ";
  $query .= "sum( lw ) ";
  $query .= "from qlog17Y ";
  $query .= "where acct in ( $acctmap ) and covflag='t' and  date in ($rdate17) ";
  $query .= "group by date, heading ";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
    {
     $key = $$row[0] . $$row[1] . $cid;
     print  wf "$cid\t$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$p{$key}\n";
    }
   $sth->finish;
   undef (@$p);  

 } # bottom of lastmod check

   $j++;
}

close(wf);

system("mysqlimport -rL thomas $DIR/formers/$outfile");

$dbh->disconnect;



=for comment
CREATE TABLE formers_hd (
  acct bigint(20) NOT NULL default '0',
  yymm int(4) NOT NULL default '0',
  heading bigint(20) NOT NULL default '0',
  us int(11) NOT NULL default '0',
  conv int(11) NOT NULL default '0',
  links int(11) NOT NULL default '0',
  pop int(11) NOT NULL default '0',
  PRIMARY KEY  (acct,yymm,heading)
) TYPE=MyISAM;
=cut

