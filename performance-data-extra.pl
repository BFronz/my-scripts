#!/usr/bin/perl
#
#

use DBI;

# isotope  connect
$data_source_iso = "dbi:mysql:sodm_rank:isotope.rds.c.net";
$user_iso        = "tnet";
$auth_iso        = "7zLdNrISma6Uft";
$dbh_iso         = DBI->connect($data_source_iso, $user_iso, $auth_iso);

# phobus connect
require "/usr/wt/trd-reload.ph";

$unixtime    = time();
#$debug=1;
 
sub AddSlashes {
    $text = shift;
    ## Make sure to do the backslash first!
    $text =~ s/\\/\\\\/g;
    $text =~ s/'/\\'/g;
    $text =~ s/"/\\"/g;
    $text =~ s/\\0/\\\\0/g;
    return $text;
}

$now_string = localtime;
print "$now_string\n\n";
 
$rdate = " '1602','1603','1604','1605','1606','1607','1608','1609','1610','1611','1612','1701' ";
 
$acctlist="
  1082617,
 30370885,
 30228591,
    30503,
   152365,
  1311596,
 30173360,
   492039,
 20055179,
   403438,
   973229,
   163969,
  1076877,
   618747,
   654018,
 10109706,
 30797840,
   144207,
 10076590,
 10049807,
 10021528,
    28548,
 30610688,
   686384,
 10008800,
   178906,
  1076718,
  1102874,
   453606,
 30209109,
   403623,
  1200093,
  1043986,
  1242437,
   141047,
 30714606,
 30811484,
 10046380,
 30718704,
  1295090,
 10065980,
 10048941,
   159640,
 30092436,
   438362,
  1142695,
   325597,
 30796290,
   502958,
   166014,
   364330,
   674651,
  1082768,
   708745,
 30792030,
   140922,
 30718102,
   582450,
   149593,
    38922,
 30132261,
   183113,
   431597,
 30796158,
   398110,
 30186756,
 10046806,
   640574,
   433558,
    22457,
  1161292,
  1298193,
  1306794,
 10113500,
    40085,
 20095181,
 30084781,
 30577589,
 30117269,
   180155,
   111213,
 30108219,
   901414,
 30783282,
     8665,
   370767,
   168148,
 10074177,
 30723759,
  1264384,
 30714399,
   802598,
   520001,
   148967,
   425229,
   141749,
   144221,
   164124,
   160138,
   430911,
   469043,
   152838,
    11000,
   472547,
   124001,
   130233,
   635433,
 30593008,
   656418,
  1082407,
 30796253,
 30778236,
   126358,
    32036,
   584915,
   585677,
 10028178,
   458667,
 20087159,
    37195,
   564168,
   987938,
   134951,
   104888,
 30463412,
 30795944,
  1176978,
   453632,
   540948,
   472775,
 10075843,
   137353,
 10034827,
 30596988,
 10073406,
  1082990,
  1170865,
   474204,
   152489,
  1178191,
   164150,
   416209,
   162920,
 10112004,
 30213950,
 30198892,
   651037,
 30250577,
  1161903,
 30284624,
 30670252,
  1056625,
   452217,
  1082524,
   398754,
 10107631,
   177845,
 30783656,
  1091950,
    43042,
 10073895,
   109858,
  1082792,
   152295,
   400867,
   173890,
   980717,
 30806973,
   102072,
   963197,
 30714904,
  1314581,
 30234897,
   130762,
  1032588,
    27765,
   577688,
  1040172,
 10039497,
  1029459,
   609527,
 30112262,
   390929,
 30122068,
 30817583,
 30363004,
   867877,
   140956,
 30311866,
 30718542,
  1269690,
   377556,
  1078564,
  1282481,
  1113923,
   454696,
 30229252,
     9057,
 30120832,
   591395,
  1074597,
 10087145,
    43977,
  1065561,
 30810460,
 30763971,
   452832,
 10080924,
  1082784,
  1038926,
   582541,
   453536,
   151997,
   358292,
   958507,
   748823,
  1067415,
 30383904,
 30319264,
 30818053,
   486247,
 30644108,
   405322,
  1314646,
  1082699,
      447,
 30731105,
   853018,
   940626,
  1291396,
   162115,
  1163427,
 30296544,
   836530,
 20000127,
    99579,
 20014780,
 30804602,
  1250454,
   163911,
   185325,
  1280574,
   175112,
  1040023,
    42580,
   402521,
 30816283,
 10113575,
   696146,
   399768,
    43296,
  1002839,
 20003877,
 30727195,
 30678292,
  1296040,
 30785196,
   437194,
  1079869,
 20100957,
 30819663,
 30574193,
 30218971,
 30650748,
  1274382,
 30689605,
   402625,
   833617,
 30787977,
 30198754,
   170772,
   424579,
   172683,
   423121,
  1280522,
   195617,
   136003,
   151056,
 20042099,
 30661654,
   426176,
   109167,
  1019720,
 30280584,
 10113690,
   651085,
   188280,
 30816218,
   452870,
   443825,
 30813916,
   457044,
    19692,
   142360,
   961055,
 30748431,
  1288651,
    51175,
   145864,
 20055772,
   122279,
 30199787,
 30714697,
 30084773,
   773802,
  1000841,
   505956,
   522829,
  1082553,
   738648,
   645948,
   996953,
 30233443,
   145758,
   974691,
 30796293,
   108645,
   693394,
  1305914,
  1284414,
   393222,
   980040,
   297610,
   329358,
   367536,
 30101687,
 30187459,
  1163948,
   113253,
   455939,
    51172,
 30346244,
   359554,
  1123731,
  1300558,
    95781,
   161193,
  1194838,
   957901,
 30539388,
  1148402,
   834082,
   211444,
   479966,
   376904,
  1112819,
   169430,
 10062573,
   956920,
 30730671,
 20079034,
 30669866,
  1082680,
  1082449,
 30747448,
 30718048,
   127762,
   963708,
   459016,
   368187,
 30198010,
  1121235,
   347326,
 30731514,
    32908,
   450352,
 30792646,
   362461,
 30773193,
   990635,
 30804381,
   562747,
 10031935,
    29055,
 30370524,
  1107087,
   714501,
 10027072,
   563022,
 30082861,
  1295331,
 20072568,
  1018432,
 30286019,
   490601,
    95696,
 30759232,
  1002060,
  1167266,
 20069594,
  1282682,
  1110354,
  1076822,
 30723846,
   507463,
 10075013,
 30512228,
   152353,
  1041306,
   996143,
     8936,
    40321,
 30251804,
    46883,
 30396108,
 30727868,
   431692,
 30725001,
   522328,
  1154329,
 20046659,
   367742,
  1131901,
 30789891,
   162906,
 30719557,
 30291744,
  1292411,
  1303827,
 10058825,
    97370,
   710004,
 30367685,
  1285622,
  1057949,
   345243,
  1222067,
   564872,
  1123073,
 30218390,
    33591,
 10108092,
   704078,
  1141839,
  1070499,
 30410148,
  1281304,
    35540,
   290972,
 20047268,
   298240,
  1106838,
   370029,
  1189320,
   146576,
    42891,
 30819011,
 10112024,
 30716202,
   995712,
 30394600,
   455251,
  1082612,
  1006869,
   190328,
   291474,
   632433,
 30146019,
  1255514,
   271215,
   439512,
  1311662,
   455516,
 30735633,
   590548,
  1284792,
 10098285,
   203576,
 30347996,
     1820,
 20073211,
   635591,
   797977,
 30122910,
  1165932,
 30724893,
  1082976,
 30117587,
   100181,
  1031584,
   189547,
 20076261,
   969996,
 30084281,
   304913,
   622151,
   707659,
 20079014,
   124504,
 30804543,
   676524,
   686625,
   150552,
   181622,
  1082587,
 30796350,
    25536,
  1275519,
 30230151,
 30093633,
   132962,
   508875,
   697087,
   378907,
   999303,
   110283,
 10076199,
 30716458,
 10060888,
 20038448,
   522827,
 20023170,
  1286332,
  1295191,
  1082703,
  1281420,
 20100574,
   777685,
 30083422,
   568573,
  1006859,
 30242617,
 30687245,
 20068548,
   474191,
   474055,
    38190,
   424325,
  1139883,
   278996,
  1089484,
 30597572,
 30219372,
  1308916,
 30119492,
 30087660,
 30788997,
 30277784,
 30144282,
  1082781,
 20000407,
 30086357,
    79690,
   150533,
 30337267,
 10031013,
 30724845,
 10108755,
  1082620,
 30735158,
 30641668,
    96456,
  1278455,
    82272,
   712834,
    30297,
 10084142,
    79822,
 30084061,
   563265,
   963878,
  1174774,
   987525,
   492388,
   431599,
   751688,
   661633,
  1291958,
   505482,
  1270855,
 20048472,
  1303931,
 10096889,
 30235184,
 20077766,
   333891,
  1170803,
   178012,
    40195,
   486426,
   270036,
 30791589,
  1279903,
   838808,
   805026,
  1305359,
 30433797,
 30120912,
  1082762,
   183419,
   378511,
 30712368,
 30167312,
   598649,
  1298623,
  1213275,
   999736,
    53040,
   967272,
   439553,
 30675172,
   175210,
   451069,
 30795548,
 30502488,
   707073,
 30778766,
   370487,
   710498,
  1067454,
  1309574,
 30817548,
   578499,
 30725984,
   151117,
  1268837,
 20037969,
   175628,
     2099,
 30678212,
 30240383,
     2066,
   148810,
   704087,
   569121,
  1120467,
      817,
   551352,
 30805757,
  1106784,
 10004786,
   602583,
  1300520,
 30820955,
    42758,
   462014,
 30085041,
  1128989,
 30787719,
 30085125,
 30643128,
   188763,
   458704,
   454049,
 20074842,
 30804733,
   446378,
   526486,
  1082539,
  1037747,
   996071,
 30451648,
   266606,
 10065555,
   735420,
   711065,
  1123281,
   575397,
   620931,
 30812084,
   435267,
 30165881,
   468492,
   755388,
 30807024,
 30088277,
 30252115,
  1041196,
   295361,
     6704,
 30724202,
 30715243,
  1102382,
 30817808,
 30732166,
 30730856,
   696248,
  1295968,
 30087715,
 30767196,
   694716,
 30210471,
  1047623,
   349976,
 30375064,
  1293724,
  1077719,
 10071323,
 30720670,
 30728115,
 30720605,
 30583408,
 10111485,
  1157683,
   708787,
 30700912,
  1103786,
 30140642,
 30726013,
    14337,
   457042,
 20077429,
 10107277,
   382486,
   574958,
 30728558,
   958668,
 30183752,
  1314630,
   405690,
    28035,
   557089,
 30348300,
    29255,
   414468,
  1291503,
   959686,
   572310,
 30609950,
 30729085,
   398270,
 30717821,
   108649,
   446210,
 30440969,
 30456448,
 10112993,
   607455,
   371523,
 30290144,
  1003266,
 30533588,
  1298750,
  1082801,
 10040310,
 20004041,
 30731749,
   354122,
  1305284,
 30723244,
    40158,
   148883,
 30331344,
 30710521,
   443500,
  1082832,
   168064,
 20083539,
   424141,
 30589550,
 30682072,
   122569,
   395164,
  1289102,
 30088664,
 30728220,
   582775,
  1281388,
    32946,
 30597728,
  1082846,
 20095408,
 30775019,
 20077029,
 30670401,
   211932,
 30790781,
   713340,
 30115875,
  1302620,
 30789911,
 30716913,
 30168260,
   118835,
   932117,
   492807,
   507361,
  1300860,
 30157059,
 30107439,
    98469,
   776263,
 30102180,
 30772067,
   170698,
  1317197,
   796008,
   156940,
 30585230,
 30127391,
 30788072,
   956140,
   456402,
   493288,
   138278,
 30602548,
   996090,
   125124,
 20081249,
 30286484,
  1073071,
   126554,
   484219,
 30180259,
   203503,
   827901,
 30728586,
   227725,
   431424,
 30163422,
 10034652,
  1009205,
 30726816";


   
