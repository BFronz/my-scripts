#!/usr/bin/perl
#
#

use DBI;
require "/usr/wt/trd-reload.ph";

$fdate   = $ARGV[0];
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}
$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);

sub PrintQ
{
 $q = $_[0];
# print "\n$q\n";
}

$outfile = "Conversion-Action-Detail-New-" . $fdate . ".txt";
system("rm -f $outfile");
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");

print wf "Account Name\t";                      # $comp
print wf "Account Number\t";                    # $acct

print wf "Total User Sessions\t";               # $total_top_uses
print wf "Total Conversion Actions\t";          # $total_top_conv

print wf "Profile Views\t";                     # $profile
print wf "Links to Website\t";                  # $links

print wf "Total Ad Impressions\t";              # $adviews
print wf "Total Ad Clicks\t";                   # $aclicks
print wf "News Release Views\t";                # $newsviews

print wf "Links to Catalog/CAD\t";              # $linkscatalog
print wf "On-tnet Catalog Page Views\t";   # $caton
print wf "On-tnet Catalog RFQs\t";         # $catonrfq

print wf "Video Views\t";                       # $video
print wf "Document Views\t";                    # $docs
print wf "Image Views\t";                       # $imgviews
print wf "Social Media Links\t";                # $social

print wf "E-mail Sent to You\t";                # $email

print wf "Count of Unique Company / Org Names in Visitor Section\t"; # $visitors
print wf "Web Traxs\n";                         # $webtrax


