#!/usr/bin/perl
#
# Load conversions & user sessions for just turned non-adv
# Use lastmod to determine new formers (so run data from 2006) or old formers (only run 2008 data)
# Will have to adjust script each YEAR


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
    
# get accounts from formers_main table
$i=0;
$query  = "select acct, lastmod from formers_main ";
#$query .= "where acct in (96416,1157100)";
#$query .= "limit 5";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $record[$i] = "$$row[0]:$$row[1]";
  $i++;
 }
$sth->finish;

$outfile = "formers_total.txt";
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

=for comment
  if($lastmod eq 0) # only new formers need older data
      {
       # get 2006 uses, conv & links
       $query  = "select date, ";
       $query .= "sum(storyviews + ecomp + estory + press + linksweb), ";
       $query .= "sum(linksweb)  ";
       $query .= "from thomtnetlogPNN06 where acct in ( $acctmap )   ";
       $query .= "and date in ($rdate06) ";
       $query .= "group by date  ";
       my $sth = $dbh->prepare($query);
       if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
       while (my $row = $sth->fetchrow_arrayref)
        {
         $newsc{$$row[0]} = $$row[1];
         $newsl{$$row[0]} = $$row[2];
        }
       $sth->finish;
      $query  = "select date, ";
      $query .= "sum( us ), ";
      $query .= "sum( pv + pc + ln + mi + ec + mt + ca + cl + cv + cd + lc ), ";
      $query .= "sum( ln )  ";
      $query .= "from tnetlogARTU06 ";
      $query .= "where acct in ( $acctmap ) and covflag='t' ";
      $query .= "and date in ($rdate06) ";
      $query .= "group by date ";
      my $sth = $dbh->prepare($query);
      if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
      while (my $row = $sth->fetchrow_arrayref)
        {
         $uses{$$row[0]} = $$row[1];
         $conv{$$row[0]} = $$row[2];
         $link{$$row[0]} = $$row[3];

         $conv{$$row[0]} += $newsc{$$row[0]};
         $link{$$row[0]} += $newsl{$$row[0]};
         print wf "$cid\t$$row[0]\t$uses{$$row[0]}\t$conv{$$row[0]}\t$link{$$row[0]}\n";
         $uses{$$row[0]} = $conv{$$row[0]} = $link{$$row[0]} = $newsc{$$row[0]} = $newsl{$$row[0]} = "";
        } 
       $sth->finish;


      # get 2007 uses, conv & links
      $query  = "select date, ";
      $query .= "sum(storyviews + ecomp + estory + press + linksweb), ";
      $query .= "sum(linksweb)  ";
      $query .= "from thomtnetlogPNN07 where acct in ( $acctmap )   ";
      $query .= "and date in ($rdate07) ";
      $query .= "group by date  ";
      my $sth = $dbh->prepare($query);
      if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
      while (my $row = $sth->fetchrow_arrayref)
        {
         $newsc{$$row[0]} = $$row[1];
         $newsl{$$row[0]} = $$row[2];
        }
       $sth->finish;
      $query  = "select date, ";
      $query .= "sum( us ), ";
      $query .= "sum( pv + pc + ln + mi + ec + mt + ca + cl + cv + cd + lc ), ";
      $query .= "sum( ln )  ";
      $query .= "from tnetlogARTU07 ";
      $query .= "where acct in ( $acctmap ) and covflag='t' ";
      $query .= "and date in ($rdate07) ";
      $query .= "group by date ";
      my $sth = $dbh->prepare($query);
      if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
      while (my $row = $sth->fetchrow_arrayref)
        {
         $uses{$$row[0]} = $$row[1];
         $conv{$$row[0]} = $$row[2];
         $link{$$row[0]} = $$row[3];

         $conv{$$row[0]} += $newsc{$$row[0]};
         $link{$$row[0]} += $newsl{$$row[0]};
         print wf "$cid\t$$row[0]\t$uses{$$row[0]}\t$conv{$$row[0]}\t$link{$$row[0]}\n";
         $uses{$$row[0]} = $conv{$$row[0]} = $link{$$row[0]} = $newsc{$$row[0]} = $newsl{$$row[0]} = "";
        } 
       $sth->finish;
      
   
    # get 2008 uses, conv & links
    $query  = "select date, ";
    $query .= "sum(storyviews + ecomp + estory + press + linksweb), ";
    $query .= "sum(linksweb)  ";
    $query .= "from thomtnetlogPNN08 where acct in ( $acctmap )   ";
    $query .= "and date in ($rdate08) ";
    $query .= "group by date  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
      $newsc{$$row[0]} = $$row[1];
      $newsl{$$row[0]} = $$row[2];
     }
    $sth->finish;
    $query  = "select date, ";
    $query .= "sum( us ), ";
    $query .= "sum( pv + pc + ln + mi + ec + mt + ca + cl + cv + cd + lc ), ";
    $query .= "sum( ln )  ";
    $query .= "from tnetlogARTU08 ";
    $query .= "where acct in ( $acctmap ) and covflag='t' ";
    $query .= "and date in ($rdate08) ";
    $query .= "group by date ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
      $uses{$$row[0]} = $$row[1];
      $conv{$$row[0]} = $$row[2];
      $link{$$row[0]} = $$row[3];
  
      $conv{$$row[0]} += $newsc{$$row[0]};
      $link{$$row[0]} += $newsl{$$row[0]};
      print wf  "$cid\t$$row[0]\t$uses{$$row[0]}\t$conv{$$row[0]}\t$link{$$row[0]}\n";
      $uses{$$row[0]} = $conv{$$row[0]} = $link{$$row[0]} = $newsc{$$row[0]} = $newsl{$$row[0]} = "";
     }  
    $sth->finish;
  
  } # bottom of lastmond check 



  # get 2009 uses, conv & links
  $query  = "select date, ";
  $query .= "sum(storyviews + ecomp + estory + press + linksweb), ";
  $query .= "sum(linksweb)  ";
  $query .= "from thomtnetlogPNN09 where acct in ( $acctmap )   ";
  $query .= "and date in ($rdate09) ";
  $query .= "group by date  ";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
    {
     $newsc{$$row[0]} = $$row[1];
     $newsl{$$row[0]} = $$row[2];
    }
   $sth->finish;
  $query  = "select date, ";
  $query .= "sum( us ), ";
  $query .= "sum( pv + pc + ln + mi + ec + mt + ca + cl + cv + cd + lc ), ";
  $query .= "sum( ln )  ";
  $query .= "from tnetlogARTU09 ";
  $query .= "where acct in ( $acctmap ) and covflag='t' ";
  $query .= "and date in ($rdate09) ";
  $query .= "group by date ";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
    {
     $uses{$$row[0]} = $$row[1];
     $conv{$$row[0]} = $$row[2];
     $link{$$row[0]} = $$row[3];
  
     $conv{$$row[0]} += $newsc{$$row[0]};
     $link{$$row[0]} += $newsl{$$row[0]};
     print wf  "$cid\t$$row[0]\t$uses{$$row[0]}\t$conv{$$row[0]}\t$link{$$row[0]}\n";
     $uses{$$row[0]} = $conv{$$row[0]} = $link{$$row[0]} = $newsc{$$row[0]} = $newsl{$$row[0]} = "";
    }  
   $sth->finish;


 
    # get 2010 uses, conv & links
    $query  = "select date, ";
    $query .= "sum(storyviews + ecomp + estory + press + linksweb), ";
    $query .= "sum(linksweb)  ";
    $query .= "from thomtnetlogPNN10 where acct in ( $acctmap )   ";
    $query .= "and date in ($rdate10) ";
    $query .= "group by date  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
      $newsc{$$row[0]} = $$row[1];
      $newsl{$$row[0]} = $$row[2];
     }
    $sth->finish;
    $query  = "select date, ";
    $query .= "sum( us ), ";
    $query .= "sum( pv + pc + ln + mi + ec + mt + ca + cl + cv + cd + lc ), ";
    $query .= "sum( ln )  ";
    $query .= "from tnetlogARTU10 ";
    $query .= "where acct in ( $acctmap ) and covflag='t' ";
    $query .= "and date in ($rdate10) ";
    $query .= "group by date ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
      $uses{$$row[0]} = $$row[1];
      $conv{$$row[0]} = $$row[2];
      $link{$$row[0]} = $$row[3];

      $conv{$$row[0]} += $newsc{$$row[0]};
      $link{$$row[0]} += $newsl{$$row[0]};
      print wf  "$cid\t$$row[0]\t$uses{$$row[0]}\t$conv{$$row[0]}\t$link{$$row[0]}\n";
      $uses{$$row[0]} = $conv{$$row[0]} = $link{$$row[0]} = $newsc{$$row[0]} = $newsl{$$row[0]} = "";
     }
    $sth->finish;
 


    # get 2011 uses, conv & links
    $query  = "select date, ";
    $query .= "sum(storyviews + ecomp + estory + press + linksweb), ";
    $query .= "sum(linksweb)  ";
    $query .= "from thomtnetlogPNN11 where acct in ( $acctmap )   ";
    $query .= "and date in ($rdate11) ";
    $query .= "group by date  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
      $newsc{$$row[0]} = $$row[1];
      $newsl{$$row[0]} = $$row[2];
     }
    $sth->finish;
    $query  = "select date, ";
    $query .= "sum( us ), ";
    $query .= "sum( pv + pc + ln + mi + ec + mt + ca + cl + cv + cd + lc ), ";
    $query .= "sum( ln )  ";
    $query .= "from tnetlogARTU11 ";
    $query .= "where acct in ( $acctmap ) and covflag='t' ";
    $query .= "and date in ($rdate11) ";
    $query .= "group by date ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
      $uses{$$row[0]} = $$row[1];
      $conv{$$row[0]} = $$row[2];
      $link{$$row[0]} = $$row[3];

      $conv{$$row[0]} += $newsc{$$row[0]};
      $link{$$row[0]} += $newsl{$$row[0]};
      print wf  "$cid\t$$row[0]\t$uses{$$row[0]}\t$conv{$$row[0]}\t$link{$$row[0]}\n";
      $uses{$$row[0]} = $conv{$$row[0]} = $link{$$row[0]} = $newsc{$$row[0]} = $newsl{$$row[0]} = "";
     }
    $sth->finish;


 
    # get 2012 uses, conv & links
    $query  = "select date, ";
    $query .= "sum(storyviews + ecomp + estory + press + linksweb), ";
    $query .= "sum(linksweb)  ";
    $query .= "from thomtnetlogPNN12 where acct in ( $acctmap )   ";
    $query .= "and date in ($rdate12) ";
    $query .= "group by date  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
      $newsc{$$row[0]} = $$row[1];
      $newsl{$$row[0]} = $$row[2];
     }
    $sth->finish;
    $query  = "select date, ";
    $query .= "sum( us ), ";
    $query .= "sum( pv + pc + ln + mi + ec + mt + ca + cl + cv + cd + lc + vv + dv + iv + sm + pp + mv), ";
    $query .= "sum( ln )  ";
    $query .= "from tnetlogARTU12 ";
    $query .= "where acct in ( $acctmap ) and covflag='t' ";
    $query .= "and date in ($rdate12) ";
    $query .= "group by date ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
      $uses{$$row[0]} = $$row[1];
      $conv{$$row[0]} = $$row[2];
      $link{$$row[0]} = $$row[3];

      $conv{$$row[0]} += $newsc{$$row[0]};
      $link{$$row[0]} += $newsl{$$row[0]};
      print wf  "$cid\t$$row[0]\t$uses{$$row[0]}\t$conv{$$row[0]}\t$link{$$row[0]}\n";
      $uses{$$row[0]} = $conv{$$row[0]} = $link{$$row[0]} = $newsc{$$row[0]} = $newsl{$$row[0]} = "";
     }
    $sth->finish;

