#!/usr/bin/perl
# 
# Loads ccp profile items
# run ./load-ccp-views.pl YYMM

$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

 
$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);
$outfile  = "advItemDetailViewsUpdate$yy.txt";
$outfile  = "advItemDetailViewsUpdate2$yy.txt";
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");            

$f = "advItemDetailViews_t";         
$infile    = $fyear . "/" . $f . "-" . $fdate . ".txt";
print "$infile\n";
  
open(rf, "$infile")  || die (print "Could not open $infile\n");
while (!eof(rf))
 {
  $instr = <rf>;
  chop($instr);
  ($dt,$acct,$cnt,$covflag) = split(/\t/,$instr);

   if($cnt >0) { 
   print  "$z) $dt\tacct\t$cnt\t$covflag\n"; 
   $totcnt += $cnt; 
   #print wf  "update tnetlogARTU12 set  pc = pc + $cnt where acct='$acct' and  date='1209' and covflag='t' ;\n"; } 
   print wf  "update thomcatnav_summmary12  set totalpageviews = totalpageviews + $cnt where tgramsid='$acct' and isactive='yes' and date='1209'  ;\n"; }  
 $z++;  
 }  
close(rf); 

close(wf);

 
print "\n$totcnt\n";

exit;