$record[0]="12666|James Tool Machine & Engineering, Inc.";
$record[1]="27200|Felters";
$record[2]="29100|JILco";
$record[3]="29814|Rush Tool";
$record[4]="31316|Acme Spirally Wound Paper Products, Inc.";
$record[5]="33615|Process Technology";
$record[6]="36320|Filmtec, Inc.";
$record[7]="39931|Shan-Rod, Inc.";
$record[8]="42522|Fluid Systems Service, Inc.";
$record[9]="45254|Renewal Parts Maintenance, A Division of Mechanical Dynamics & Analysis, Ltd.";
$record[10]="100776|Bluff Manufacturing";
$record[11]="103810|Air Applications, Inc.";
$record[12]="106260|Tri-State Plating";
$record[13]="114151|Magellan Aerospace, Middletown, Inc. - Formerly Aeronca";
$record[14]="115342|Fountain Foundry";
$record[15]="115660|Andover Coils, LLC";
$record[16]="137727|Donsco";
$record[17]="139101|Stoner Inc.";
$record[18]="140246|Datacolor International";
$record[19]="140653|A & E Manufacturing Co., Inc.";
$record[20]="140892|Service Die Cutting & Packaging Corp.";
$record[21]="141946|Wilmington Fibre";
$record[22]="144092|Energy Products Co.";
$record[23]="144204|F.P. Woll & Co.";
$record[24]="147149|Graco Manufacturing";
$record[25]="159446|Welded Sheet Metal Specialty Co.";
$record[26]="161933|WHEMCO Steel Castings";
$record[27]="166463|Process Prototype, Inc.";
$record[28]="168797|Boyer Steel, Inc.";
$record[29]="170712|Eaton Steel Bar Co.";
$record[30]="170970|C & M Wire Rope & Supply Co., Inc.";
$record[31]="173953|Birdsall Tool & Gage";
$record[32]="181139|Kalamazoo Packaging Systems, Inc.";
$record[33]="181732|Inter-Lakes Bases, Inc.";
$record[34]="183350|Posa-Cut Corporation";
$record[35]="183430|Brooks Utility Products";
$record[36]="204194|Best Box Company, Inc.";
$record[37]="267529|Induction Technology Corporation";
$record[38]="310680|Able Office Solutions";
$record[39]="316924|Davidge Controls";
$record[40]="344495|Wright's Supply, Inc.";
$record[41]="379007|Bilbee Controls, Inc.";
$record[42]="385190|Encore Electronics, Inc.";
$record[43]="387081|Mearthane";
$record[44]="392301|Sparton Technology Corp.";
$record[45]="393156|Alden-Hauk, Inc.";
$record[46]="402577|Hitec Products, Inc.";
$record[47]="407595|Accurate Chemical & Scientific Corporation";
$record[48]="429600|Empire Pump & Motor";
$record[49]="432179|Midwest Scale Company";
$record[50]="432634|DeKalb Iron & Metal Co.";
$record[51]="438188|Industrial Modern Pattern & Mold Corp.";
$record[52]="443422|Environment Mechanical Services, Inc.";
$record[53]="452679|MTI Electronics, Inc.";
$record[54]="455779|Jagemann Stamping Company";
$record[55]="457434|Jifco Products, Inc.";
$record[56]="459624|Central Rent-A-Crane, Inc.";
$record[57]="466505|Excel Dryer, Inc.";
$record[58]="467380|Shepard Steel Company, Inc.";
$record[59]="473071|Curtis Universal Joint Co.";
$record[60]="473270|Scott Metal Finishing";
$record[61]="515361|Eldridge Products, Inc.";
$record[62]="530507|Pacific Powder Coating";
$record[63]="564164|Tarrant Service Agency, Inc.";
$record[64]="568735|Seaboard Fire & Safety";
$record[65]="570059|Kosson Aluminum & Glass Inc.";
$record[66]="570591|Culligan Industrial Water Systems";
$record[67]="570759|Uehling Instrument Co.";
$record[68]="575724|Fancort Industries";
$record[69]="582262|IBOCO";
$record[70]="582655|Gates Flag & Banner Company, Inc.";
$record[71]="591768|Menges Roller Co.";
$record[72]="593183|Kuhl Corp";
$record[73]="597009|Oakland Products";
$record[74]="600658|Webster Fuel Pumps & Valves";
$record[75]="623413|Packaging Progressions, Inc.";
$record[76]="634361|Dawn Scientific";
$record[77]="646609|Arra, Inc.";
$record[78]="668387|Zalco Laboratories, Inc.";
$record[79]="698541|Metro-Pack, Inc.";
$record[80]="700367|Spring Dynamics";
$record[81]="703804|Mac Divitt Rubber Co., LLC";
$record[82]="737574|Filter Pure Systems, Inc.";
$record[83]="791915|AM Metal Finishing, Inc.";
$record[84]="814052|Flow Components & Equipment Supply";
$record[85]="828319|Utitec, Inc.";
$record[86]="829333|HARCO";
$record[87]="838291|General Machine & Tool Co., Inc.";
$record[88]="950445|B & B Electro-Mechanical Components, Inc.";
$record[89]="955703|Southern Metals Co.";
$record[90]="956168|Kadet Products, Inc.";
$record[91]="979160|dataCon, Inc.";
$record[92]="979214|IN USA, Inc.";
$record[93]="987709|Newmar";
$record[94]="989147|Hotsy of Southern California";
$record[95]="1003367|Alta Equipment Co.";
$record[96]="1007696|Herold & Mielenz, Inc.";
$record[97]="1014136|General Equipment";
$record[98]="1017422|Graphic Communications, Inc.";
$record[99]="1029845|A.B. Duffy, Inc.";
$record[100]="1057494|Chantelau, Inc.";
$record[101]="1065593|Morris Kreitz & Sons, Inc.";
$record[102]="1081110|American Boom & Barrier Corp.";
$record[103]="1082453|Wakefield Paint Fair";
$record[104]="1082510|Superior Tool & Manufacturing Co., Inc.";
$record[105]="1082650|Frederiks Machine & Tool Co., Inc.";
$record[106]="1082683|Cambridge Chemical Cleaning, Inc.";
$record[107]="1082824|SayPack Co., Inc.";
$record[108]="1082877|Coregistics";
$record[109]="1083640|TCB Industrial, Inc.";
$record[110]="1095954|Roof Systems of Virginia, Inc.";
$record[111]="1098097|Precision Manufacturing Services, Inc.";
$record[112]="1103507|Hydraulics, Inc.";
$record[113]="1105995|Northwest Wire EDM, Inc.";
$record[114]="1107498|Atacs Products, Inc.";
$record[115]="1127864|Elite Lock & Key, Inc.";
$record[116]="1157286|Microbe Inotech Laboratories Inc.";
$record[117]="1160310|B.D.C. Inc.";
$record[118]="1164160|Microdyne Products Corp.";
$record[119]="1164259|Nedmac, Inc.";
$record[120]="1173100|N.T. Ruddock Co.";
$record[121]="1173211|Aim Processing, Inc.";
$record[122]="1203683|Popco, Inc.";
$record[123]="1210485|Grout Systems, Inc.";
$record[124]="1228870|SYSTAT - Critical Systems Protection Services";
$record[125]="1231832|Lofton Label";
$record[126]="1238536|Spectra Symbol";
$record[127]="1239738|Mechanical Dynamics & Analysis";
$record[128]="1252356|LDPI, Inc.";
$record[129]="1278122|Performance Engineering Group";
$record[130]="1282403|American Image Displays";
$record[131]="1284898|Aladdin Light Lift";
$record[132]="1287123|Willbanks Metals, Inc.";
$record[133]="1297311|Anchor Insulation";
$record[134]="1298579|Alliance Spacesystems, LLC";
$record[135]="1299421|Hughes Circuits, Inc.";
$record[136]="1299484|TSI Digital Media";
$record[137]="1305500|Industrial Waste Water Services";
$record[138]="1308758|Alpha Packaging, Inc.";
$record[139]="1310042|Keri Systems, Inc.";
$record[140]="10002822|Applied Motion Products, Inc.";
$record[141]="10008941|Commercial Plating Co. Inc.";
$record[142]="10010185|Custom Cylinders, Inc.";
$record[143]="10016195|Georg Fischer Piping Systems";
$record[144]="10016823|Grayling Industries";
$record[145]="10025697|Metrigraphics LLC.";
$record[146]="10030008|Peterson Filters Corp.";
$record[147]="10032703|Retco Tool Company";
$record[148]="10046769|Midwest Metal Products, Inc.";
$record[149]="10049469|Goldman Products, Inc.";
$record[150]="10056024|Cleveland City Forge";
$record[151]="10056471|Turtle Plastics";
$record[152]="10058155|Monoxivent";
$record[153]="10060382|Control Power Products, Inc.";
$record[154]="10063135|International Revolving Door Company";
$record[155]="10064494|Laser Technologies, Inc.";
$record[156]="10065712|Power Generation Service, A Subsidiary of Mechanical Dynamics & Analysis, Ltd.";
$record[157]="10070450|Wright Packaging";
$record[158]="10071421|Transhield, Inc.";
$record[159]="10073491|Neat Heat & Cooling";
$record[160]="10076727|Infinity Plastics Group";
$record[161]="10077331|GDP|GUHDO";
$record[162]="10077427|Gateway Laser Services";
$record[163]="10080386|Technical Equipment Sales";
$record[164]="10083489|Oster Manufacturing Company";
$record[165]="10084619|Val-Fab, Inc.";
$record[166]="10088354|FormaShape - A Division of WhiteWater Composites Ltd.";
$record[167]="10089920|GRM Circuits, Inc.";
$record[168]="10097825|Donnelly Bros Inc.";
$record[169]="10098249|INDO-MIM";
$record[170]="10100081|Etratech";
$record[171]="10108556|Setaram Inc.";
$record[172]="10109215|Bremskerl North America Inc.";
$record[173]="10111301|The Pilot Group";
$record[174]="10111525|Insulated Products Corp.";
$record[175]="10113281|3D Metal Fabrication";
$record[176]="20004151|Marktech Optoelectronics";
$record[177]="20044532|Givens International Drilling Supplies, Inc.";
$record[178]="20059041|IES 2000";
$record[179]="20071387|Angstrom Precision Optics";
$record[180]="20075402|Modular Connections, LLC";
$record[181]="20080335|American Tool Works";
$record[182]="20083189|Nutek Corp.";
$record[183]="20094573|Flatout Gaskets & Fabrications - A Division of Flatout Group, LLC.";
$record[184]="20094915|AZEVAP, Inc.";
$record[185]="20097406|Coast Label Company";
$record[186]="20097729|Catalyst Product Development Group";
$record[187]="20098085|G & L Clothing";
$record[188]="20099684|Hillman Supply Company, Inc.";
$record[189]="20102841|Daret, Inc.";
$record[190]="20105345|Prototype Productions, Inc";
$record[191]="30083460|Caztek, Inc.";
$record[192]="30089920|Thermal Edge Inc";
$record[193]="30094112|Mid-Plains Industries";
$record[194]="30094124|Southwest Fiberglass, LLC";
$record[195]="30094315|Precision Cut Industries";
$record[196]="30094820|Carma Industrial Coatings";
$record[197]="30099523|Orbex Group";
$record[198]="30116525|Star Thermoplastics";
$record[199]="30120433|Epic Materials, Inc.";
$record[200]="30167566|Turbo Parts, A Subsidiary of Mechanical Dynamics & Analysis, Ltd.";
$record[201]="30167589|Tru Cal International";
$record[202]="30173624|AMCS Corporation";
$record[203]="30177039|Miura America Co., Lt";
$record[204]="30183539|Aero Technical Components";
$record[205]="30187140|Lomont IMT";
$record[206]="30196403|V CORE Renewable Energies";
$record[207]="30236379|ISOmatrix, Inc.";
$record[208]="30270724|Heilind Electronics";
$record[209]="30270804|T.A. Barker Associates, LLC";
$record[210]="30305774|MCD Electronics Inc.";
$record[211]="30357210|CAT Technologies";
$record[212]="30362401|Network Installation Corp.";
$record[213]="30395076|Alber";
$record[214]="30402168|Central Valley Tank of California, Inc.";
$record[215]="30415988|PowerStream";
$record[216]="30419288|Thermocermet";
$record[217]="30462968|Bio Packaging Films";
$record[218]="30474668|APR Allen Plastics Repair, Inc.";
$record[219]="30520388|Vermont Abrasives Inc.";
$record[220]="30524588|Precision Prototyping & Manufacturing, Inc.";
$record[221]="30524768|International Trace";
$record[222]="30541788|JC Gibbons Manufacturing, Inc.";
$record[223]="30543068|Sarasota Precision Engineering";
$record[224]="30558768|Muscle Car Accessories";
$record[225]="30561408|Best Welded Mesh, Inc.";
$record[226]="30591968|Latest Concepts, Inc.";
$record[227]="30605228|Watco Industrial Flooring";
$record[228]="30629108|InfraTech Solutions";
$record[229]="30629668|Poly-Mart, Inc.";
$record[230]="30661571|Custom Solutions Manufacturing";
$record[231]="30667448|SRT Solutions";
$record[232]="30667795|Discover Global";
$record[233]="30669731|California Steam Specialties";
$record[234]="30671431|ViziClean";
$record[235]="30676012|Tricor Metals";
$record[236]="30694072|Safna";
$record[237]="30710322|Aspen Technologies Inc.";
$record[238]="30710561|Beck Prototypes, LLC";
$record[239]="30710762|TD&M Machining, LLC";
$record[240]="30714323|RCV Performance Products";
$record[241]="30715397|Innovative Manufacturing Solutions, LLC";
$record[242]="30715482|Packaging Quote.com";
$record[243]="30716375|Richwood Industries";
$record[244]="30716533|VIPA Controls America";
$record[245]="30716820|Ginn Manufacturing";
$record[246]="30718164|I.D. Systems";
$record[247]="30718678|Craft Electric, Inc.";
$record[248]="30719139|Global O-Ring and Seal, LLC";
$record[249]="30719625|Tecnoplast";
$record[250]="30719831|Supreme Powder Coatings";
$record[251]="30720039|Marathon Machine Technologies";
$record[252]="30720369|OEM Sales";
$record[253]="30721153|David-Link Fingerprint USA Corp.";
$record[254]="30721172|Lurcott Labs LLC";
$record[255]="30721280|Swepe-Tite LLC";
$record[256]="30721517|MBF Concepts, Inc.";
$record[257]="30721681|John Dsuban Spring Service Inc.";
$record[258]="30721699|Focused Laser Solutions LLC";
$record[259]="30721777|The Casting Company, Inc.";
$record[260]="30721956|Rittal Corporation";
$record[261]="30722017|Indiana Industrial Marketing";
$record[262]="30722124|Genesis Electronics Recycling, Inc.";
$record[263]="30722621|Accurate Thermal Systems LLC";
$record[264]="30722654|Hales Machine Tool, Inc";
$record[265]="30722844|Saturn Antennas, LLC";
$record[266]="30722924|Alpha Imaging Technologies";
$record[267]="30722978|Six Sigma Laser Services";
$record[268]="30723037|DDM Steel Services Inc.";
$record[269]="30723200|ACCU-PROduction Corp.";
$record[270]="30723682|ShopFloorConnect (a division of Wintriss Controls)";
$record[271]="30724534|David Purdie Associates LLC";
$record[272]="30725445|Rebulb LLC";
$record[273]="30728351|Lightning Stainless Bolt Inc.";
$record[274]="30728835|FAMS Printing";
$record[275]="30728969|Nanotech Industrial";
$record[276]="30729139|AeroSpec";
$record[277]="30729717|The Fifth Floor LLC";
$record[278]="30730062|Task Industrial";
$record[279]="30730153|Energy, Materials & Sustainability Consulting LLC, dba EMS Consulting LLC";
$record[280]="30730922|Chatter Free Tooling Solutions";
$record[281]="30731265|Garden State Iron, Inc.";
$record[282]="30732116|Moscow Mills, Inc. / Vibration Solutions North";
$record[283]="30732141|Houston-Johnson, Inc.";
$record[284]="30732185|Packaging Concepts Associates LLC";
$record[285]="30732269|Ceiling Outfitters";
$record[286]="30732291|CarTurner Inc.";
$record[287]="30732408|MILSPRAY Military Technologies, LLC";
$record[288]="30732472|RTI Laboratories, Inc.";
$record[289]="30732507|Aero-Flex Corp";
$record[290]="30732534|AVF Screw Machine LLC";
$record[291]="30732649|General Magnetics Corporation";
$record[292]="30732693|Msa";
$record[293]="30732711|Automation Control Panel Solutions, Inc";
$record[294]="30732741|Go Fan Yourself, Inc.";
$record[295]="30732791|Hagerstown Metal Fabricators";
$record[296]="30732823|Thermoforming Process Products, Inc.";
$record[297]="30732835|Alpha Magnet";
$record[298]="30732936|Illinois Pulley & Gear, Inc.";
$record[299]="30733158|Singer Laboratories";
$record[300]="30733239|Andros Washer & Stamping";
$record[301]="30733242|Premium Steel Sales";
$record[302]="30733334|Saigh Solutions LLC";
$record[303]="30733421|PostNet North Loop MN115";
$record[304]="30733456|Sandaka Inc.";
$record[305]="30733674|Southland Tool Mfg, Inc.";
$record[306]="30733711|Black Tie Products, LLC";
$record[307]="30733762|M&L Metals";
$record[308]="30733768|Absolute Welding & Consulting, LLC";
$record[309]="30733781|Trilliant Systems";
$record[310]="30733924|Imagine Fulfillment Services LLC";
$record[311]="30733935|Zod Automation LLC";
$record[312]="30733947|Capsonic Companies";
$record[313]="30734415|Xtreme Laser Marking";
$record[314]="30734548|Lake Michigan Metals Inc.";
$record[315]="30734593|Field Industries";
$record[316]="30734595|Great White Bags";
$record[317]="30734705|Bulk Material Lift";
$record[318]="30734887|AL-CON Architectural Products";
$record[319]="30734897|World Media Group";
$record[320]="30734913|Quantum CNC & Screw Machining";
$record[321]="30735152|GoPallet";
$record[322]="30735210|Scansite";
$record[323]="30739746|Penta Industries INC";
$record[324]="30745719|Vector Laboratories";
$record[325]="30745758|Bergen International, LLC";
$record[326]="30745900|American Global Standards LLC";
$record[327]="30745915|Sennco Solutions";
$record[328]="30746065|Jobsite Supply";
$record[329]="30746152|OEM Precision Products";
$record[330]="30746515|SSI, LLC";
$record[331]="30772128|I Lock New York Inc.";

