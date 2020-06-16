#!/usr/bin/perl
#
# 
 
   

$date = "2013";  
$rdate = " '1301','1302','1303','1304','1305','1306','1307','1308','1309','1310','1311','1312' ";


$date = "2014";  
$rdate = " '1401','1402','1403','1404','1405','1406','1407','1408','1409','1410','1411','1412' ";
 
$after="A"; 
$outfile = "reg-vis-" . $date . "$after.txt";

$i = 0;
 
use DBI;
$dbh      = DBI->connect("", "", "");

system("rm -f $outfile");
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n"); 
print wf "Company\t";
print wf "Acct\t";
print wf "Registered User Report\t";
print wf "Visitor Report\n";
                         
$query  = " select m.company, m.acct from thomtnetlogREG14 as r, tgrams.main as m where m.acct=r.acct and r.date in ($rdate) and m.company!='3m' ";
#$query  .= " AND m.acct=1079820 ";
$query  .= "group by m.acct  order by company ";
#$query  .= " limit 100 ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {     
  $record[$i]="$$row[0]|$$row[1]";
  #print "$record[$i]\n";
  $i++; 
 }
$sth->finish;

print "\nTotal accounts: $i\n";

foreach $record (@record)         
 {                               
   ($co,$acct) = split(/\|/,$record);

   print wf "$co\t$acct\n";	
   print  "$j\t$co\t$acct\n";	
 
   # registered user report     
   $query  = "SELECT lower(company) as co FROM tgrams.mt_profile_history as h, thomtnetlogREG14 as r  ";
   $query .= "WHERE h.tinid=r.tinid AND r.acct='$acct' AND date in ($rdate)  GROUP by h.tinid ORDER BY co ";
   #print "$query\n";
   $a = "0"; 
   my $sth = $dbh->prepare($query); 
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {          
      $reca[$a] = $$row[0];
      $a++;	 
    }
    $sth->finish;


   # visitor report     
   $query  = "SELECT org FROM thomtnetlogORGD14M  ";
   $query .= "WHERE acct='$acct' AND date in ($rdate) AND org!='3m' AND latitude='0.0001' GROUP BY org ORDER BY  org ";
   #print "$query\n";
   my $sth = $dbh->prepare($query); 
   $b = "0"; 
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {          
      $recb[$b] = $$row[0];
      $b++;	 
    }
    $sth->finish;
  
   # determine larger list
   if($a > $b || $a eq $b) { $tot = $a; }
   if ($b > $a)            { $tot = $b; }
  
  # print
  $c = 0; 

  if($a gt $b)
  { 
  	while ($c < $tot) { 
		print wf " \t \t$reca[$c]\t$recb[$c]\n";  
		$c++;
		if($c eq 10000) {break;}
	}   
  }
  	

  undef (@reca);
  undef (@recb);

   $j++;   
 }
close(wf);

$dbh->disconnect;
  
print "\n\nTotal Adv: $j\n\n";