# get companies
$query  =  "select company, acct from tgrams.main where acct in ($acctlist) order by company  "; 
#$query  =  "select m.company, m.acct FROM tgrams.main as m, thomtnetlogARTU as d WHERE m.acct=d.acct and date in ($rdate) group by m.acct ";
#print "\n$query\n"; exit;
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
        $record[$i] = "$$row[0]\t$$row[1]";
        
        $i++;
}
$sth->finish;
  
  

$outfile2 = "PerformanceDataforSelfServeComparison-Extra.txt";
open(wf, ">$outfile2")  || die (print "Could not open $outfile2\n");
print wf "Account Name\tTGRAMS#\tRank Points\t# of Listings (paid and unpaid)\tUser Sessions\tConversions\tProfile Views\tLinks to Website\tRFI Count (all vetting types - total count)\tProgram Cycle Start Date\n";
 
$j=1;
foreach $record (@record)
{
	($comp,$acct) = split(/\t/,$record);
	print "$j. $comp\t$acct\n";  
 
   	 $rank =0;
	$q = "select sum(pop) from thomposition17Q1  where acct=$acct and cov='NA'";
 	my $sth = $dbh->prepare($q);
 	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  	while (my $row = $sth->fetchrow_arrayref)
  	{  
                $rank = $$row[0];
        }
        $sth->finish;

    
	if($rank eq "" || $rank eq "0"){ 
	$rows=0;
	$q = "select cov,sum(pop) from thomposition17Q1 where acct=$acct and pop>0 group by cov";
 	my $sth = $dbh->prepare($q);
 	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  	while (my $row = $sth->fetchrow_arrayref)
  	{  
                $cov  = $$row[0];
                $cpop = $$row[1];
		$row++;
		#print "$cov\t$cpop\n";
        }
        $sth->finish;  
	$rank = $cpop - $row;
	#print "rank: $rank\n";
	}	  
	if( $rank eq "") { $rank="0";} 

 
	$q = "select count(distinct heading) from thomposition17Q1  where acct=$acct ";
 	my $sth = $dbh->prepare($q);
 	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  	while (my $row = $sth->fetchrow_arrayref)
  	{
                $listings = $$row[0];
        }
        $sth->finish; 

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

        $total_top_conv = $profile = $us = $links ="0";
 	$q  = "SELECT sum(us) AS uses, sum(pv) AS profile, sum(ln) AS links, ";
 	$q .= "sum(pv) + sum(ln) + sum(cl) + sum(cv) + sum(ec) + sum(ca) + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv) + sum(lc) as tot,  ";
	$q .= " sum(ca) AS cont ";
   	$q .= "FROM tnetlogARTU WHERE acct in ($acctmap) and date in ($rdate) and covflag='t' ";
 	my $sth = $dbh->prepare($q);
 	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 	while (my $row = $sth->fetchrow_arrayref)
  	{
   	$us              = $$row[0];
   	$profile         = $$row[1];
   	$links           = $$row[2];
   	$total_top_conv  = $$row[3];
   	$rfi             = $$row[4];
  	 } 
 	$sth->finish;
	if($total_top_conv==""){$total_top_conv="0";}
	if($profile=="")       {$profile="0";}
	if($us==""){$us="0";}
	if($links==""){$links="0";}
	if($rfi==""){$rfi="0";}
 
 
 
 	$newsviews = $linksweb = $totnews = 0;
 	$q = "SELECT sum(nsv)  AS newsviews, sum(nlw)  AS linksweb,  sum(nsv) + sum(ncc) + sum(nes) + sum(nlw) AS totnews FROM thomnews_conversions WHERE acct IN ($acctmap) AND date in ($rdate) ";
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
 	$q = "SELECT sum(BannerClicks) AS adclicks, sum(BannerViews) AS adviews FROM thomnews_ad_cat WHERE AdvertiserCid in ($acctmap) AND date in ($rdate)  AND badimg='N' ";
 	my $sth = $dbh->prepare($q);
 	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	 while (my $row = $sth->fetchrow_arrayref)
  	{
   	$adclicks = $$row[0];
   	$adviews  = $$row[1];
 	 }
   
 	$q = "SELECT sum(clicks) AS adclicks, sum(views) AS adviews FROM thomtnetlogADviewsServerM WHERE acct IN ($acctmap) AND adtype ='pai' AND fdate in ($rdate)  ";
	my $sth = $dbh->prepare($q);
 	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 	while (my $row = $sth->fetchrow_arrayref)
  	{
  	$adclicks += $$row[0];
   	$adviews  += $$row[1];
  	}   
 	$q = "SELECT sum(clicks) AS adclicks, sum(views) AS adviews FROM thomtnetlogADviewsServerM WHERE acct IN ($acctmap) AND adtype ='bad' AND fdate in ($rdate)  ";
 	my $sth = $dbh->prepare($q);
 	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 	while (my $row = $sth->fetchrow_arrayref)
  	{
   	$adclicks += $$row[0];
   	$adviews  += $$row[1];
  	}
 
 	$caton = $catonrfq = "0";
 	$q = "SELECT SUM(totalpageviews) AS n, sum(totalInq) + sum(totalordrfqs) totalInq FROM thomflat_catnav_summmaryM WHERE tgramsid IN ($acctmap) AND date in ($rdate)  ";
 	my $sth = $dbh->prepare($q);
 	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 	while (my $row = $sth->fetchrow_arrayref)
  	{
   	$caton    = $$row[0];
   	$catonrfq = $$row[1];
  	}
 	if($caton==""){$caton="0";} if($catonrfq==""){$catonrfq="0";} 

 
 	$catoff = $catoffrfq = "0";
 	$q = "SELECT SUM(totalpageviews) AS n, sum(totalInq) + sum(totalordrfqs) totalInq FROM thomcatnav_summmaryM WHERE tgramsid IN ($acctmap) AND date in ($rdate)   "; 
 	my $sth = $dbh->prepare($q);
 	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 	while (my $row = $sth->fetchrow_arrayref)
	{
   	$catoff    = $$row[0];
   	$catoffrfq = $$row[1];
  	}

	#$rfi = "";
	#$q = "select count(*) as n from tgrams.contacts where acct=$acct and (created>=1454302800 and created<1485925200) and  notsent  < 1 and test_msg!=1  ";
	#my $sth = $dbh->prepare($q);
 	#if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 	#while (my $row = $sth->fetchrow_arrayref)
	#{ 
   	#$rfi  = $$row[0];
  	#}  
	#if($rfi==""){$rfi="0";} 
 
	$programdate =""; 
 	$q= "select contract_start_date         
        from sodm_rank.sodm_contracts
        where acct=$acct
        and contract_end_date>curdate()
        and legacy_publication_code not in('32','3B','3D','3H','41','48','50','54','59','64')
        and contract_status!='C'
        and legacy_publication_code in ('42','3E') ";
 	my $sth_iso = $dbh_iso->prepare($q);
 	if (!$sth_iso->execute) { print "Error" . $dbh_iso->errstr . "<BR>\n"; exit(0); }
 	while (my $row = $sth_iso->fetchrow_arrayref)
	{   
   	$programdate       = $$row[0];
  	}  


	#print "news: $totnews\nadclicks: $adclicks\n$catoff + $catoffrfq \n$caton + $catonrfq \n"; 


	$total_top_conv += $totnews;
 	$total_top_conv += $adclicks; 
 	$total_top_conv += $catoff + $catoffrfq ;
 	$total_top_conv += $caton + $catonrfq ;
   


	#Account Name\tTGRAMS#\tRank Points\t# of Listings (paid and unpaid)\tUser Sessions\tConversions\tProfile Views\tLinks to Website\tRFI Count (all vetting types - total count)\tProgram Cycle Start Date\n";

	print wf "$comp\t";
	print wf "$acct\t";
	print wf "$rank\t";
	print wf "$listings\t";
	print wf "$us\t";
	print wf "$total_top_conv\t";
	print wf "$profile\t";
	print wf "$links\t";
	print wf "$rfi\t";
	print wf "$programdate\t";
	print wf "\n";
 	$j++;   
}


close(wf);




$dbh->disconnect;

$now_string = localtime;
print "$now_string"; 


=for comment
=cut 
 
print "\nDone...";
