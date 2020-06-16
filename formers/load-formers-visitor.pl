#!/usr/bin/perl
#
# Load visitor data for just turned non-adv
# Use lastmod to determine new formers (so run data from 2006) or old formers (only run 2008 data)
# Will have to adjust script each YEAR

use DBI;
use POSIX;
require "/usr/wt/trd-reload.ph";

use Digest::MD5 qw(md5 md5_hex md5_base64);

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
$query  = "select acct,lastmod from formers_main ";
#$query .= "limit 5 ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $record[$i]  = "$$row[0]:$$row[1]";
  $i++;
 }
$sth->finish;

 
# Get bad and isp orgs
$query  = "select trim(org) as org from thomtnetlogORGflagExtra where  org>'' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
  $$row[0] =~ s/^\s+//;
  $$row[0] =~ s/\s+$//;
  $$row[0] =~ tr/[A-Z]/[a-z]/;
  if($$row[1] eq "Y") { $isporg{$$row[0]} = $$row[0]; }
 } 
$sth->finish;
 
$query  = "SELECT trim(orgblock) as orgblock FROM thomtnetlogORGflagBLOCK   WHERE orgblock>'' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
  $$row[0] =~ tr/[A-Z]/[a-z]/;
  if($$row[2] eq "Y") { $badorg{$$row[0]} = $$row[0]; }
 }
$sth->finish;

