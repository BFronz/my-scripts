#!/usr/bin/perl
#
# Makes conversion report M - Z
 
use DBI;
$dbh      = DBI->connect("", "", "");
 
$outfile = "convMZ14temp.txt"; 
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
    
$column = "Q1 2014";
$column = "Q1-Q2 2014";
$column = "Q1-Q2-Q3 2014";
#$column = "Q1-Q2-Q3-Q4 2014";
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
print wf "$column\n";     
                             
print wf "\t$column\t";
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
print wf "Total User Sessions\n";
#print wf "Total Conversions\t";
#print wf "Total User Sessions\n";
            
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
 
   print wf "$d\t$lw\t$pv\t$lc\t$pc\t$em\t$ec\t$mt\t$cd\t$ccptot\t$qtotal\t$y2014US\t";
     
   print wf "$y2013\t$y2013US\t";
   print wf "$y2012\t$y2012US\t";
   print wf "$y2011\t$y2011US\t";
   print wf "$y2010\t$y2010US\t";
   print wf "$y2009\t$y2009US\t";
   print wf "$y2008\t$y2008US\t"; 

   print wf "$h\n";	
         
   $pv = $pc = $lc = $lw = $em = $ec = $mt = $cd = $qtotal = 0; 
   $y2006   = $y2007   = $y2008   = $y2009   = $y2010   = $y2011   =  $y2012   =  $y2013   = $y2014  = 0;  
   $y2006US = $y2007US = $y2008US = $y2009US = $y2010US = $y2011US =  $y2012US =  $y2013US = $y2014US = 0;
   $vv = $dv = $iv = $sm = $pp = $mv = 0;  
    
  $i++;
  #if ($i%1000 == 0) { print "$i\r"; }
  print "$i $d\n";
 }
close(wf);

$dbh->disconnect;

print "\n\nDone...\n\n";
