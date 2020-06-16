#!/usr/bin/perl
#
# update orgs that have been not flaged as isps
# isp like is 'xxx%'
# run as ./orgs-flag-like.pl YY
  

$year     = $ARGV[0];
#$isp="africa online";
if($year eq "") {print "\n\nForgot to add isp and or Year YY\n\n"; exit;}
$outfile="orgs-flag.log";
  
$ADDDATE="  date>''  "; 
 
# Connect to mysql database
use DBI;
$dbh      = DBI->connect("", "", "");

$unixtime    = time();
$z           = 1;  
$i           = 0;

sub updateTable
{  
  $q = $_[0];
  print "$q\n"; 
  my $sth = $dbh->prepare($q);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
  $sth->finish;
  sleep(1);
}   

            
$i=0;
open(wf, ">>$outfile")  || die (print "Could not open $outfile\n");

  $isp =~ s/^\s+//;
  $isp =~ s/\s+$//;
  $isp =~ tr/[A-Z]/[a-z]/; 
  print "\n\n$isp\n\n";

$ORGS =" (
  org like  'Administracion Nacional de Telecomunicaciones%' || 
  org like  'AJAY Syscon PVT Ltd%' || 
  org like  'Amnet Broadband Pty Ltd%' || 
  org like  'Asianet is a cable ISP providing%' || 
  org like  'AT&T%' || 
  org like  'Atlantic Telephone Membership Corp.%' || 
  org like  'Augere Wireless Broadband Bangladesh Limited%' || 
  org like  'Barracuda Networks Inc%' || 
  org like  'Batelco ADSL service%' || 
  org like  'Bayanat Al-Oula For Network Services%' || 
  org like  'Black Oak Computers%' || 
  org like  'Botswana Telecommunications Corporation%' || 
  org like  'BrightHouse Networks Bakersfield%' || 
  org like  'BrightHouse Networks Indianapolis%' || 
  org like  'Broadstripe%' || 
  org like  'BTC Broadband Service%' || 
  org like  'Cable Bahamas%' || 
  org like  'Cable Onda%' || 
  org like  'Cablemas Telecomunicaciones SA de CV%' || 
  org like  'Cablevision S.A.%' || 
  org like  'Central Wisconsin Communications LLC%' || 
  org like  'China Netcom Group Beijing Communication Company%' || 
  org like  'China TieTong Telecommunications Corporation%' || 
  org like  'China Unicom Beijing province network%' || 
  org like  'China Unicom Heibei Province Network%' || 
  org like  'China Unicom Henan province network%' || 
  org like  'China Unicom Liaoning province network%' || 
  org like  'China Unicom Shandong province network%' || 
  org like  'CHINANET Anhui PROVINCE NETWORK%' || 
  org like  'Chinanet Fujian Province Network%' || 
  org like  'CHINANET hebei province network%' || 
  org like  'CHINANET henan province network%' || 
  org like  'Chinanet Hubei Province Network%' || 
  org like  'Chinanet Hunan Province Network%' || 
  org like  'Chinanet Jiangsu Province Network%' || 
  org like  'Chinanet Jiangxi Province Network%' || 
  org like  'Chinanet Shaanxi Province Network%' || 
  org like  'ChinaNet Shanghai Province Network%' || 
  org like  'Chinanet Tianjin Province Network%' || 
  org like  'CHINANET-ZJ Hangzhou node network%' || 
  org like  'CHINANET-ZJ Huzhou node network%' || 
  org like  'CHINANET-ZJ Jiaxing node network%' || 
  org like  'CHINANET-ZJ Jinhua node network%' || 
  org like  'CHINANET-ZJ Ningbo node network%' || 
  org like  'CHINANET-ZJ Shaoxing node network%' || 
  org like  'CHINANET-ZJ Taizhou node network%' || 
  org like  'CHINANET-ZJ Wenzhou node network%' || 
  org like  'COLOMBIA TELECOMUNICACIONES S.A. ESP%' || 
  org like  'Columbus Communications Jamaica Limited%' || 
  org like  'Columbus Communications Trinidad Limited.%' || 
  org like  'Cyprus Telecommuncations Authority%' || 
  org like  'Dai IP su dung cho mang khach hang FTTH o HCMC%' || 
  org like  'Data Networks Inc%' || 
  org like  'DetectNetwork.US%' || 
  org like  'DiGi Telecommunications Sdn Bhd%' || 
  org like  'Digial Nirvana%' || 
  org like  'Dishnet Wireless Limited%' || 
  org like  'DSL Extreme%' || 
  org like  'EarthLink Ltd. Communications&Internet Services%' || 
  org like  'Elisa Oyj%' || 
  org like  'Ellijay Telephone Company%' || 
  org like  'Emirates Telecommunications Corporation%' || 
  org like  'EPB Telecom%' || 
  org like  'ETB - Colombia%' || 
  org like  'Etihad Atheeb Telecom Company%' || 
  org like  'Ettihad Etisalat%' || 
  org like  'Evergy S.A.%' || 
  org like  'Execulink Telecom Inc%' || 
  org like  'Hathway Cable and Datacom Pvt Ltd%' || 
  org like  'Hellas On Line S.A.%' || 
  org like  'Hutchison Global Communications%' || 
  org like  'Hutchison Max Telecom Limited%' || 
  org like  'IBM India PVT Ltd%' || 
  org like  'IDEA ISP Subscriber IP Pool%' || 
  org like  'iiNet Limited%' || 
  org like  'Internet Service Provider%' || 
  org like  'Internet Solutions%' || 
  org like  'Internode%' || 
  org like  'Kabel Baden-Wuerttemberg GmbH & Co. KG%' || 
  org like  'Korea Telecom%' || 
  org like  'Lg Powercomm%' || 
  org like  'Ling Wang Internet Co%' || 
  org like  'Link Egypt%' || 
  org like  'LINKdotNET Telecom Limited%' || 
  org like  'Massillon Cable Communications%' || 
  org like  'Maxis Broadband Sdn Bhd%' || 
  org like  'MCSNet%' || 
  org like  'Mediacom Communications Corp%' || 
  org like  'Mediacom Communications Corporation%' || 
  org like  'Midcontinent Media Inc%' || 
  org like  'Mikrotec Internet Services%' || 
  org like  'Neostrada Plus%' || 
  org like  'NetNet%' || 
  org like  'Network Solutions LLC%' || 
  org like  'North Central Communications%' || 
  org like  'Nysernet/WebGenesis%' || 
  org like  'OC3 Networks & Web Solutions, LLC%' || 
  org like  'Open Computer Network%' || 
  org like  'Orange mobile%' || 
  org like  'Orange WBC Broadband%' || 
  org like  'Oshean Inc%' || 
  org like  'Prima S.A.%' || 
  org like  'PT Excelcomindo Pratama%' || 
  org like  'PT Telkom Indonesia%' || 
  org like  'Railtel Corporati0n of India Ltd%' || 
  org like  'Romtelecom Data Network%' || 
  org like  'SAIC Inc%' || 
  org like  'Sky Broadband%' || 
  org like  'Smart Broadband Incorporated%' || 
  org like  'Spectranet Ltd%' || 
  org like  'SRT Communications Inc%' || 
  org like  'Starhub Broadband%' || 
  org like  'SureWest Broadband%' || 
  org like  'Swift Networks Limited%' || 
  org like  'Tek Channel Consulting LLC%' || 
  org like  'Telecommunication Services of Trinidad and Tobago%' || 
  org like  'Telefonica de Argentina%' || 
  org like  'Telkom SA Ltd%' || 
  org like  'Telmex Colombia S.A.%' || 
  org like  'Telstra Internet%' || 
  org like  'Tikona Digital Networks Pvt. Ltd.%' || 
  org like  'True Broadband by True Online%' || 
  org like  'True Internet%' || 
  org like  'Turkcell Internet%' || 
  org like  'UBTANET%' || 
  org like  'UNICOM ZheJiang Province Network%' || 
  org like  'United Technologies%' || 
  org like  'Vodafone ISP%' || 
  org like  'VTR Banda Ancha S.A.%' || 
  org like  'Wave Broadband%' || 
  org like  'WIND Telecomunicazioni S.p.A%' || 
  org like  'XS4ALL Internet BV%' || 
  org like  'YOU Telecom India Pvt Ltd%' || 
  org like  'YTL Communications Sdn Bhd%' || 
  org like  'Zscaler Inc%'
 ) ";
  