$outfile = "formers_visitor.txt";
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
$j=0;
foreach $record (@record)
{
  ($cid,$lastmod) = split(/\:/,$record);
  #$lastmod=0; # >>>>>>> for testing !!!!!

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

       print "$j\t$acctmap\n";

=for comment

        # get 2006 visitors
        $query  = "select date, org, domain, count(*) ";
        $query .= "from tnetlogORGN06 ";
        $query .= "where acct in ( $acctmap ) and date in ($rdate06) ";
        $query .= "group by date, org ";
        my $sth = $dbh->prepare($query);
        if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
        while (my $row = $sth->fetchrow_arrayref)
          {
           $org = $dom = "";
           # date = $$row[0];
           # org  = $$row[1];
           # dom  = $$row[2];
           $$row[1] =~ s/^\s+//;
           $$row[1] =~ s/\s+$//;
           $$row[1] =~ tr/[A-Z]/[a-z]/;
           $$row[1] =~ s/\'//g;
           $$row[1] =~ s/\\//g;
           $$row[2] =~ s/\'//g;
           $$row[2] =~ s/\\//g;
           $$row[2] =~ tr/[A-Z]/[a-z]/;
           if( $isporg{$$row[1]} eq "" && $badorg{$row[1]} eq "")
            {
             print wf "INSERT IGNORE INTO formers_visitor VALUES ('$cid','$$row[0]','$$row[1]','$$row[2]','$$row[3]', md5('$$row[1]') );\n";
            }
          }
         $sth->finish;

      
        # get 2007 visitors
        $query  = "select date, org, domain, count(*) ";
        $query .= "from tnetlogORGN07 ";
        $query .= "where acct in ( $acctmap ) and date in ($rdate07) ";
        $query .= "group by date, org ";
        my $sth = $dbh->prepare($query);
        if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
        while (my $row = $sth->fetchrow_arrayref)
          {
           $org = $dom = "";
           # date = $$row[0];
           # org  = $$row[1];
           # dom  = $$row[2];
           $$row[1] =~ s/^\s+//;
           $$row[1] =~ s/\s+$//;
           $$row[1] =~ tr/[A-Z]/[a-z]/;
           $$row[1] =~ s/\'//g;
           $$row[1] =~ s/\\//g;
           $$row[2] =~ s/\'//g;
           $$row[2] =~ s/\\//g;
           $$row[2] =~ tr/[A-Z]/[a-z]/;
           if( $isporg{$$row[1]} eq "" && $badorg{$row[1]} eq "")
            {
             print wf "INSERT IGNORE INTO formers_visitor VALUES ('$cid','$$row[0]','$$row[1]','$$row[2]','$$row[3]', md5('$$row[1]') );\n";
            }
          }
         $sth->finish;

   # get 2008 visitors
   $query  = "select date, org, domain, count(*) ";
   $query .= "from tnetlogORGN08 ";
   $query .= "where acct in ( $acctmap ) and date in ($rdate08) ";
   $query .= "group by date, org ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $org = $dom = "";
     # date = $$row[0];
     # org  = $$row[1];
     # dom  = $$row[2];
     $$row[1] =~ s/^\s+//;
     $$row[1] =~ s/\s+$//;
     $$row[1] =~ tr/[A-Z]/[a-z]/;
     $$row[1] =~ s/\'//g;
     $$row[1] =~ s/\\//g;
     $$row[2] =~ s/\'//g;
     $$row[2] =~ s/\\//g;
     $$row[2] =~ tr/[A-Z]/[a-z]/;
     if( $isporg{$$row[1]} eq "" && $badorg{$row[1]} eq "")
      {
       print wf "INSERT IGNORE INTO formers_visitor VALUES ('$cid','$$row[0]','$$row[1]','$$row[2]','$$row[3]', md5('$$row[1]') );\n";
      }
    }
   $sth->finish;
 


 # get 2009 visitors
  $query  = "select date, org, domain, count(*) ";
  $query .= "from tnetlogORGN09 ";
  $query .= "where acct in ( $acctmap ) and date in ($rdate09) ";
  $query .= "group by date, org ";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
    {
     $org = $dom = "";
     # date = $$row[0];
     # org  = $$row[1];
     # dom  = $$row[2];
     $$row[1] =~ s/^\s+//;
     $$row[1] =~ s/\s+$//;
     $$row[1] =~ tr/[A-Z]/[a-z]/;
     $$row[1] =~ s/\'//g;
     $$row[1] =~ s/\\//g;
     $$row[2] =~ s/\'//g;
     $$row[2] =~ s/\\//g;
     $$row[2] =~ tr/[A-Z]/[a-z]/;
     if( $isporg{$$row[1]} eq "" && $badorg{$row[1]} eq "")
      {
       print wf "INSERT IGNORE INTO formers_visitor VALUES ('$cid','$$row[0]','$$row[1]','$$row[2]','$$row[3]', md5('$$row[1]') );\n";
      }
    }
   $sth->finish;


 
   # get 2010 visitors
   $query  = "select date, org, domain, count(*) ";
   $query .= "from tnetlogORGN10 ";
   $query .= "where acct in ( $acctmap ) and date in ($rdate10) ";
   $query .= "group by date, org ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $org = $dom = "";
     # date = $$row[0];
     # org  = $$row[1];
     # dom  = $$row[2];
     $$row[1] =~ s/^\s+//;
     $$row[1] =~ s/\s+$//;
     $$row[1] =~ tr/[A-Z]/[a-z]/;
     $$row[1] =~ s/\'//g;
     $$row[1] =~ s/\\//g;
     $$row[2] =~ s/\'//g;
     $$row[2] =~ s/\\//g;
     $$row[2] =~ tr/[A-Z]/[a-z]/;
     if( $isporg{$$row[1]} eq "" && $badorg{$row[1]} eq "")
      {
       print wf "INSERT IGNORE INTO formers_visitor VALUES ('$cid','$$row[0]','$$row[1]','$$row[2]','$$row[3]', md5('$$row[1]') );\n";
      }
    }
   $sth->finish;


 
   # get 2011 visitors
   $query  = "select date, org, domain, count(*) ";
   $query .= "from tnetlogORGN11 ";
   $query .= "where acct in ( $acctmap ) and date in ($rdate11) ";
   $query .= "group by date, org ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $org = $dom = "";
     # date = $$row[0];
     # org  = $$row[1];
     # dom  = $$row[2];
     $$row[1] =~ s/^\s+//;
     $$row[1] =~ s/\s+$//;
     $$row[1] =~ tr/[A-Z]/[a-z]/;
     $$row[1] =~ s/\'//g;
     $$row[1] =~ s/\\//g;
     $$row[2] =~ s/\'//g;
     $$row[2] =~ s/\\//g;
     $$row[2] =~ tr/[A-Z]/[a-z]/;
     if( $isporg{$$row[1]} eq "" && $badorg{$row[1]} eq "")
      {
       print wf "INSERT IGNORE INTO formers_visitor VALUES ('$cid','$$row[0]','$$row[1]','$$row[2]','$$row[3]', md5('$$row[1]') );\n";
      }
    }
   $sth->finish;
    

 
   # get 2012 visitors
   $query  = "select date, org, domain, count(*) ";
   $query .= "from tnetlogORGN12 ";
   $query .= "where acct in ( $acctmap ) and date in ($rdate12) ";
   $query .= "group by date, org ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $org = $dom = "";
     # date = $$row[0];
     # org  = $$row[1];
     # dom  = $$row[2];
     $$row[1] =~ s/^\s+//;
     $$row[1] =~ s/\s+$//;
     $$row[1] =~ tr/[A-Z]/[a-z]/;
     $$row[1] =~ s/\'//g;
     $$row[1] =~ s/\\//g;
     $$row[2] =~ s/\'//g;
     $$row[2] =~ s/\\//g;
     $$row[2] =~ tr/[A-Z]/[a-z]/;
     if( $isporg{$$row[1]} eq "" && $badorg{$row[1]} eq "")
      {
       print wf "INSERT IGNORE INTO formers_visitor VALUES ('$cid','$$row[0]','$$row[1]','$$row[2]','$$row[3]', md5('$$row[1]') );\n";
      }
    }
   $sth->finish;
 


   # get 2013 visitors
   $query  = "select date, org, domain, count(*) ";
   $query .= "from tnetlogORGN13 ";
   $query .= "where acct in ( $acctmap ) and date in ($rdate13) ";
   $query .= "group by date, org ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $org = $dom = "";
     # date = $$row[0];
     # org  = $$row[1];
     # dom  = $$row[2];
     $$row[1] =~ s/^\s+//;
     $$row[1] =~ s/\s+$//;
     $$row[1] =~ tr/[A-Z]/[a-z]/;
     $$row[1] =~ s/\'//g;
     $$row[1] =~ s/\\//g;
     $$row[2] =~ s/\'//g;
     $$row[2] =~ s/\\//g;
     $$row[2] =~ tr/[A-Z]/[a-z]/;
     if( $isporg{$$row[1]} eq "" && $badorg{$row[1]} eq "")
      {
       print wf "INSERT IGNORE INTO formers_visitor VALUES ('$cid','$$row[0]','$$row[1]','$$row[2]','$$row[3]', md5('$$row[1]') );\n";
      }
    }
   $sth->finish;

