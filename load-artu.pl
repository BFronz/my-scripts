#!/usr/bin/perl
#
# Loads activity, referer, trend table and user sessions
# run ./load-artu.pl date(yymm)

use DBI;
require "/usr/wt/trd-reload.ph";

$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}
  
$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);  
$outfile  = "tnetlogARTUlog.txt";
$outfile2 = "tnetlogARTU$yy.txt";
 
$file[0]  = "pv:advCompProfViewCov_c";  # Profiles Viewed 
$file[1]  = "pv:advCompProfViewCov_n"; 
$file[2]  = "pv:advCompProfViewCov_t"; 
   
$file[3]  = "pc:advProdCatalogViewCov_c";  # Product Catalog   
$file[4]  = "pc:advProdCatalogViewCov_n";
$file[5]  = "pc:advProdCatalogViewCov_t";
    
$file[6]  = "ln:advSupLinkClickCov_c";  # Links to Your Website  
$file[7]  = "ln:advSupLinkClickCov_n";
$file[8]  = "ln:advSupLinkClickCov_t";
         

     
$file[9]  = "mt:advMyThomasSavesCov_c";  # MyThomas 
$file[10]  = "mt:advMyThomasSavesCov_n";
$file[11]  = "mt:advMyThomasSavesCov_t";

$file[12]  = "cl:advCadLinksCov_c";  # Links to CADRegister
$file[13]  = "cl:advCadLinksCov_n";
$file[14]  = "cl:advCadLinksCov_t";
        
$file[15] = "lc:advCatalogLinkCov_c"; # Catalog links 
$file[16] = "lc:advCatalogLinkCov_n";
$file[17] = "lc:advCatalogLinkCov_t";

$file[18]  = "tus:advVisits";          # U ses total 
$file[19]  = "nus:advVisitsNational";  # U ses nattional , had to add "nus" becaues no n in file
$file[20]  = "us:advVisitsCov";        # U ses coverage 
     
$file[21]  = "se:advSERefsTotal";  # Search Eng Refs, note: only at total

$file[22] = "vv:advVideofViewCov_c";  # VIDEO VIEWS (vv)  
$file[23] = "vv:advVideofViewCov_n";                      
$file[24] = "vv:advVideofViewCov_t";                      
 
$file[25] = "iv:advImgViewCov_c";   # IMAGE VIEWS (iv)  
$file[26] = "iv:advImgViewCov_n";                       
$file[27] = "iv:advImgViewCov_t";                       

$file[28] = "sm:advSocMedViewCov_c";      # SOCIAL MEDIA FOLLOWS (sm)   
$file[29] = "sm:advSocMedViewCov_n";                                    
$file[30] = "sm:advSocMedViewCov_t";                                    

$file[31] = "pp:advProfPrintCov_c";   # PROFILE PRINT REQUEST (pp)     
$file[32] = "pp:advProfPrintCov_n";                                    
$file[33] = "pp:advProfPrintCov_t";                                    

$file[34] = "dv:advDocfViewCov_c";  # DOCUMENT VIEWS (dv)   
$file[35] = "dv:advDocfViewCov_n";                          
$file[36] = "dv:advDocfViewCov_t";                          

$file[37] = "mv:advMapViewCov_c";    # MAP LOCATION VIEWS  (mv)   
$file[38] = "mv:advMapViewCov_n";                                 
$file[39] = "mv:advMapViewCov_t";                                 

############

#$file[9]  = "ec:advEMailColleagueCov_c";  # E-Mail to Colleague
#$file[10]  = "ec:advEMailColleagueCov_n";
#$file[11]  = "ec:advEMailColleagueCov_t";
 

#$file[12]  = "ca:advContactAdvClickCov_c";  # E-Mail Sent to You 
#$file[13]  = "ca:advContactAdvClickCov_n";
#$file[14]  = "ca:advContactAdvClickCov_t";
 
#$file[9]   = "mi:advMoreInfoClickCov_c";  # More Info 
#$file[10]  = "mi:advMoreInfoClickCov_n";
#$file[11]  = "mi:advMoreInfoClickCov_t";
########### 

# not used or needed anymore
# "cd:advCADdownload";    # advCADdownload   These counts now taken from tnetlogCADMAST{yy}
# "ci:advCADinsert";      # advCADinsert     
# "ce:advCADemail";       # advCADemail
# "nw:advPNNRefs";        # PNN Refs  
# "fi:adv1stIndRefs";     # First Ind Refs   
# "tr:advTRDRefs";        # TR Refs
 
  
# Delete from tables
$query = "delete from thomtnetlogARTUlog";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
           
$query = "delete from thomtnetlogARTU$yy where date='$fdate'";
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




system("mysqlimport -diL thomas $DIR/$outfile"); 
#system("rm -f $DIR/$outfile"); 
  

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
  print wf "$date\t$acct\t$covflag\t$us\t$pv\t$pc\t$ln\t$mi\t$ca\t$ec\t$mt\t$tr\t$se\t$fi\t$nw\t$cl\t$cv\t$cd\t$lc\t$ce\t$ci\t$vv\t$dv\t$iv\t$sm\t$pp\t$mv\n";
 }  
$sth->finish;
close(wf);

system("mysqlimport -iL thomas $DIR/$outfile2");
#system("rm -f $DIR/$outfile2"); 

$rc = $dbh->disconnect;

exit;

=for comment

CREATE TABLE tnetlogARTUlog (
  date varchar(4) NOT NULL default '',
  acct bigint(20) NOT NULL default '0',
  cnt int(11) NOT NULL default '0',
  covflag char(2) NOT NULL default '',
  type char(2) NOT NULL default '',
  KEY date (date),
  KEY acct (acct),
  KEY type (type),
  KEY covflag (covflag)
) TYPE=MyISAM;
 


CREATE TABLE tnetlogARTU{yy} (
  date varchar(4) NOT NULL default '',
  acct bigint(20) NOT NULL default '0',
  covflag char(2) NOT NULL default '',
  us int(11) NOT NULL default '0',
  pv int(11) NOT NULL default '0',
  pc int(11) NOT NULL default '0',
  ln int(11) NOT NULL default '0',
  mi int(11) NOT NULL default '0',
  ca int(11) NOT NULL default '0',
  ec int(11) NOT NULL default '0',
  mt int(11) NOT NULL default '0',
  tr int(11) NOT NULL default '0',
  se int(11) NOT NULL default '0',
  fi int(11) NOT NULL default '0',
  nw int(11) NOT NULL default '0',
  cl int(11) NOT NULL default '0',
  cv int(11) NOT NULL default '0',
  cd int(11) NOT NULL default '0',
  lc int(11) NOT NULL default '0',
  ce int(11) NOT NULL default '0',    
  ci int(11) NOT NULL default '0',    

  vv int(11) NOT NULL default '0',
  dv int(11) NOT NULL default '0',
  iv int(11) NOT NULL default '0',
  sm int(11) NOT NULL default '0',
  pp int(11) NOT NULL default '0',
  mv int(11) NOT NULL default '0',

  KEY date (date),
  KEY acct (acct),
  KEY covflag (covflag)
) ;

=cut


