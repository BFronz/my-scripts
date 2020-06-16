#!/usr/bin/perl 
# 
# loads new monthly ips into iptable  dbaseNetAcuityIP dbase & NetAcuity 
#
# for Catav run as  ./dbase-NA-ip-load.pl /usr/wt/catnav/USER_IP_ADDRESSES_12022017.txt 3 *   
#  
# for CAD IP run as  ./dbase-NA-ip-load.pl /usr/wt/monthly/reports/advCADActionDetail-new-1711.txt  2 *         
#
# for News IP run as  ./dbase-NA-ip-load.pl /usr/wt/newsip/adclicks/ad_click_201711.txt  0   *            
# for News IP run as  ./dbase-NA-ip-load.pl /usr/wt/newsip/adviews/ad_view_201711.txt  0    *
#
# for News BAD PAI run as ./dbase-NA-ip-load.pl  /usr/wt/badpai/pai_ad_click_201711.txt 0  *
# for News BAD PAI run as ./dbase-NA-ip-load.pl  /usr/wt/badpai/pai_ad_view_201711.txt 0    *  
#
# for News BAD PAI run as ./dbase-NA-ip-load.pl  /usr/wt/badpai/branddom_ad_click_201711.txt 0  *                               
# for News BAD PAI run as ./dbase-NA-ip-load.pl  /usr/wt/badpai/branddom_ad_view_201711.txt  0  *  

# for News BAD PAI run as ./dbase-NA-ip-load.pl  /usr/wt/badpai/phad_ad_click_201711.txt 0  *             
# for News BAD PAI run as ./dbase-NA-ip-load.pl  /usr/wt/badpai/phad_ad_view_201711.txt  0   *  



use DBI;   
require "/usr/wt/trd-reload.ph";  
        
$infile  = $ARGV[0];
$fldpos  = $ARGV[1];

if($infile eq "" || $fldpos eq "") {  print "\nMissing params\n\n"; exit; }

print "\nInfile: $infile\nField position: $fldpos\n";
               
$outfile = "dbaseNetAcuityIP.txt";
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
     
$i=0;
open(rf, "$infile")  || die (print "Could not open $infile\n");
while (!eof(rf))
{
 $instr = <rf>;

 chop($instr);
 
($fld[0], $fld[1], $fld[2], $fld[3], $fld[4], $fld[5], $fld[6]) = split(/\t/, $instr);
 
 print wf "$fld[$fldpos]\t0\n";
 
 undef(@fld);
 if ($i%1000==0) { print "$i\r"; }
 $i++;
}
   
close(wf);
close(rf);  
 
#system("mysqlimport -iL thomas $DIR/dbase/$outfile");
system("mysqlimport -rL thomas $DIR/dbase/$outfile");

print "\n\nDone...\n\n";
