#!/usr/bin/perl
#
# update orgs that have been not flaged as isps

$year     = $ARGV[0];
if($year eq "") {print "\n\nForgot to add isp and or Year YY\n\n"; exit;}
$outfile="orgs-flag.log";
  
$ADDDATE="  date>''  "; 
 
# Connect to mysql database
use DBI;
$dbh      = DBI->connect("", "", "");

$unixtime    = time();
$z           = 1;  
$i           = 0;  
 
$ORGLIST="
'American Registry for Internet Numbers',
'CNCGROUP Beijing province network',
'SITA-Societe Internationale de Telecommunications Aeronautiques',
'Delphi Internet Services Corporation',
'Google Inc.',
'Hanaro Telecom Inc.',
'Net Access Corporation',
'AfriNIC - www.afrinic.net',
'Telecom Italia S.p.A. TIN EASY LITE',
'China United Telecommunications Corporation',
'Hanaro Telecom, Inc.',
'Turk Telekom ADSL-200K 2',
'Telecom Italia S.p.A.',
'CommuniTech',
'RIPE Network Coordination Centre',
'KSC Commercial Internet Co. Ltd.',
'kangbukbonbu',
'Q9 Networks Inc.',
'Intelcom Group',
'Nile Online',
'Telecom Italia Wireline Services',
'Hathway IP Over Cable Internet Access Service',
'Pacific Internet Limited',
'78 CS/SCSC',
'WorldCALL DotCom',
'AMP Corporate Telecommunications',
'IUnet',
'Telecom Italia NET',
'TDC BB-ADSL users',
'AF NET Internet Services',
'Bahrain Telecommunication Company',
'TelCove, Inc.',
'Globe Telecom',
'Fast Telco Infra Structure IP space',
'RKWL AUTOM/DS 3 INTERNET',
'Wave-Speed Networks, Inc.',
'GLOBAL SPEC',
'Please Send Abuse/SPAM complaints To Abuse@012.net',
'Bulgarian Telecommunications Company Plc.',
'Uninet',
'Beijing Teletron Telecom Engineering Co., Ltd.',
'T-Online ADSL clients',
'Syrian Telecommunications Establishment ( STE)',
'Telecommunication Company of Iran',
'Please Send Abuse/SPAM complaints To Abuse@012.net.il',
'DACOM Corporation',
'Thomas Register L L C',
'Please Send Abuse/SPAM complaints To Abuse-gilat@012.net.il',
'REED BUSINESS INFO',
'Indosat Internet Service Provider',
'EgyNet',
'Sri Lanka Telecom',
'B2 customer network',
'Japan Network Information Center',
'Gulfnet International Co.',
'Please Send Abuse/SPAM complaints',
'Ethiopian Telecommunication corporation',
'Wanadoo Nederland BV',
'93936',
'Eastern Telecoms Phils., Inc.',
'NOVIS TELECOM, S.A.',
'Tele2/SWIPnet',
'Freedom To Surf plc',
'Centrin Internet Service Provider',
'Please see http',
'CTCCommunications',
'So-net Service',
'Eclipse Networking',
'National Telecom Corporation',
'CAT TELECOM Data Comm. Dept, Intrenet Office',
'STE ISP Network 1',
'PT Telkom Divisi Regional V Jawa Timur',
'Meridian Telekoms Inc.',
'---------------',
'UPC Netherlands',
'UKOnline DSL customers',
'Skynet Belgium',
'Jazz Telecom S.A.',
'298724',
'Addresses IP for Home clients',
'PlusNet plc.',
'Jump Network Services S.R.L.',
'Bredbandsbolaget AB',
'Please Send Abuse/SPAM complaints to abuse@012.net - infra-aw',
'Thomas Industrial Network',
'jangbyunghwa',
',,AMIKOM',
'******************************************************',
'20',
'Ask Jeeves Inc.',
'310004',
'151',
'Please report all incidents of abuse and acceptable use',
'360595',
'94796',
'286918',
'133968',
'5',
'40',
'ARtelecom',
'----------------------',
'43528',
'- HKCIX -',
'World Access / Planet Internet',
'2143637169',
'67747',
'1346014',
'320994',
'284802',
',BRUK-BET',
'THOMAS PUBLISHING',
'BruNet, Jabatan Telekom Brunei Darussalam',
'NATIONWIDE BROKERAGE INC',
'Swisscom Fixnet AG',
'ReachLocal.com',
'Please Change Name-68224',
'AT&T Worldnet Services',
'ISP Cote d\\'Ivoire',
'Multiprotocol Service Provider to other ISP\\'s and End Users',
'AT&T Global Network Services',
'Netvision\\'s BroadBand service',
'AT&T Enhanced Network Services',
'PoundHost Internet Services',
'Cable & Wireless Panama S.A.',
'TT&T, Internet Service Provider, Bangkok, Thailand',
'Please Send Abuse/SPAM complaints To Abuse012.net.il',
'AT&T Worldnet IP Services',
'Cable & Wireless (Barbados) Limited',
'Nildram IP\\'s',
'Please Send Abuse/SPAM complaints To Abuse012.net',
'Please Send Abuse/SPAM complaints to abuse012.net - infra-aw',
'Please Send Abuse/SPAM complaints To Abuse-gilat012.net.il',
'Reed Business Information',
'Google, Inc.',
'Unknown',
'Thomas Technology Solutions, Inc.',
'Ask Jeeves UK',
'SUSAN AVON-051217023042',
'Please report all incidents of abuse and',
'Ask Jeeves',
'Thomas Publishing encompassing digital media and the internet',
'Google Incorporated',
'Google',
'Ask Jeeves Inc',
'Please Send Abuse/SPAM complaints To Abuse@012netil',
'Please Send Abuse/SPAM complaints To Abuse@012net',
'Thomas Industrial Network, Inc',
'thomas technology solutions inc.',
'total quality logistics',
'please send abusespam complaints to abuse012.net.il',
'please send abusespam complaints',
'se2.milwwia.20070227',
'industrial quick search',
'se2.milwwib.20070227',
'please send abusespam complaints to abuse012.net',
'thomas industrial network inc',
'google inc.10butj0001',
'thomas publishing encompassing digital media and the intern',
'globalspec',
'amino transport',
'se2.pltnca09072007-1130',
'thomas industrial network germany gmbh',
'please see httpwww.soft2you.com for further information.',
'please report improper use to tony.perssonlsn.se',
'se2.applwi.20080109',
'se2.lsanca.20071220',
'please mum',
'please hold',
'thomas international publishing india pvt ltd',
'please send abusespam complaints to abuse-gilat012.net.il',
'legal ip block for umts users in western cape vodacom',
'legal ip block for internet apn kwa-zulu natal 2g and 3g',
'legal ip block for internet apn gauteng 2g and 3g',
'legal ip block for internet apn pretoria2 2g and 3g',
'casestack inc',
'legal ip block for internet apn pretoria1 2g and 3g',
'legal ip block for umts users in kwa-zulu natal vodacom',
'thomas publishing company llc',
'please send abusespam complaints to abuse012.net.il.',
'reach local',
'reach local inc',
'67.136.113.0',
'67.136.10.0',
'67.136.101.0',
'67.136.114.0',
'67.136.100.0',
'67.136.102.0',
'67.136.105.0',
'67.136.104.0',
'67.136.106.0',
'67.136.107.0',
'67.136.110.0',
'reachlocal',
'zscaler inc.',
'67.136.108.0',
'67.136.118.0',
'67.136.111.0',
'67.136.103.0',
'67.136.116.0',
'67.136.109.0',
'67.136.117.0',
'67.136.112.0',
'67.136.119.0',
'please check cpni when ivan calls',
'thomas publishing company-horsham',
'this space is statically assigned',
'b2b design development',
'tnet-100720174412',
'67.136.100.024 - az - routed netblock',
'67.136.108.024 - az - routed netblock',
'67.136.111.024 - az- routed netblock',
'please send abusespam complaints to abuse012.',
'legal ip block for internet apn gauteng 2g an',
'legal ip block for internet apn pretoria1 2g',
'legal ip block for umts users in western cape',
'legal ip block for umts users in kwa-zulu nat',
'legal ip block for internet apn kwa-zulu nata',
'please report all incidents of abuse and acce',
'67.136.109.024 - az - routed netblock',
'67.136.106.024 - az - routed netblock',
'se2.emhril08082010-540',
'67.136.104.024 - az - routed netblock',
'67.136.102.024 - az - routed netblock',
'please see httpwww.agarik.com for further inf',
'se2.emhril08302010-419',
'67.136.117.024 - ut - routed netblock',
'please send spam abuse reports',
'67.136.118.024 - ut -routed netblock',
'67.136.112.024 - ut - routed netblock',
'globalspec inc',
'romtelecom s.a',
'ksc commercial internet co. ltd',
'se2.milwwib',
'dery telecom inc',
'se2.milwwia',
'af net',
'homecable-ap',
'uto bras',
'se2.pltnca',
'borregaard industrier',
'enter s.r.l',
'isi line srl',
'ezville',
'indosatm2 internet service provider',
'2012 adsl users',
'grand hyatt.',
's.c. at net s.r.l. bacau',
'total quality logistics inc',
'freightquote.com inc',
'total quality logistics llc',
'combined transport inc',
'supportsave solutions inc',
'xpo logistics inc',
'airline cargo services inc',
'schneider national inc',
'pittsburgh logistics systems inc',
'federal express',
'freightcenter inc',
'bnsf logistics llc',
'anderson trucking service inc',
'journey freight international inc',
'trinity logistics inc',
'c.h. robinson',
'key-james brick & supply inc',
'usf corporation',
'amino transport inc',
'all ways llc',
'one stop logistics inc',
'musket transport ltd',
'usf holland inc',
'blue-grace group llc',
'adams moncrief transports inc',
'cowan systems llc',
'comet transportation inc',
'unishippers global logistics llc',
'cargoways warehousing & trucking company inc',
'roadrunner freight system',
'its logistics inc',
'choptank transport inc',
'baggett transportation company',
'pacer transportation solutions inc',
'allan stuart & associates inc',
'apax partners of new york',
'babcock & wilcox technical services y-12 llc',
'bridge logistics inc',
'daniel burton dean inc',
'diedre moire corporation inc',
'global recruiters network inc',
'harvey & company llc',
'hobbs straus dean & walker llp',
'imc bv',
'indiana southern realtors association inc',
'klaus doc',
'management recruiters tallahassee inc',
'metro-boston insurance agency inc',
'monitor gp ia inc',
'northstar asset management llc',
'osl shipping and development inc',
'parkway school district parent-teachers organization council',
'reed business information inc',
'thai massage house',
'the arc of north carolina',
'the hastings group inc',
'the international institute of vocal arts inc',
'the october company inc',
'tilton school',
'whaley children\\'s center',
'woodland school',
'xpo logistics llc',
'******************************************************',
',,AMIKOM',
',BRUK-BET',
'- HKCIX -',
'---------------',
'----------------------',
'133968',
'1346014',
'151',
'20',
'2012 adsl users',
'2143637169',
'284802',
'286918',
'298724',
'310004',
'320994',
'360595',
'40',
'43528',
'5',
'67.136.10.0',
'67.136.100.0',
'67.136.100.024 - az - routed netblock',
'67.136.101.0',
'67.136.102.0',
'67.136.102.024 - az - routed netblock',
'67.136.103.0',
'67.136.104.0',
'67.136.104.024 - az - routed netblock',
'67.136.105.0',
'67.136.106.0',
'67.136.106.024 - az - routed netblock',
'67.136.107.0',
'67.136.108.0',
'67.136.108.024 - az - routed netblock',
'67.136.109.0',
'67.136.109.024 - az - routed netblock',
'67.136.110.0',
'67.136.111.0',
'67.136.111.024 - az- routed netblock',
'67.136.112.0',
'67.136.112.024 - ut - routed netblock',
'67.136.113.0',
'67.136.114.0',
'67.136.116.0',
'67.136.117.0',
'67.136.117.024 - ut - routed netblock',
'67.136.118.0',
'67.136.118.024 - ut -routed netblock',
'67.136.119.0',
'67747',
'78 CS/SCSC',
'93936',
'94796',
'adams moncrief transports inc',
'Addresses IP for Home clients',
'AfriNIC - www.afrinic.net',
'airline cargo services inc',
'all ways llc',
'allan stuart & associates inc',
'American Registry for Internet Numbers',
'amino transport',
'amino transport inc',
'anderson trucking service inc',
'apax partners of new york',
'Ask Jeeves',
'Ask Jeeves Inc',
'Ask Jeeves Inc.',
'Ask Jeeves UK',
'B2 customer network',
'b2b design development',
'babcock & wilcox technical services y-12 llc',
'baggett transportation company',
'blue-grace group llc',
'bnsf logistics llc',
'borregaard industrier',
'bridge logistics inc',
'c.h. robinson',
'cargoways warehousing & trucking company inc',
'casestack inc',
'choptank transport inc',
'combined transport inc',
'comet transportation inc',
'CommuniTech',
'conversion partners llc',
'cowan systems llc',
'CTCCommunications',
'daniel burton dean inc',
'davidson academy',
'diedre moire corporation inc',
'enter s.r.l',
'ezville',
'freightcenter inc',
'freightquote.com inc',
'global recruiters network inc',
'GLOBAL SPEC',
'globalspec',
'globalspec inc',
'Google',
'Google Inc.',
'google inc.10butj0001',
'Google Incorporated',
'Google, Inc.',
'harvey & company llc',
'hobbs straus dean & walker llp',
'imc bv',
'indiana southern realtors association inc',
'industrial quick search',
'isi line srl',
'its logistics inc',
'IUnet',
'jangbyunghwa',
'journey freight international inc',
'kangbukbonbu',
'klaus doc',
'legal ip block for internet apn gauteng 2g an',
'legal ip block for internet apn gauteng 2g and 3g',
'legal ip block for internet apn kwa-zulu nata',
'legal ip block for internet apn kwa-zulu natal 2g and 3g',
'legal ip block for internet apn pretoria1 2g',
'legal ip block for internet apn pretoria1 2g and 3g',
'legal ip block for internet apn pretoria2 2g and 3g',
'legal ip block for umts users in kwa-zulu nat',
'legal ip block for umts users in kwa-zulu natal vodacom',
'legal ip block for umts users in western cape',
'legal ip block for umts users in western cape vodacom',
'management recruiters tallahassee inc',
'metro-boston insurance agency inc',
'monitor gp ia inc',
'Multiprotocol Service Provider to other ISP\\'s and End Users',
'musket transport ltd',
'NATIONWIDE BROKERAGE INC',
'northstar asset management llc',
'one stop logistics inc',
'osl shipping and development inc',
'pacer international',
'pacer transportation solutions inc',
'parkway school district parent-teachers organization council',
'pittsburgh logistics systems inc',
'Please Change Name-68224',
'please check cpni when ivan calls',
'please hold',
'please mum',
'Please report all incidents of abuse and',
'please report all incidents of abuse and acce',
'Please report all incidents of abuse and acceptable use',
'please report improper use to tony.perssonlsn.se',
'Please see http',
'please see httpwww.agarik.com for further inf',
'please see httpwww.soft2you.com for further information.',
'Please Send Abuse/SPAM complaints',
'Please Send Abuse/SPAM complaints To Abuse-gilat012.net.il',
'Please Send Abuse/SPAM complaints To Abuse-gilat@012.net.il',
'Please Send Abuse/SPAM complaints To Abuse012.net',
'Please Send Abuse/SPAM complaints to abuse012.net - infra-aw',
'Please Send Abuse/SPAM complaints To Abuse012.net.il',
'Please Send Abuse/SPAM complaints To Abuse@012.net',
'Please Send Abuse/SPAM complaints to abuse@012.net - infra-aw',
'Please Send Abuse/SPAM complaints To Abuse@012.net.il',
'Please Send Abuse/SPAM complaints To Abuse@012net',
'Please Send Abuse/SPAM complaints To Abuse@012netil',
'please send abusespam complaints',
'please send abusespam complaints to abuse-gilat012.net.il',
'please send abusespam complaints to abuse012.',
'please send abusespam complaints to abuse012.net',
'please send abusespam complaints to abuse012.net.il',
'please send abusespam complaints to abuse012.net.il.',
'please send spam abuse reports',
'pricewaterhousecoopers llp',
'reach local',
'reach local inc',
'reachlocal',
'ReachLocal.com',
'REED BUSINESS INFO',
'Reed Business Information',
'reed business information inc',
'RIPE Network Coordination Centre',
'roadrunner freight system',
's.c. at net s.r.l. bacau',
'se2.applwi.20080109',
'se2.emhril08082010-540',
'se2.emhril08302010-419',
'se2.lsanca.20071220',
'se2.milwwia',
'se2.milwwia.20070227',
'se2.milwwib',
'se2.milwwib.20070227',
'se2.pltnca',
'se2.pltnca09072007-1130',
'supportsave solutions inc',
'SUSAN AVON-051217023042',
'thai massage house',
'the arc of north carolina',
'the blackstone group lp',
'the hastings group inc',
'the international institute of vocal arts inc',
'the october company inc',
'this space is statically assigned',
'Thomas Industrial Network',
'thomas industrial network germany gmbh',
'thomas industrial network inc',
'Thomas Industrial Network, Inc',
'thomas international publishing india pvt ltd',
'THOMAS PUBLISHING',
'Thomas Publishing Company LLC',
'thomas publishing company-horsham',
'thomas publishing encompassing digital media and the intern',
'Thomas Publishing encompassing digital media and the internet',
'Thomas Register L L C',
'thomas technology solutions inc.',
'Thomas Technology Solutions, Inc.',
'tnet-100720174412',
'tilton school',
'total quality logistics inc',
'total quality logistics llc',
'trinity logistics inc',
'unishippers global logistics llc',
'Unknown',
'UPC Netherlands',
'usf corporation',
'usf holland inc',
'uto bras',
'Wanadoo Nederland BV',
'whaley children\\'s center',
'woodland school',
'WorldCALL DotCom',
'xpo logistics inc',
'xpo logistics llc'
";

                
$ORGS ="  org in  ( $ORGLIST )   ";
$ORGS2 ="  co in (   $ORGLIST   )   ";
   
  

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

 #VTOOL
 updateTable("delete from  vtool11_05   where  $ORGS   "); 
 updateTable("delete from  vtool11_06   where  $ORGS   "); 
 updateTable("delete from  vtool11_07   where  $ORGS   "); 
 updateTable("delete from  vtool11_08   where  $ORGS   "); 
 updateTable("delete from  vtool11_09   where  $ORGS   "); 
 updateTable("delete from  vtool11_10   where  $ORGS   "); 
 updateTable("delete from  vtool11_11   where  $ORGS   "); 
 updateTable("delete from  vtool11_12   where  $ORGS   "); 
 updateTable("delete from  vtool12_01   where  $ORGS   "); 
 updateTable("delete from  vtool12_02   where  $ORGS   "); 
 updateTable("delete from  vtool12_03   where  $ORGS   "); 
 updateTable("delete from  vtool12_04   where  $ORGS   "); 
 updateTable("delete from  vtool12_05   where  $ORGS   "); 
 updateTable("delete from  vtool12_06   where  $ORGS   "); 
 updateTable("delete from  vtool12_07   where  $ORGS   "); 
 updateTable("delete from  vtool12_08   where  $ORGS   "); 
 updateTable("delete from  vtool12_09   where  $ORGS   "); 
 updateTable("delete from  vtool12_10   where  $ORGS   "); 
 updateTable("delete from  vtool12_11   where  $ORGS   "); 
 updateTable("delete from  vtool12_12   where  $ORGS   "); 
 updateTable("delete from  vtool13_01   where  $ORGS   "); 
 updateTable("delete from  vtool13_02   where  $ORGS   "); 
 updateTable("delete from  vtool13_03   where  $ORGS   "); 
 updateTable("delete from  vtool13_04   where  $ORGS   "); 
 updateTable("delete from  vtool13_05   where  $ORGS   "); 
 updateTable("delete from  vtool13_06   where  $ORGS   "); 
 updateTable("delete from  vtool13_07   where  $ORGS   "); 
 updateTable("delete from  vtool13_08   where  $ORGS   "); 
 updateTable("delete from  vtool13_09   where  $ORGS   "); 
 updateTable("delete from  vtool13_10   where  $ORGS   "); 

  
 
 updateTable("update tnetlogORGPS13_01   set block='Y' where  $ORGS   ");           
 updateTable("update tnetlogORGPS13_02   set block='Y' where  $ORGS   ");           
 updateTable("update tnetlogORGPS13_03   set block='Y' where  $ORGS   ");           
 updateTable("update tnetlogORGPS13_04   set block='Y' where  $ORGS   ");           
 updateTable("update tnetlogORGPS13_05   set block='Y' where  $ORGS   ");           
 updateTable("update tnetlogORGPS13_06   set block='Y' where  $ORGS   ");           
 updateTable("update tnetlogORGPS13_07   set block='Y' where  $ORGS   ");           
 updateTable("update tnetlogORGPS13_08   set block='Y' where  $ORGS   ");           
 updateTable("update tnetlogORGPS13_09   set block='Y' where  $ORGS   ");           
 updateTable("update tnetlogORGPS13_10   set block='Y' where  $ORGS   ");           
 updateTable("update tnetlogORGPS13_11   set block='Y' where  $ORGS   ");           
 updateTable("update tnetlogORGPS13_12   set block='Y' where  $ORGS   ");           


   
  # CATNAV 
  updateTable("update catnav_ipn".$year."_01  set block='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_02  set block='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_03  set block='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_04  set block='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_05  set block='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_06  set block='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_07  set block='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_08  set block='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_09  set block='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_10  set block='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_11  set block='Y' where  $ORGS2   ");
  updateTable("update catnav_ipn".$year."_12  set block='Y' where  $ORGS2   ");
 
 
  # NEWS 
  updateTable("update newsORGSITED$year    set block='Y' where  $ORGS   and  $ADDDATE and oid>''");
  updateTable("update newsORGD$year        set block='Y' where  $ORGS    and  $ADDDATE and acct>0    and oid>''");
  
  # TNET  
  updateTable("update  tnetlogORGSITED".$year."_01   set block='Y' where  $ORGS    and  oid>''");
  updateTable("update  tnetlogORGSITED".$year."_02   set block='Y' where  $ORGS    and  oid>''");
  updateTable("update  tnetlogORGSITED".$year."_03   set block='Y' where  $ORGS    and  oid>''");
  updateTable("update  tnetlogORGSITED".$year."_04   set block='Y' where  $ORGS    and  oid>''");
  updateTable("update  tnetlogORGSITED".$year."_05   set block='Y' where  $ORGS    and  oid>''");
  updateTable("update  tnetlogORGSITED".$year."_06   set block='Y' where  $ORGS    and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_07   set block='Y' where  $ORGS    and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_08   set block='Y' where  $ORGS    and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_09   set block='Y' where  $ORGS    and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_10   set block='Y' where  $ORGS    and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_11   set block='Y' where  $ORGS    and  oid>''"); 
  updateTable("update  tnetlogORGSITED".$year."_12   set block='Y' where  $ORGS    and  oid>''"); 
   
                                               
  updateTable("update  tnetlogORGD".$year."_01  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_02  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_03  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_04  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_05  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_06  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");  
  updateTable("update  tnetlogORGD".$year."_07  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_08  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_09  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_10  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_11  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");
  updateTable("update  tnetlogORGD".$year."_12  set block='Y' where  $ORGS    and   $ADDDATE and acct>0    and oid>''");    
 

  updateTable("update tnetlogORGCATD".$year."_01    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_02    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_03    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_04    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_05    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_06    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_07    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_08    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_09    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_10    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_11    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  updateTable("update tnetlogORGCATD".$year."_12    set block='Y' where  $ORGS    and   $ADDDATE and heading>0 and oid>''");
  
  updateTable("update tnetlogORGN$year  set block='Y' where  $ORGS    and   $ADDDATE ");
  updateTable("update tnetlogORGCATN$year  set block='Y' where  $ORGS    and   $ADDDATE ");
  updateTable("delete from tnetlogADviewsServerOrg$year  where  $ORGS   ");
  
  # Reach local
   updateTable("delete from Campaign_IP  where  $ORGS2   and universal_id >''");

 # news image
  updateTable("delete from adcvmaster where  $ORGS   ");
 
 
 # Visitor Tool
  updateTable("update visitor_tool     set block='Y' where  $ORGS     and oid>''");
  updateTable("update visitor_cat_tool set block='Y' where  $ORGS     and oid>''");

 updateTable("delete from tnetlogADviewsServerOrg$year  where  $ORGS  ");
    
close(wf);
  

print "\nDone...\n";

 