$ORGS2 =" (
  co like  'Administracion Nacional de Telecomunicaciones%' || 
  co like  'AJAY Syscon PVT Ltd%' || 
  co like  'Amnet Broadband Pty Ltd%' || 
  co like  'Asianet is a cable ISP providing%' || 
  co like  'AT&T%' || 
  co like  'Atlantic Telephone Membership Corp.%' || 
  co like  'Augere Wireless Broadband Bangladesh Limited%' || 
  co like  'Barracuda Networks Inc%' || 
  co like  'Batelco ADSL service%' || 
  co like  'Bayanat Al-Oula For Network Services%' || 
  co like  'Black Oak Computers%' || 
  co like  'Botswana Telecommunications Corporation%' || 
  co like  'BrightHouse Networks Bakersfield%' || 
  co like  'BrightHouse Networks Indianapolis%' || 
  co like  'Broadstripe%' || 
  co like  'BTC Broadband Service%' || 
  co like  'Cable Bahamas%' || 
  co like  'Cable Onda%' || 
  co like  'Cablemas Telecomunicaciones SA de CV%' || 
  co like  'Cablevision S.A.%' || 
  co like  'Central Wisconsin Communications LLC%' || 
  co like  'China Netcom Group Beijing Communication Company%' || 
  co like  'China TieTong Telecommunications Corporation%' || 
  co like  'China Unicom Beijing province network%' || 
  co like  'China Unicom Heibei Province Network%' || 
  co like  'China Unicom Henan province network%' || 
  co like  'China Unicom Liaoning province network%' || 
  co like  'China Unicom Shandong province network%' || 
  co like  'CHINANET Anhui PROVINCE NETWORK%' || 
  co like  'Chinanet Fujian Province Network%' || 
  co like  'CHINANET hebei province network%' || 
  co like  'CHINANET henan province network%' || 
  co like  'Chinanet Hubei Province Network%' || 
  co like  'Chinanet Hunan Province Network%' || 
  co like  'Chinanet Jiangsu Province Network%' || 
  co like  'Chinanet Jiangxi Province Network%' || 
  co like  'Chinanet Shaanxi Province Network%' || 
  co like  'ChinaNet Shanghai Province Network%' || 
  co like  'Chinanet Tianjin Province Network%' || 
  co like  'CHINANET-ZJ Hangzhou node network%' || 
  co like  'CHINANET-ZJ Huzhou node network%' || 
  co like  'CHINANET-ZJ Jiaxing node network%' || 
  co like  'CHINANET-ZJ Jinhua node network%' || 
  co like  'CHINANET-ZJ Ningbo node network%' || 
  co like  'CHINANET-ZJ Shaoxing node network%' || 
  co like  'CHINANET-ZJ Taizhou node network%' || 
  co like  'CHINANET-ZJ Wenzhou node network%' || 
  co like  'COLOMBIA TELECOMUNICACIONES S.A. ESP%' || 
  co like  'Columbus Communications Jamaica Limited%' || 
  co like  'Columbus Communications Trinidad Limited.%' || 
  co like  'Cyprus Telecommuncations Authority%' || 
  co like  'Dai IP su dung cho mang khach hang FTTH o HCMC%' || 
  co like  'Data Networks Inc%' || 
  co like  'DetectNetwork.US%' || 
  co like  'DiGi Telecommunications Sdn Bhd%' || 
  co like  'Digial Nirvana%' || 
  co like  'Dishnet Wireless Limited%' || 
  co like  'DSL Extreme%' || 
  co like  'EarthLink Ltd. Communications&Internet Services%' || 
  co like  'Elisa Oyj%' || 
  co like  'Ellijay Telephone Company%' || 
  co like  'Emirates Telecommunications Corporation%' || 
  co like  'EPB Telecom%' || 
  co like  'ETB - Colombia%' || 
  co like  'Etihad Atheeb Telecom Company%' || 
  co like  'Ettihad Etisalat%' || 
  co like  'Evergy S.A.%' || 
  co like  'Execulink Telecom Inc%' || 
  co like  'Hathway Cable and Datacom Pvt Ltd%' || 
  co like  'Hellas On Line S.A.%' || 
  co like  'Hutchison Global Communications%' || 
  co like  'Hutchison Max Telecom Limited%' || 
  co like  'IBM India PVT Ltd%' || 
  co like  'IDEA ISP Subscriber IP Pool%' || 
  co like  'iiNet Limited%' || 
  co like  'Internet Service Provider%' || 
  co like  'Internet Solutions%' || 
  co like  'Internode%' || 
  co like  'Kabel Baden-Wuerttemberg GmbH & Co. KG%' || 
  co like  'Korea Telecom%' || 
  co like  'Lg Powercomm%' || 
  co like  'Ling Wang Internet Co%' || 
  co like  'Link Egypt%' || 
  co like  'LINKdotNET Telecom Limited%' || 
  co like  'Massillon Cable Communications%' || 
  co like  'Maxis Broadband Sdn Bhd%' || 
  co like  'MCSNet%' || 
  co like  'Mediacom Communications Corp%' || 
  co like  'Mediacom Communications Corporation%' || 
  co like  'Midcontinent Media Inc%' || 
  co like  'Mikrotec Internet Services%' || 
  co like  'Neostrada Plus%' || 
  co like  'NetNet%' || 
  co like  'Network Solutions LLC%' || 
  co like  'North Central Communications%' || 
  co like  'Nysernet/WebGenesis%' || 
  co like  'OC3 Networks & Web Solutions, LLC%' || 
  co like  'Open Computer Network%' || 
  co like  'Orange mobile%' || 
  co like  'Orange WBC Broadband%' || 
  co like  'Oshean Inc%' || 
  co like  'Prima S.A.%' || 
  co like  'PT Excelcomindo Pratama%' || 
  co like  'PT Telkom Indonesia%' || 
  co like  'Railtel Corporati0n of India Ltd%' || 
  co like  'Romtelecom Data Network%' || 
  co like  'SAIC Inc%' || 
  co like  'Sky Broadband%' || 
  co like  'Smart Broadband Incorporated%' || 
  co like  'Spectranet Ltd%' || 
  co like  'SRT Communications Inc%' || 
  co like  'Starhub Broadband%' || 
  co like  'SureWest Broadband%' || 
  co like  'Swift Networks Limited%' || 
  co like  'Tek Channel Consulting LLC%' || 
  co like  'Telecommunication Services of Trinidad and Tobago%' || 
  co like  'Telefonica de Argentina%' || 
  co like  'Telkom SA Ltd%' || 
  co like  'Telmex Colombia S.A.%' || 
  co like  'Telstra Internet%' || 
  co like  'Tikona Digital Networks Pvt. Ltd.%' || 
  co like  'True Broadband by True Online%' || 
  co like  'True Internet%' || 
  co like  'Turkcell Internet%' || 
  co like  'UBTANET%' || 
  co like  'UNICOM ZheJiang Province Network%' || 
  co like  'United Technologies%' || 
  co like  'Vodafone ISP%' || 
  co like  'VTR Banda Ancha S.A.%' || 
  co like  'Wave Broadband%' || 
  co like  'WIND Telecomunicazioni S.p.A%' || 
  co like  'XS4ALL Internet BV%' || 
  co like  'YOU Telecom India Pvt Ltd%' || 
  co like  'YTL Communications Sdn Bhd%' || 
  co like  'Zscaler Inc%'
 ) ";

