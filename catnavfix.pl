#!/usr/bin/perl
# 
# Loads activity, referer, trend table and user sessions
# run ./load-artu.pl date(yymm)


$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
$dbh      = DBI->connect("", "", "");
$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);  
$outfile  = "tnetlogARTUlog.txt";
$outfile2 = "tnetlogARTU-FIX$yy.txt";
 
$file[0]  = "pc:advProdCatalogViewCov_c";  # Product Catalog   
$file[1]  = "pc:advProdCatalogViewCov_n";
$file[2]  = "pc:advProdCatalogViewCov_t";
     
$query = "delete from tnetlogARTUlog";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
           
$query = "update tnetlogARTU$yy set pc=0 where date='$fdate'";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

# Load files into log file
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
foreach $file (@file)        
 {                               
   ($type,$f) = split(/\:/, $file);
   $infile    = $fyear . "/" . $f . "-" . $fdate . ".txt";
   #$infile    = $fyear . "/" .  "apr/"   . $f . "-" . $fdate . ".txt";
   print "$infile\n";
  
   open(rf, "$infile")  || die (print "Could not open $infile\n");
   while (!eof(rf))
    {
      $instr = <rf>;
      chop($instr);
 
      ($d,$a,$ct,$cov) = split(/\t/,$instr);
      if($cov eq "NA"){$cov="n";}
   
      if($type eq "nus")    { print wf "$d\t$a\t$ct\tn\tus\n"; }  # hack to set n & t cov
      elsif($type eq "tus") { print wf "$d\t$a\t$ct\tt\tus\n"; } 
      elsif($type eq "se")  { print wf "$d\t$a\t$ct\tt\tse\n"; } 
      else                  { print wf "$d\t$a\t$ct\t$cov\t$type\n"; }
      $d = $a = $ct = $cov = ""; 
   } 
   close(rf); 
 }
close(wf);
system("mysqlimport -di thomas $outfile"); 

   
# Query and load summary table
$query  = " select date, acct, covflag,      ";
$query .= " sum(if(type='us',cnt,0)) as us , ";         
$query .= " sum(if(type='pv',cnt,0)) as pv , ";        
$query .= " sum(if(type='pc',cnt,0)) as pc , ";        
$query .= " sum(if(type='ln',cnt,0)) as ln , ";        
$query .= " sum(if(type='mi',cnt,0)) as mi , ";        
$query .= " sum(if(type='ca',cnt,0)) as ca , ";        
$query .= " sum(if(type='ec',cnt,0)) as ec , ";         
$query .= " sum(if(type='mt',cnt,0)) as mt , ";        
$query .= " sum(if(type='tr',cnt,0)) as tr , ";        
$query .= " sum(if(type='se',cnt,0)) as se , ";        
$query .= " sum(if(type='fi',cnt,0)) as fi , ";        
$query .= " sum(if(type='nw',cnt,0)) as nw , ";        
$query .= " sum(if(type='cl',cnt,0)) as cl , ";        
$query .= " sum(if(type='cv',cnt,0)) as cv , ";        
$query .= " sum(if(type='cd',cnt,0)) as cd , ";        
$query .= " sum(if(type='lc',cnt,0)) as lc , ";        
$query .= " sum(if(type='ce',cnt,0)) as ce , ";        
$query .= " sum(if(type='ci',cnt,0)) as ci,   ";        

$query .= " sum(if(type='vv',cnt,0)) as vv,   ";
$query .= " sum(if(type='dv',cnt,0)) as dv,   ";
$query .= " sum(if(type='iv',cnt,0)) as iv,   ";
$query .= " sum(if(type='sm',cnt,0)) as sm,   ";
$query .= " sum(if(type='pp',cnt,0)) as pp,   ";
$query .= " sum(if(type='mv',cnt,0)) as mv   ";

$query .= " from tnetlogARTUlog              ";
$query .= " where date='$fdate' and acct>0   ";
$query .= " group by acct, covflag";
open(wf,  ">$outfile2")  || die (print "Could not open $outfile2\n");
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
  $date     = $$row[0]; 
  $acct     = $$row[1]; 
  $covflag  = $$row[2]; 
  $us       = $$row[3]; 
  $pv       = $$row[4]; 
  $pc       = $$row[5]; 
  $ln       = $$row[6]; 
  $mi       = $$row[7]; 
  $mi       = 0;  # More Info removed July 09
  $ca       = $$row[8]; 
  $ec       = $$row[9]; 
  $mt       = $$row[10];
  $tr       = $$row[11];
  $se       = $$row[12];
  $fi       = $$row[13];
  $nw       = $$row[14];
  $cl       = $$row[15];
  $cv       = $$row[16];
  $cd       = $$row[17];
  $lc       = $$row[18];
  $ce       = $$row[19];
  $ci       = $$row[20];

  $vv       = $$row[21];
  $dv       = $$row[22];
  $iv       = $$row[23];
  $sm       = $$row[24];
  $pp       = $$row[25];
  $mv       = $$row[26];

  if(length $covflag == 2){ $covflag =~ tr/a-z/A-Z/; }
  print wf "update tnetlogARTU$yy set pc=$pc where date='$fdate' and covflag='$covflag' and acct='$acct';\n"; 
 }   
$sth->finish;
close(wf);
  
###system("mysql thomas < $outfile2");

 
$rc = $dbh->disconnect;
 
print "\n\nCheck then run mysql thomas < $outfile2\n\n";
exit; 
