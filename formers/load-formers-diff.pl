#!/usr/bin/perl
#
# Updates former_main fields conv after, conv before & conv percent

use DBI;
use POSIX;
use Switch;
require "/usr/wt/trd-reload.ph";

$mon{"Jan"}="01";
$mon{"Feb"}="02";
$mon{"Mar"}="03";
$mon{"Apr"}="04";
$mon{"May"}="05";
$mon{"Jun"}="06";
$mon{"Jul"}="07";
$mon{"Aug"}="08";
$mon{"Sep"}="09";
$mon{"Oct"}="10";
$mon{"Nov"}="11";
$mon{"Dec"}="12";

# get accounts from formers_main table
$i=0;
$query  = "select acct, end from formers_main ";
#$query .= "limit 5";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $record[$i] = "$$row[0]:$$row[1]";
  $i++;
 }
$sth->finish;

$outfile = "formers_diff.txt";
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
$j=0;
foreach $record (@record)
{
 ($cid,$end) = split(/\:/,$record);

  $month = substr($end, 3, 3);
  $yy    = substr($end, 7, 2);
  $canceled  = $yy . $mon{$month};
  $canceled  = abs($canceled); 

  switch ($canceled) 
   {       
    case 611  { $bdate= 611; $adate=612; }
    case 610  { $bdate= 610; $adate=611; }
                                          
    case 701  { $bdate= 701; $adate=702; }
    case 704  { $bdate= 704; $adate=705; }
    case 707  { $bdate= 707; $adate=708; }
    case 710  { $bdate= 710; $adate=711; }
                                          
    case 801  { $bdate= 801; $adate=802; }
    case 804  { $bdate= 804; $adate=805; }
    case 807  { $bdate= 807; $adate=808; }
    case 810  { $bdate= 810; $adate=811; }
                                          
    case 901  { $bdate= 901; $adate=902; }
    case 904  { $bdate= 904; $adate=905; }
    case 907  { $bdate= 907; $adate=908; }
    case 910  { $bdate= 910; $adate=911;} 

    case 1001  { $bdate= 1001; $adate=1002; }
    case 1004  { $bdate= 1004; $adate=1005; }
    case 1007  { $bdate= 1007; $adate=1008; }
    case 1010  { $bdate= 1010; $adate=1011;}

    case 1101  { $bdate= 1101; $adate=1102; }
    case 1104  { $bdate= 1104; $adate=1105; }
    case 1107  { $bdate= 1107; $adate=1108; }
    case 1110  { $bdate= 1110; $adate=1111;}
           
    case 1201  { $bdate= 1201; $adate=1202; }
    case 1204  { $bdate= 1204; $adate=1205; }
    case 1207  { $bdate= 1207; $adate=1208; }
    case 1210  { $bdate= 1210; $adate=1211;}
 
    case 1301  { $bdate= 1301; $adate=1302; }
    case 1304  { $bdate= 1304; $adate=1305; }
    case 1307  { $bdate= 1307; $adate=1308; }
    case 1310  { $bdate= 1310; $adate=1311;}
          
    case 1401  { $bdate= 1401; $adate=1402; }
    case 1404  { $bdate= 1404; $adate=1405; }
    case 1407  { $bdate= 1407; $adate=1408; }
    case 1410  { $bdate= 1410; $adate=1411;}

    case 1501  { $bdate= 1501; $adate=1502; }
    case 1504  { $bdate= 1504; $adate=1505; }
    case 1507  { $bdate= 1507; $adate=1508; }
    case 1510  { $bdate= 1510; $adate=1511;}


    case 1601  { $bdate= 1601; $adate=1602; }
    case 1604  { $bdate= 1604; $adate=1605; }
    case 1607  { $bdate= 1607; $adate=1608; }
    case 1610  { $bdate= 1610; $adate=1611;}
   } 

   $query  = "select ";
   $query .= "sum( if (yymm in ($bdate), conv, 0) ) as conv_before, ";
   $query .= "sum( if (yymm in ($adate), conv, 0) ) as conv_after  ";
   $query .= "from formers_total where acct=$cid ;";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    { 
      #print "$j $cid: $$row[1] / $$row[0]\n";
      if($$row[0]>0)
       {
        $diff = ( $$row[1] / $$row[0] ) ;
        $diff = (1 - $diff) * 100 ;
        $diff = sprintf("%.2f", $diff);
       }
      else
       {
         $diff=0;
       }

      print wf "update formers_main set convb='$$row[0]', conva='$$row[1]', convp='$diff' where acct=$cid;\n";
    }

 $j++;
}

close(wf);

system("mysql thomas < $outfile");


$dbh->disconnect;



#    case 611  { $bdate= "600,610,611"; $adate="612,701,702"; }
#    case 610  { $bdate= "608,609,610"; $adate="611,612,701"; }

#    case 701  { $bdate= "611,612,701"; $adate="702,703,704"; }
#    case 704  { $bdate= "702,703,704"; $adate="705,706,707"; }
#    case 707  { $bdate= "705,706,707"; $adate="708,709,710"; }
#    case 710  { $bdate= "708,709,710"; $adate="711,712,801"; }

#    case 801  { $bdate= "711,712,801"; $adate="802,803,804"; }
#    case 804  { $bdate= "802,803,804"; $adate="805,806,807"; }
#    case 807  { $bdate= "805,806,807"; $adate="808,809,810"; }
#    case 810  { $bdate= "808,809,810"; $adate="811,812,901"; }

#    case 901  { $bdate= "811,812,901"; $adate="902,903,904"; }
#    case 904  { $bdate= "902,903,904"; $adate="905,906,907"; }
#    case 907  { $bdate= "905,906,907"; $adate="908,909,910"; }
#    case 910  { $bdate= "908,909,910"; $adate="911,912,1001";} 

#    case 1001  { $bdate= "911,912,1001"; $adate="1002,1003,1004"; }
#    case 1004  { $bdate= "1002,1003,1004"; $adate="1005,1006,1007"; }
#    case 1007  { $bdate= "1005,1006,1007"; $adate="1008,1009,1010"; }
#    case 1010  { $bdate= "1008,1009,1010"; $adate="1011,1012,1101";}
