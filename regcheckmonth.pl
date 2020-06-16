#!/usr/bin/perl 
#
#

$date   = $ARGV[0];
if($date eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

 
$fyear    = "20" . substr($date, 0, 2);
$yy       =  substr($date, 0, 2);
$mm       =  substr($date, 2, 2);

$outfile = "reg-vis-" . $date . ".txt";

$i = 0;
 
use DBI;
$dbh      = DBI->connect("", "", "");

system("rm -f $outfile");
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n"); 
print wf "Company\t";
print wf "Acct\t";
print wf "Registered User Report\t";
print wf "Visitor Report\n";
                                                             
$query  = " select m.company, m.acct from thomtnetlogREG$yy as r, tgrams.main as m where m.acct=r.acct and r.date = '$date' ";
#$query  .= " AND m.acct=1079820 ";
$query  .= "group by m.acct  order by company ";
$query  .= " limit 1000 ";
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
   ($co,$acct,$tinid) = split(/\|/,$record);
  
   #print wf "$co\t$acct tinid\n";	
   #print  "$j\t$co\t$acct\n";	
 
   # registered user report     
   $query  = "SELECT lower(company) as co, r.tinid as t FROM tgrams.mt_profile_history as h, thomtnetlogREG$yy as r  ";
   $query .= "WHERE h.tinid=r.tinid AND r.acct='$acct' AND date = '$date'  AND company!='3m' GROUP by h.tinid ORDER BY co ";
   #print "$query\n";
   $a = "0"; 
   my $sth = $dbh->prepare($query); 
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {          
      $reca[$a] = $$row[0];
      $tid[$a]  = $$row[1];	
      $a++;	 
    }
    $sth->finish;


   # visitor report     
   $table = "thomtnetlogORGD" . $yy . "_$mm";
   $query  = "SELECT org FROM $table   ";
   $query .= "WHERE acct='$acct' AND date = '$date' AND latitude='0.0001' AND org!='3m' GROUP BY org ORDER BY  org ";
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

 
  if($a > $b)
  { 
  	print  "$j\t$co\t$acct\t$a\t$b\n";	
        print wf "$co\t$acct\n";	
  	while ($c < $tot) { 
	print wf " \t \t$reca[$c] $tid[$c]\t$recb[$c]\n";  
	$c++;
	if($c eq 10000) {break;}
	}   
  }
  	
 
  undef (@reca);
  undef (@recb);
  undef (@tid);

   $j++;   
 }
close(wf);

$dbh->disconnect;
  
print "\n\nTotal Adv: $j\n\n";

