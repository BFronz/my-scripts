#!/usr/bin/perl
#
# loads quick log table
# run ./load-quick-log-new.pl date(yymm) 
   
$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
require "/usr/wt/trd-reload.ph";

$yy       =  substr($fdate, 0, 2);
$fyear    = "20" . substr($fdate, 0, 2);
$month    =  substr($fdate, 2, 2);
$table    = "qlog" . $yy . "Y";
$logfile  = "qlog.txt";
$outfile  = $table . ".txt";


$file[0]  = "pv:advCompProfViewCat_t";  # Profiles Viewed
$file[1]  = "pv:advCompProfViewCat_n";  
$file[2]  = "pv:advCompProfViewCat_c";  

$file[3]  = "pc:advProdCatalogViewCat_t";   # Product Catalog
$file[4]  = "pc:advProdCatalogViewCat_n"; 
$file[5]  = "pc:advProdCatalogViewCat_c"; 

$file[6]  = "lw:advSupLinkClickCat_t";   # Links to Your Website
$file[7]  = "lw:advSupLinkClickCat_n";   
$file[8]  = "lw:advSupLinkClickCat_c";   
          
$file[9]  = "mt:advMyThomasSavesCat_t";   # myThomas
$file[10]  = "mt:advMyThomasSavesCat_n";    
$file[11]  = "mt:advMyThomasSavesCat_c";    

$file[12]  = "cd:advCadLinksCat_t";   # Links to CADRegister
$file[13]  = "cd:advCadLinksCat_n";    
$file[14]  = "cd:advCadLinksCat_c";    

$file[15] = "lc:advCatalogLinkCatCov_t";  # Catalog links
$file[16] = "lc:advCatalogLinkCatCov_n";   
$file[17] = "lc:advCatalogLinkCatCov_c";   

$file[18]  = "tus:advVisitsCat";           # All User Sessions
$file[19]  = "nus:advVisitsNationalCat";   # National User Sessions
$file[20]  = "us:advVisitsCatCov";         # Coverage User Sessions

$file[21] = "vv:advVideofViewCat_c";  # VIDEO VIEWS (vv)            
$file[22] = "vv:advVideofViewCat_n";                                
$file[23] = "vv:advVideofViewCat_t";                                
                                                                  
                                                                  
$file[24] = "iv:advImgViewCat_c";    # IMAGE VIEWS (iv)             
$file[25] = "iv:advImgViewCat_n";                                   
$file[26] = "iv:advImgViewCat_t";                                   
                                                                  
$file[27] = "sm:advSocMedViewCat_c";  # SOCIAL MEDIA FOLLOWS (sm)   
$file[28] = "sm:advSocMedViewCat_n";                                
$file[29] = "sm:advSocMedViewCat_t";                                
                                                                  
$file[30] = "pp:advProfPrintCat_c";   # PROFILE PRINT REQUEST (pp)  
$file[31] = "pp:advProfPrintCat_n";                                 
$file[32] = "pp:advProfPrintCat_t";                                 
 
$file[33] = "dv:advDocfViewCat_c";  # DOCUMENT VIEWS (dv)           
$file[34] = "dv:advDocfViewCat_n";                                  
$file[35] = "dv:advDocfViewCat_t";                                  
                                                         
$file[36] = "mv:advMapViewCat_c";    # MAP LOCATION VIEWS  (mv)     
$file[37] = "mv:advMapViewCat_n";                                   
$file[38] = "mv:advMapViewCat_t";                                   
 

###########
#$file[9]  = "ec:advEMailColleagueCat_t";   # E-Mail to Colleague
#$file[10]  = "ec:advEMailColleagueCat_n";  
#$file[11]  = "ec:advEMailColleagueCat_c";  

 
#$file[15]  = "em:advContactAdvClickCat_c";  # E-Mail to sent you 
#$file[16]  = "em:advContactAdvClickCat_n";
#$file[17]  = "em:advContactAdvClickCat_t";
  
