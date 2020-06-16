#!/usr/bin/perl
#
# Makes conversion report M - Z
 
use DBI;
require "/usr/wt/trd-reload.ph";
 
$outfile = "convMZ15.txt"; 
$rdate05 = " '0501','0502','0503','0504','0505','0506','0507','0508','0509','0510','0511','0512' ";
$rdate06 = " '0601','0602','0603','0604','0605','0606','0607','0608','0609','0610','0611','0612' ";
$rdate07 = " '0701','0702','0703','0704','0705','0706','0707','0708','0709','0710','0711','0712' ";
$rdate08 = " '0801','0802','0803','0804','0805','0806','0807','0808','0809','0810','0811','0812'";
$rdate09 = " '0901','0902','0903','0904','0905','0906','0907','0908','0909','0910','0911','0912'";
$rdate10 = " '1001','1002','1003','1004','1005','1006','1007','1008','1009','1010','1011','1012'";
$rdate11 = " '1101','1102','1103','1104','1105','1106','1107','1108','1109','1110','1111','1112'";
$rdate12 = " '1201','1202','1203','1204','1205','1206','1207','1208','1209','1210','1211','1212' ";
$rdate13 = " '1301','1302','1303','1304','1305','1306','1307','1308','1309','1310','1311','1312' ";
$rdate14 = " '1401','1402','1403','1404','1405','1406','1407','1408','1409','1410','1411','1412' ";
$rdate15 = " '1501','1502','1503','1504','1505','1506','1507','1508','1509','1510','1511','1512' ";
     
$column = "Q1 2015";
#$column = "Q1-Q2 2015";
#$column = "Q1-Q2-Q3 2015";
#$column = "Q1-Q2-Q3-Q4 2015";
$rlet    =  " 'M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'   ";

     
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
 
# us - User Sessions 
# pv - Profiles Viewed  
# pc - Product Catalog Page's Viewed 
# lw - Links to Supplier's Website 
# em - E-mail Sent to Supplier 
# ec - E-mail Sent to Colleague 
# mt - Save Results to MyThomas 
# cd - Links to CADRegister 
# lc - Links to Catalogs 
# VIDEO VIEWS (vv)
# DOCUMENT VIEWS (dv)
# IMAGE VIEWS (iv)
# SOCIAL MEDIA FOLLOWS (sm)
# PROFILE PRINT REQUEST (pp)
# MAP LOCATION VIEWS  (mv)
 
 
print wf "tnt.com - Category Summary Report\n";
print wf " \t$column\t";                                  
print wf "$column\t";
print wf "$column\t";
print wf "$column\t";
print wf "$column\t";
print wf "$column\t";
print wf "$column\t";
print wf "$column\t";
print wf "$column\t";
print wf "$column\t";
print wf "$column\t";
print wf "Year-End 2014\t";
print wf "Year-End 2014\t";
print wf "Year-End 2013\t";
print wf "Year-End 2013\t";
print wf "Year-End 2012\t";
print wf "Year-End 2012\t";
print wf "Year-End 2011\t";
print wf "Year-End 2011\t";
print wf "Year-End 2010\t";
print wf "Year-End 2010\t";
print wf "Year-End 2009\t";
print wf "Year-End 2009\t";
print wf "Year-End 2008\t";
print wf "Year-End 2008\n";
#print wf "Year-End 2007\t";
#print wf "Year-End 2007\t";
#print wf "Year-End 2006\t";
#print wf "Year-End 2006\n";

print wf "Description\t";
print wf "Links to Your Website\t";
print wf "Profiles Viewed\t";
print wf "Links to Catalog\t";
print wf "Product Catalog Page's Viewed\t";
print wf "E-mail Sent to Supplier\t";
print wf "E-mail Sent to Colleague\t";
print wf "Save Results to MyThomas\t";
print wf "Links to CADRegister\t";
print wf "Custom Company Profile Interactions\t";
print wf "Total Conversions\t";
print wf "Total User Sessions\t";
print wf "Total Conversions\t";
print wf "Total User Sessions\t";
print wf "Total Conversions\t";
print wf "Total User Sessions\t";
print wf "Total Conversions\t";
print wf "Total User Sessions\t";
print wf "Total Conversions\t";
print wf "Total User Sessions\t";
print wf "Total Conversions\t";
print wf "Total User Sessions\t";
print wf "Total Conversions\t";
print wf "Total User Sessions\t";
print wf "Total Conversions\t";
print wf "Total User Sessions\n";
            