$ORGS =" (  org like  'Technocraft Industries%' ) ";
$ORGS2 =" (  co like  'Technocraft Industries%' ) ";
  
 
 
  
  # CATNAV 
  updateTable("update catnav_ipn".$year."_01  set isp='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_02  set isp='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_03  set isp='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_04  set isp='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_05  set isp='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_06  set isp='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_07  set isp='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_08  set isp='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_09  set isp='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_10  set isp='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_11  set isp='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_12  set isp='Y' where  $ORGS2   ");
 
 
  # NEWS 
  updateTable("update newsORGSITED$year    set isp='Y' where  $ORGS   and  $ADDDATE and oid>''");
  updateTable("update newsORGD$year        set isp='Y' where  $ORGS    and  $ADDDATE and acct>0    and oid>''");
  
  # TNET  
  updateTable("update  tnetlogORGSITED".$year."_01   set isp='Y' where  $ORGS    and  oid>''");
  updateTable("update  tnetlogORGSITED".$year."_02   set isp='Y' where  $ORGS    and  oid>''");
  updateTable("update  tnetlogORGSITED".$year."_03   set isp='Y' where  $ORGS    and  oid>''");
  updateTable("update  tnetlogORGSITED".$year."_04   set isp='Y' where  $ORGS    and  oid>''");
  updateTable("update  tnetlogORGSITED".$year."_05   set isp='Y' where  $ORGS    and  oid>''");
  updateTable("update  tnetlogORGSITED".$year."_06   set isp='Y' where  $ORGS    and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_07   set isp='Y' where  $ORGS    and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_08   set isp='Y' where  $ORGS    and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_09   set isp='Y' where  $ORGS    and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_10   set isp='Y' where  $ORGS    and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_11   set isp='Y' where  $ORGS    and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_12   set isp='Y' where  $ORGS    and  oid>''"); 
   
                                               
  updateTable("update  tnetlogORGD".$year."_01  set isp='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_02  set isp='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_03  set isp='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_04  set isp='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_05  set isp='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_06  set isp='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");  
  updateTable("update  tnetlogORGD".$year."_07  set isp='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_08  set isp='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_09  set isp='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_10  set isp='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_11  set isp='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_12  set isp='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");    
 

  updateTable("update tnetlogORGCATD".$year."_01    set isp='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_02    set isp='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_03    set isp='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_04    set isp='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_05    set isp='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_06    set isp='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_07    set isp='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_08    set isp='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_09    set isp='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_10    set isp='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_11    set isp='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_12    set isp='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  
  updateTable("update tnetlogORGN$year  set isp='Y' where  $ORGS    and   $ADDDATE ");
  updateTable("update tnetlogORGCATN$year  set isp='Y' where  $ORGS    and   $ADDDATE ");
  updateTable("delete from tnetlogADviewsServerOrg$year  where  $ORGS   ");
 
  # Reach local
  updateTable("update Campaign_IP set isp='Y' where  $ORGS2   and universal_id >''");

  # news image
  updateTable("delete from adcvmaster where  $ORGS   ");

  # visitor daily
  updateTable("update tnetlogORGdaily set isp='Y'  where  $ORGS   ");
 
 
  # Visitor Tool
  #  updateTable("update visitor_tool     set isp='Y' where  $ORGS     and oid>''");
  #  updateTable("update visitor_cat_tool set isp='Y' where  $ORGS     and oid>''");
  

  

    
close(wf);
  

print "\nDone...\n";

 