$z=1;
foreach $record (@record)
{
 print "$z) $record\n";
 ($acct, $comp) = split(/\|/,$record);

 $acctmap = "0";
 $q = "SELECT dupe FROM tgrams.main_map WHERE prime='$acct' ";
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $acctmap = "$$row[0],";
  }
 $sth->finish;
 $acctmap .= $acct;

 $links = $profile = $email = $ecoll = $ccp = $linkscatalog = $total_top_conv = $total_top_cad =  $total_top_prodcat =  "0";
 $video =  $docs =  $imgviews =  $social = $total_top_uses = "0",
 $q  = "SELECT sum(ln) AS links, sum(pv) AS profile, sum(ca) AS email, ";
 $q .= "sum(ec) AS ecoll,  sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv) AS ccp, ";
 #$q .= "sum(lc) AS linkscatalog, ";
 $q .= "SUM(lc)+SUM(cl)  AS linkscatalog, ";
 $q .= "sum(pv) + sum(ln) + sum(cl) + sum(cv) + sum(ec) + sum(ca) + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv) + sum(lc) as tot , ";
 $q .= "sum(cd) as cad , ";
 $q .= "sum(pc) as prodcat, ";

 $q .= " sum(vv) as video, sum(dv) as docs, sum(iv) as imgviews, sum(sm) as social,  ";

 $q .= " sum(us) as us,    ";

 $q .= " sum(cl) as cadlinks    ";
 $q .= "FROM tnetlogARTU$yy WHERE acct in ($acctmap) and date = '$fdate' and covflag='t' ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $links              = $$row[0];
   $profile            = $$row[1];
   $email              = $$row[2];
   $ecoll              = $$row[3];
   $ccp                = $$row[4];
   $linkscatalog       = $$row[5];
   $total_top_conv     = $$row[6];
   $total_top_cad      = $$row[7];
   $total_top_prodcat  = $$row[8];

   $video              = $$row[9];
   $docs               = $$row[10];
   $imgviews           = $$row[11];
   $social             = $$row[12];

   $total_top_uses     = $$row[13];

   $cadlinks           = $$row[14];
  }
 $sth->finish;