# All headings in array     
$query  = " select description, heading from tgrams.headings where left(description, 1) in ($rlet) order by description ";
#$query .= " limit 5 ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {   
  $$row[0] =~ s/\,//g;
  $hd[$i]="$$row[0]|$$row[1]";
  $i++;
 }
$sth->finish;
  

$i=0; 
foreach $hd (@hd)         
 {                               
   ($d,$h) = split(/\|/,$hd);                       
  
  # Get Total 2008 US
   $query  = " select  sum(cnt) from thomquickUS08 where heading='$h' and covflag='t' and date in ($rdate08) ";
   $query = " select us2008 from convAZ where heading = '$h'";
   #print "$query\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $y2008US = $$row[0]; 
     if($y2008US eq "") {$y2008US=0;}
     #print "2008: $y2008US\n";
    }
   $sth->finish;
     
  # Get Total 2009 US
  $query  = " select  sum(cnt) from thomquickUS09 where heading='$h' and covflag='t' and date in ($rdate09) ";
   $query = " select us2009 from convAZ where heading = '$h'";
   #print "$query\n"; 
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    { 
     $y2009US = $$row[0]; 
     if($y2009US eq "") {$y2009US=0;}
    # print "2009: $y2009US\n"; 
    }
   $sth->finish;
  
 
  # Get Total 2010 US
  # $query  = " select  sum(cnt) from thomquickUS10 where heading='$h' and covflag='t' and date in ($rdate10) ";
   $query = " select us2010 from convAZ where heading = '$h'";
   #print "$query \n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $y2010US = $$row[0];
     if($y2010US eq "") {$y2010US=0;}
     # print "us: $y2010US\n\n";
    } 
   $sth->finish;
    
  # Get Total 2011 US
   $query  = " select  sum(cnt) from thomquickUS11 where heading='$h' and covflag='t' and date in ($rdate11) ";
   $query = " select us2011 from convAZ where heading = '$h'";
   #print " $query\n"; 
   my $sth = $dbh->prepare($query); 
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    { 
     $y2011US = $$row[0];
     if($y2011US eq "") {$y2011US=0;}
    }
   $sth->finish;

 
 # Get Total 2012 US
   $query  = " select  sum(cnt) from thomquickUS12 where heading='$h' and covflag='t' and date in ($rdate12) ";
   $query = " select us2012 from convAZ where heading = '$h'"; 
  #print " $query\n"; 
   my $sth = $dbh->prepare($query); 
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    { 
     $y2012US = $$row[0];
     if($y2012US eq "") {$y2012US=0;}
    }
   $sth->finish;
  
 # Get Total 2013 US
   $query  = " select  sum(cnt) from thomquickUS13 where heading='$h' and covflag='t' and date in ($rdate13) ";
   $query = " select us2013 from convAZ where heading = '$h'";
   #print " $query\n"; 
   my $sth = $dbh->prepare($query); 
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {  
     $y2013US = $$row[0];
     if($y2013US eq "") {$y2013US=0;}
    }
   $sth->finish;

 
 # Get Total 2014 US
   $query  = " select  sum(cnt) from thomquickUS14 where heading='$h' and covflag='t' and date in ($rdate14) ";
   #print " $query\n";
   my $sth = $dbh->prepare($query); 
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {  
     $y2014US = $$row[0];
     if($y2014US eq "") {$y2014US=0;}
    }
   $sth->finish;

 # Get Total 2015 US
   $query  = " select  sum(cnt) from thomquickUS15 where heading='$h' and covflag='t' and date in ($rdate15) ";
   #print " $query\n";
   my $sth = $dbh->prepare($query); 
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {  
     $y2015US = $$row[0];
     if($y2015US eq "") {$y2015US=0;}
    }
   $sth->finish;
   
    
  # Get Total 2008 conversions
   $query = "select conv2008 from convAZ where heading = '$h'";
   my $sth = $dbh->prepare($query);
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $y2008 = $$row[0];
     if($y2008 eq "") {$y2008=0;}
    }
   $sth->finish;
                                   
  # Get Total 2009 conversions
   $query = "select conv2009 from convAZ where heading = '$h'";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $y2009 = $$row[0];
     if($y2009 eq "") {$y2009=0;}
    }
   $sth->finish;

  # Get Total 2010 conversions
   $query = "select conv2010 from convAZ where heading = '$h'";
   # print "\n$query\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $y2010 = $$row[0];
     if($y2010 eq "") {$y2010=0;}
     #print "conv: $y2010\n";
    }
   $sth->finish;

 
   # 2011 conversions
   $query = " select ";
   $query .= "sum(pv) + ";
   $query .= "sum(pc) + ";
   $query .= "sum(lw) + ";
   $query .= "sum(em) + ";
   $query .= "sum(ec) + ";
   $query .= "sum(mt) + ";                                    
   $query .= "sum(cd) +  ";
   $query .= "sum(lc)  as tot ";
   $query .= "from  qlog11Y  where heading='$h' and covflag='t' and date in ( $rdate11 ) and acct>0 ";
   $query = "select conv2011 from convAZ where heading = '$h'";
   my $sth = $dbh->prepare($query); 
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    { $y2011 = $$row[0]; }  
   $sth->finish;
 
 

   # 2012 conversions
   $query = " select ";
   $query .= "sum(pv) + ";
   $query .= "sum(pc) + ";
   $query .= "sum(lw) + ";
   $query .= "sum(em) + ";
   $query .= "sum(ec) + ";
   $query .= "sum(mt) + ";                                    
   $query .= "sum(cd) + ";
   $query .= "sum(lc) + ";
   $query .= "sum(vv) + ";
   $query .= "sum(dv) + ";
   $query .= "sum(iv) + ";
   $query .= "sum(sm) + ";
   $query .= "sum(pp) + ";
   $query .= "sum(mv) as tot ";    
   $query .= "from  qlog12Y  where heading='$h' and covflag='t' and date in ( $rdate12 ) and acct>0 ";
   $query = "select conv2012 from convAZ where heading = '$h'";
   my $sth = $dbh->prepare($query); 
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
   { $y2012 = $$row[0]; } 
   $sth->finish;

 
   # 2013 conversions
   $query = " select ";
   $query .= "sum(pv) + ";
   $query .= "sum(pc) + ";
   $query .= "sum(lw) + ";
   $query .= "sum(em) + ";
   $query .= "sum(ec) + ";
   $query .= "sum(mt) + ";                                    
   $query .= "sum(cd) + ";
   $query .= "sum(lc) + ";
   $query .= "sum(vv) + ";
   $query .= "sum(dv) + ";
   $query .= "sum(iv) + ";
   $query .= "sum(sm) + ";
   $query .= "sum(pp) + ";
   $query .= "sum(mv) as tot ";    
   $query .= "from  qlog13Y  where heading='$h' and covflag='t' and date in ( $rdate13 ) and acct>0 ";
   $query = "select conv2013 from convAZ where heading = '$h'"; 
   my $sth = $dbh->prepare($query); 
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
   { $y2013 = $$row[0]; } 
   $sth->finish;


   # 2014 conversions >>> NOTE NEED TO ADD THIS DATA INTO convAZ TABLE
   $query = " select ";
   $query .= "sum(pv) + ";
   $query .= "sum(pc) + ";
   $query .= "sum(lw) + ";
   $query .= "sum(em) + ";
   $query .= "sum(ec) + ";
   $query .= "sum(mt) + ";                                    
   $query .= "sum(cd) + ";
   $query .= "sum(lc) + ";
   $query .= "sum(vv) + ";
   $query .= "sum(dv) + ";
   $query .= "sum(iv) + ";
   $query .= "sum(sm) + ";
   $query .= "sum(pp) + ";
   $query .= "sum(mv) as tot ";    
   $query .= "from  qlog14Y  where heading='$h' and covflag='t' and date in ( $rdate14 ) and acct>0 ";
   #$query = "select conv2014 from convAZ where heading = '$h'"; 
   my $sth = $dbh->prepare($query); 
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
   { $y2014 = $$row[0]; } 
   $sth->finish;
 
   
   # 2015 conversions
   $query = " select ";
   $query .= "sum(pv) as pv, ";
   $query .= "sum(pc) as pc, ";
   $query .= "sum(lw) as lw, ";
   $query .= "sum(em) as em, ";
   $query .= "sum(ec) as ec, ";
   $query .= "sum(mt) as mt, ";                                    
   $query .= "sum(cd) as cd, ";
   $query .= "sum(lc) as lc, ";
   $query .= "sum(vv) as vv, ";
   $query .= "sum(dv) as dv, ";
   $query .= "sum(iv) as iv, ";
   $query .= "sum(sm) as sm, ";
   $query .= "sum(pp) as pp, ";
   $query .= "sum(mv) as mv ";     
   $query .= "from  qlog15Y  where heading='$h' and covflag='t' and date in ( $rdate15 ) and acct>0 ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    { 
      $pv = $$row[0];
      $pc = $$row[1];
      $lw = $$row[2];
      $em = $$row[3];
      $ec = $$row[4];
      $mt = $$row[5];
      $cd = $$row[6];
      $lc = $$row[7];
      $vv = $$row[8];
      $dv = $$row[9];
      $iv = $$row[10];
      $sm = $$row[11];
      $pp = $$row[12];
      $mv = $$row[13];  
      if($pv eq "") { $pv = 0; }   
      if($pc eq "") { $pc = 0; }   
      if($lw eq "") { $lw = 0; }   
      if($em eq "") { $em = 0; }   
      if($ec eq "") { $ec = 0; }   
      if($mt eq "") { $mt = 0; }   
      if($cd eq "") { $cd = 0; }   
      if($lc eq "") { $lc = 0; }   
      if($vv eq "") { $vv = 0; }
      if($dv eq "") { $dv = 0; }
      if($iv eq "") { $iv = 0; }
      if($sm eq "") { $sm = 0; }
      if($pp eq "") { $pp = 0; }
      if($mv eq "") { $mv = 0; }      
      $qtotal = $pv + $pc + $lw + $em + $ec + $mt + $cd + $lc + $vv + $dv + $iv + $sm + $pp + $mv;
      if($qtotal eq "") { $qtotal =0; }      
      $ccptot = $vv + $dv + $iv + $sm + $pp + $mv;
    }  
   $sth->finish;
   
   #    # Profiles Viewed
   # Links to Catalog
   # Product Catalog Page's Viewed
   # Links to More Info
   # E-mail Sent to Supplier
   # E-mail Sent to Colleague
   # Save Results to MyThomas
   # Links to CADRegister
   # Custom Company Profile Interactions 
   # 2007 Total Conversions
   # 2007 Total User Sessions
   # 2006 Total Conversions
   # 2006 Total User Sessions
   # 2005 Total Conversions
   # 2005 Total User Sessions\n";   
 
   print wf "$d\t$lw\t$pv\t$lc\t$pc\t$em\t$ec\t$mt\t$cd\t$ccptot\t$qtotal\t$y2015US\t";
       
   print wf "$y2014\t$y2014US\t";
   print wf "$y2013\t$y2013US\t";
   print wf "$y2012\t$y2012US\t";
   print wf "$y2011\t$y2011US\t";
   print wf "$y2010\t$y2010US\t";
   print wf "$y2009\t$y2009US\t";
   print wf "$y2008\t$y2008US\n"; 

  # print wf "$h\n";	
         
   $pv = $pc = $lc = $lw = $em = $ec = $mt = $cd = $qtotal = 0; 
   $y2006   = $y2007   = $y2008   = $y2009   = $y2010   = $y2011   =  $y2012   =  $y2013   = $y2014  =  $y2015  =  0;  
   $y2006US = $y2007US = $y2008US = $y2009US = $y2010US = $y2011US =  $y2012US =  $y2013US = $y2014US = $y2015US = 0;
   $vv = $dv = $iv = $sm = $pp = $mv = 0;  
     
  $i++;
  #if ($i%1000 == 0) { print "$i\r"; }
  print "$i $d\n";
 }
close(wf);

$dbh->disconnect;

print "\n\nDone...\n\n";