=cut

   # get 2014 visitors
   $query  = "select date, org, domain, count(*) ";
   $query .= "from tnetlogORGN14 ";
   $query .= "where acct in ( $acctmap ) and date in ($rdate14) ";
   $query .= "group by date, org ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $org = $dom = "";
     # date = $$row[0];
     # org  = $$row[1];
     # dom  = $$row[2];
     $$row[1] =~ s/^\s+//;
     $$row[1] =~ s/\s+$//;
     $$row[1] =~ tr/[A-Z]/[a-z]/;
     $$row[1] =~ s/\'//g;
     $$row[1] =~ s/\\//g;
     $$row[2] =~ s/\'//g;
     $$row[2] =~ s/\\//g;
     $$row[2] =~ tr/[A-Z]/[a-z]/;
     if( $isporg{$$row[1]} eq "" && $badorg{$row[1]} eq "")
      {
       print wf "INSERT IGNORE INTO formers_visitor VALUES ('$cid','$$row[0]','$$row[1]','$$row[2]','$$row[3]', md5('$$row[1]') );\n";
      }
    }
   $sth->finish;

   # get 2015 visitors
   $query  = "select date, org, domain, count(*) ";
   $query .= "from tnetlogORGN15 ";
   $query .= "where acct in ( $acctmap ) and date in ($rdate15) ";
   $query .= "group by date, org ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $org = $dom = "";
     # date = $$row[0];
     # org  = $$row[1];
     # dom  = $$row[2];
     $$row[1] =~ s/^\s+//;
     $$row[1] =~ s/\s+$//;
     $$row[1] =~ tr/[A-Z]/[a-z]/;
     $$row[1] =~ s/\'//g;
     $$row[1] =~ s/\\//g;
     $$row[2] =~ s/\'//g;
     $$row[2] =~ s/\\//g;
     $$row[2] =~ tr/[A-Z]/[a-z]/;
     if( $isporg{$$row[1]} eq "" && $badorg{$row[1]} eq "")
      {
       #print wf "INSERT IGNORE INTO formers_visitor VALUES ('$cid','$$row[0]','$$row[1]','$$row[2]','$$row[3]', md5('$$row[1]') );\n";
	$orgid  =  md5_hex($$row[1]);
	print wf "$cid\t$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$orgid\n";
      } 
    }
   $sth->finish;


 
   # get 2016 visitors
   $query  = "select date, org, domain, count(*) ";
   $query .= "from tnetlogORGN16 ";
   $query .= "where acct in ( $acctmap ) and date in ($rdate16) ";
   $query .= "group by date, org ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $org = $dom = "";
     # date = $$row[0];
     # org  = $$row[1];
     # dom  = $$row[2];
     $$row[1] =~ s/^\s+//;
     $$row[1] =~ s/\s+$//;
     $$row[1] =~ tr/[A-Z]/[a-z]/;
     $$row[1] =~ s/\'//g;
     $$row[1] =~ s/\\//g;
     $$row[2] =~ s/\'//g;
     $$row[2] =~ s/\\//g;
     $$row[2] =~ tr/[A-Z]/[a-z]/;
     if( $isporg{$$row[1]} eq "" && $badorg{$row[1]} eq "")
      {
       #print wf "INSERT IGNORE INTO formers_visitor VALUES ('$cid','$$row[0]','$$row[1]','$$row[2]','$$row[3]', md5('$$row[1]') );\n";
	$orgid  =  md5_hex($$row[1]);
	print wf "$cid\t$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$orgid\n";
      } 
    }
   $sth->finish;



   # get 2017 visitors
   $query  = "select date, org, domain, count(*) ";
   $query .= "from tnetlogORGN17 ";
   $query .= "where acct in ( $acctmap ) and date in ($rdate17) ";
   $query .= "group by date, org ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $org = $dom = "";
     # date = $$row[0];
     # org  = $$row[1];
     # dom  = $$row[2];
     $$row[1] =~ s/^\s+//;
     $$row[1] =~ s/\s+$//;
     $$row[1] =~ tr/[A-Z]/[a-z]/;
     $$row[1] =~ s/\'//g;
     $$row[1] =~ s/\\//g;
     $$row[2] =~ s/\'//g;
     $$row[2] =~ s/\\//g;
     $$row[2] =~ tr/[A-Z]/[a-z]/;
     if( $isporg{$$row[1]} eq "" && $badorg{$row[1]} eq "")
      {
       #print wf "INSERT IGNORE INTO formers_visitor VALUES ('$cid','$$row[0]','$$row[1]','$$row[2]','$$row[3]', md5('$$row[1]') );\n";
	$orgid  =  md5_hex($$row[1]);
	print wf "$cid\t$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$orgid\n";
      } 
    }
   $sth->finish;



  } # bottom of lastmod loop

   $j++;


}

close(wf);

#system("mysql thomas < $outfile"); 
system("mysqlimport -iL thomas $DIR/formers/$outfile");

 
$dbh->disconnect;
 
 
=for comment
CREATE TABLE `formers_visitor` (
  `acct` bigint(20) NOT NULL default '0',
  `yymm` int(4) NOT NULL default '0',
  `org` varchar(255) NOT NULL default '',
  `domain` varchar(75) default NULL,
  `cnt` bigint(20) NOT NULL default '0',
  `oid` varchar(32) NOT NULL default '',
  PRIMARY KEY  (`acct`,`yymm`,`oid`),
  KEY `acct` (`acct`),
  KEY `yymm` (`yymm`),
  KEY `oid` (`oid`)
) TYPE=MyISAM 
=cut