#$file[9]   = "mi:advMoreInfoClickCat_t";  # More Info
#$file[10]  = "mi:advMoreInfoClickCat_n";  
#$file[11]  = "mi:advMoreInfoClickCat_c";  
###########

# Delete from tables
$query = "delete from thomqlog ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
 
$query = "delete from thom$table where date='$fdate' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
            
# Load files into a temporary log table
open(wf,  ">$logfile")  || die (print "Could not open $logfile\n");
foreach $file (@file)         
 {                               
   ($type,$f) = split(/\:/, $file);
   $infile    = $fyear . "/" . $f . "-" . $fdate . ".txt";
   print "$infile\n";
   open(rf, "$infile")  || die (print "Could not open $infile\n");
   while (!eof(rf))
    {
      $instr = <rf>;
      chop($instr);
      if($type eq "nus")    { print wf "$instr\tn\tus\n"; }
      elsif($type eq "tus") { print wf "$instr\tt\tus\n"; }
      else                  
         {
          ($d,$a,$ct,$hd,$cov) = split(/\t/,$instr);    

          if($cov eq "NA")   { $cov="n";}

          if($type eq "nus") { $cov="n"; $type="us"; } # hack to set n & t cov
          if($type eq "tus") { $cov="t"; $type="us"; }
 
          if(length $cov == 2){ $cov =~ tr/a-z/A-Z/; }  
          print wf "$d\t$a\t$ct\t$hd\t$cov\t$type\n";          
          $d=""; $a=""; $ct=""; $cov=""; $hd="";        
         }
    } 
   close(rf); 
 }
close(wf);



system("mysqlimport -iL thomas $DIR/$logfile"); 
system("rm -f $outfile"); 



# Load thesummary table from temporary log table
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
$query  = " select date, acct, heading, covflag,  ";
$query .= " sum(if(type='us',cnt,0)) as     us,   ";    
$query .= " sum(if(type='cd',cnt,0)) as     cd,   ";
$query .= " sum(if(type='cl',cnt,0)) as     cl,   ";
$query .= " sum(if(type='ec',cnt,0)) as     ec,   ";
$query .= " sum(if(type='em',cnt,0)) as     em,   ";
$query .= " sum(if(type='lw',cnt,0)) as     lw,   ";
$query .= " sum(if(type='mi',cnt,0)) as     mi,   ";
#$query .= " sum(if(type='mt',cnt,0)) as     mt,   ";
$query .= " '0',   ";   #More Info removed July 09
$query .= " sum(if(type='pc',cnt,0)) as     pc,   ";
$query .= " sum(if(type='pv',cnt,0)) as     pv,   ";
$query .= " sum(if(type='lc',cnt,0)) as     lc,    ";

$query .= " sum(if(type='vv',cnt,0)) as vv,   ";
$query .= " sum(if(type='dv',cnt,0)) as dv,   ";
$query .= " sum(if(type='iv',cnt,0)) as iv,   ";
$query .= " sum(if(type='sm',cnt,0)) as sm,   ";
$query .= " sum(if(type='pp',cnt,0)) as pp,   ";
$query .= " sum(if(type='mv',cnt,0)) as mv   ";

$query .= " from  thomqlog  ";
$query .= " where date='$fdate' and heading>0  and acct>0 and covflag>'' ";
$query .= " group by acct, heading, covflag ";
 
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {  
  if(length $$row[3] == 2){ $$row[3] =~ tr/a-z/A-Z/; }
  print wf "$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$$row[5]\t$$row[6]\t$$row[7]\t$$row[8]\t$$row[9]\t$$row[10]\t$$row[11]\t$$row[12]\t$$row[13]\t$$row[14]\t";
  print wf "$$row[15]\t$$row[16]\t$$row[17]\t$$row[18]\t$$row[19]\t$$row[20]\n";
 }  
$sth->finish;
close(wf);

system("mysqlimport -iL thomas $DIR/$outfile");
  
$rc = $dbh->disconnect;