if($total_top_uses==""){$total_top_uses="0";}
if(linkscatalog==0) {$linkscatalog>"0";}

 $totalpageviews = $totalemailpage = "0";
 $q  = "SELECT SUM(totalpageviews) AS totalpageviews, sum(totalInq + totalordrfqs) as totalemailpage ";
 $q .= "FROM thomflat_catnav_summmary$yy WHERE tgramsid IN ($acctmap) AND isactive='yes' AND date='$fdate' ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $totalpageviews = $$row[0];
   $totalemailpage = $$row[1];
  }
 $sth->finish;
 if($totalpageviews eq "") { $totalpageviews = "0";} if($totalemailpage eq "") {$totalemailpage = "0";}


 $newsviews = $linksweb = $totnews = 0;
 $q = "SELECT sum(nsv)  AS newsviews, sum(nlw)  AS linksweb,  sum(nsv) + sum(ncc) + sum(nes) + sum(nlw) AS totnews FROM thomnews_conversions$yy WHERE acct IN ($acctmap) AND date='$fdate' ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $newsviews = $$row[0];
   $linksweb  = $$row[1];
   $totnews   = $$row[2];
  }
 if($newsviews eq ""){$newsviews = "0";} if($linksweb eq ""){$linksweb = "0";}  if($totnews eq ""){$totnews = "0";}

 $adclicks =  $adviews = "0";
 $q = "SELECT sum(BannerClicks) AS adclicks, sum(BannerViews) AS adviews FROM thomnews_ad_cat$yy WHERE AdvertiserCid in ($acctmap) AND date='$fdate' AND badimg='N' ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $adclicks = $$row[0];
   $adviews  = $$row[1];
  }




 $q = "SELECT sum(clicks) AS adclicks, sum(views) AS adviews FROM thomtnetlogADviewsServer$yy WHERE acct IN ($acctmap) AND adtype ='pai' AND fdate='$fdate' ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $adclicks += $$row[0];
   $adviews  += $$row[1];
  }
 $q = "SELECT sum(clicks) AS adclicks, sum(views) AS adviews FROM thomtnetlogADviewsServer$yy WHERE acct IN ($acctmap) AND adtype ='bad' AND fdate='$fdate' ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $adclicks += $$row[0];
   $adviews  += $$row[1];
  }
 

 $visitor = "0";
 $q = "select count(distinct org) FROM thomtnetlogORGDAllM WHERE acct IN ($acctmap) AND isp='N' AND date='$fdate' ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $visitors = $$row[0];
  }
 

 $webtraxs = "0";
 $q = "SELECT if( count(*) > 0 , 'Y', 'N') from  tgrams.webtraxs_accts WHERE acct IN  ($acctmap)  ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $webtraxs = $$row[0];
  }

 
 $caton = $catonrfq = "0";
 $q = "SELECT SUM(totalpageviews) AS n, sum(totalInq) + sum(totalordrfqs) totalInq FROM thomflat_catnav_summmaryM WHERE tgramsid IN ($acctmap) AND date='$fdate'  ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $caton    = $$row[0];
   $catonrfq = $$row[1];
  }
 if($caton==""){$caton="0";} if($catonrfq==""){$catonrfq="0";} 

 
 $catoff = $catoffrfq = "0";
 $q = "SELECT SUM(totalpageviews) AS n, sum(totalInq) + sum(totalordrfqs) totalInq FROM thomcatnav_summmaryM WHERE tgramsid IN ($acctmap) AND date='$fdate'  ";
 PrintQ($q); 
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $catoff    = $$row[0];
   $catoffrfq = $$row[1];
  }
 if($catoff==""){$catoff="0";} if($catoffrfq==""){$catoffrfq="0";} 
  
 if($profile==""){$profile="0";} if($links==""){$links="0";} if($email==""){$email="0";} 
 if($video==""){$video="0";}  if($docs==""){$docs="0";}  if($imgviews==""){$imgviews="0";}  if($social==""){$social="0";}  if($linkscatalog==""){$linkscatalog="0";}  
     

 $total_top_conv += $totnews;
 $total_top_conv += $adclicks; 
 $total_top_conv += $catoff + $catoffrfq ;
 $total_top_conv += $caton + $catonrfq ;
 
 print wf "$comp\t";
 print wf "$acct\t";
 print wf "$total_top_uses\t";
 print wf "$total_top_conv\t";
 print wf "$profile\t";
 print wf "$links\t";
 print wf "$adviews\t";
 print wf "$adclicks\t";
 print wf "$newsviews\t";
 print wf "$linkscatalog\t";
 print wf "$caton\t";
 print wf "$catonrfq\t";
 print wf "$video\t";
 print wf "$docs\t";
 print wf "$imgviews\t";
 print wf "$social\t";
 print wf "$email\t";
 print wf "$visitors\t";
 print wf "$webtraxs\n";

 $z++;
}

close(wf);

$dbh->disconnect;

print "\n\nDone...\n\n";