=cut 

    # get 2013 uses, conv & links
    $query  = "select date, ";
    $query .= "sum(storyviews + ecomp + estory + press + linksweb), ";
    $query .= "sum(linksweb)  ";
    $query .= "from thomtnetlogPNN13 where acct in ( $acctmap )   ";
    $query .= "and date in ($rdate13) ";
    $query .= "group by date  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
      $newsc{$$row[0]} = $$row[1];
      $newsl{$$row[0]} = $$row[2];
     }
    $sth->finish;
    $query  = "select date, ";
    $query .= "sum( us ), ";
    $query .= "sum( pv + pc + ln + mi + ec + mt + ca + cl + cv + cd + lc + vv + dv + iv + sm + pp + mv), ";
    $query .= "sum( ln )  ";
    $query .= "from tnetlogARTU13 ";
    $query .= "where acct in ( $acctmap ) and covflag='t' ";
    $query .= "and date in ($rdate13) ";
    $query .= "group by date ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
      $uses{$$row[0]} = $$row[1];
      $conv{$$row[0]} = $$row[2];
      $link{$$row[0]} = $$row[3];

      $conv{$$row[0]} += $newsc{$$row[0]};
      $link{$$row[0]} += $newsl{$$row[0]};
      print wf  "$cid\t$$row[0]\t$uses{$$row[0]}\t$conv{$$row[0]}\t$link{$$row[0]}\n";
      $uses{$$row[0]} = $conv{$$row[0]} = $link{$$row[0]} = $newsc{$$row[0]} = $newsl{$$row[0]} = "";
     }
    $sth->finish;


    # get 2014 uses, conv & links
    $query  = "select date, ";
    $query .= "sum(storyviews + ecomp + estory + press + linksweb), ";
    $query .= "sum(linksweb)  ";
    $query .= "from thomtnetlogPNN14 where acct in ( $acctmap )   ";
    $query .= "and date in ($rdate14) ";
    $query .= "group by date  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
      $newsc{$$row[0]} = $$row[1];
      $newsl{$$row[0]} = $$row[2];
     }
    $sth->finish;
    $query  = "select date, ";
    $query .= "sum( us ), ";
    $query .= "sum( pv + pc + ln + mi + ec + mt + ca + cl + cv + cd + lc + vv + dv + iv + sm + pp + mv), ";
    $query .= "sum( ln )  ";
    $query .= "from tnetlogARTU14 ";
    $query .= "where acct in ( $acctmap ) and covflag='t' ";
    $query .= "and date in ($rdate14) ";
    $query .= "group by date ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
      $uses{$$row[0]} = $$row[1];
      $conv{$$row[0]} = $$row[2];
      $link{$$row[0]} = $$row[3];

      $conv{$$row[0]} += $newsc{$$row[0]};
      $link{$$row[0]} += $newsl{$$row[0]};
      print wf  "$cid\t$$row[0]\t$uses{$$row[0]}\t$conv{$$row[0]}\t$link{$$row[0]}\n";
      $uses{$$row[0]} = $conv{$$row[0]} = $link{$$row[0]} = $newsc{$$row[0]} = $newsl{$$row[0]} = "";
     }
    $sth->finish;

  
    # get 2015 uses, conv & links
    $query  = "select date, ";
    $query .= "sum(storyviews + ecomp + estory + press + linksweb), ";
    $query .= "sum(linksweb)  ";
    $query .= "from thomtnetlogPNN15 where acct in ( $acctmap )   ";
    $query .= "and date in ($rdate15) ";
    $query .= "group by date  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
      $newsc{$$row[0]} = $$row[1];
      $newsl{$$row[0]} = $$row[2];
     }
    $sth->finish;
    $query  = "select date, ";
    $query .= "sum( us ), ";
    $query .= "sum( pv + pc + ln + mi + ec + mt + ca + cl + cv + cd + lc + vv + dv + iv + sm + pp + mv), ";
    $query .= "sum( ln )  ";
    $query .= "from tnetlogARTU15 ";
    $query .= "where acct in ( $acctmap ) and covflag='t' ";
    $query .= "and date in ($rdate15) ";
    $query .= "group by date ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
      $uses{$$row[0]} = $$row[1];
      $conv{$$row[0]} = $$row[2];
      $link{$$row[0]} = $$row[3];

      $conv{$$row[0]} += $newsc{$$row[0]};
      $link{$$row[0]} += $newsl{$$row[0]};
      print wf  "$cid\t$$row[0]\t$uses{$$row[0]}\t$conv{$$row[0]}\t$link{$$row[0]}\n";
      $uses{$$row[0]} = $conv{$$row[0]} = $link{$$row[0]} = $newsc{$$row[0]} = $newsl{$$row[0]} = "";
     }
    $sth->finish;


    # get 2016 uses, conv & links
    $query  = "select date, ";
    $query .= "sum(storyviews + ecomp + estory + press + linksweb), ";
    $query .= "sum(linksweb)  ";
    $query .= "from thomtnetlogPNN16 where acct in ( $acctmap )   ";
    $query .= "and date in ($rdate16) ";
    $query .= "group by date  ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
      $newsc{$$row[0]} = $$row[1];
      $newsl{$$row[0]} = $$row[2];
     }
    $sth->finish;
    $query  = "select date, ";
    $query .= "sum( us ), ";
    $query .= "sum( pv + pc + ln + mi + ec + mt + ca + cl + cv + cd + lc + vv + dv + iv + sm + pp + mv), ";
    $query .= "sum( ln )  ";
    $query .= "from tnetlogARTU16 ";
    $query .= "where acct in ( $acctmap ) and covflag='t' ";
    $query .= "and date in ($rdate16) ";
    $query .= "group by date ";
    my $sth = $dbh->prepare($query);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {
      $uses{$$row[0]} = $$row[1];
      $conv{$$row[0]} = $$row[2];
      $link{$$row[0]} = $$row[3];

      $conv{$$row[0]} += $newsc{$$row[0]};
      $link{$$row[0]} += $newsl{$$row[0]};
      print wf  "$cid\t$$row[0]\t$uses{$$row[0]}\t$conv{$$row[0]}\t$link{$$row[0]}\n";
      $uses{$$row[0]} = $conv{$$row[0]} = $link{$$row[0]} = $newsc{$$row[0]} = $newsl{$$row[0]} = "";
     }
    $sth->finish;
  
 

   $j++;
}

close(wf);
  
system("mysqlimport -rL thomas $DIR/formers/$outfile");

$dbh->disconnect;

=for comment
CREATE TABLE formers_total (
  acct bigint(20) NOT NULL default '0',
  yymm int(4) NOT NULL default '0',
  us int(11) NOT NULL default '0',
  conv int(11) NOT NULL default '0',
  links int(11) NOT NULL default '0',
  PRIMARY KEY  (acct,yymm)
) TYPE=MyISAM;
=cut
