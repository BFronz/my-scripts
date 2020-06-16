#!/usr/bin/perl  
#                
# Check tables for data

$fdate   = $ARGV[0];                                                
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}   
$yy       =  substr($fdate, 0, 2);
$mm       =  substr($fdate, 2, 2);
  
use DBI;
require "/usr/wt/trd-reload.ph";
 
$table[0]="thomtnetlogARTU" . $yy ;              
$table[1]="thomtnetlogALINKS" . $yy ;            
$table[2]="tnetlogCADDET" . $yy ;                   
$table[3]="tgrams.tnetlogREG" . $yy ;               
$table[4]="tgrams.tnetlogREGCAT" . $yy ;            
$table[5]="tnetlogREFHD" . $yy ;                    
$table[6]="quickUS" . $yy ;                         
$table[7]="tnetlogORGD" . $yy . "_$mm";                     
$table[8]="tnetlogORGCATD" . $yy . "_$mm" ;                  
$table[9]="tgr.tgrORGSITED" . $yy ;                 
$table[10]="tgr.tgrORGD" . $yy ;                    
$table[11]="tgr.tgrORGCATD" . $yy ;                 
$table[12]="newsORGSITED" . $yy ;                   
$table[13]="newsORGD" . $yy ;                       
$table[14]="tnetlogORGN" . $yy ;                    
$table[15]="tnetlogORGCATN" . $yy ;                 
$table[16]="tgr.tgrORGN" . $yy ;                    
$table[17]="tgr.tgrORGCATN" . $yy ;                 
$table[18]="newsORGN" . $yy ;                       
$table[19]="tnetlogPNN" . $yy ;                     
$table[20]="qlog" . $yy . "Y";                      
$table[21]="tnetlogSITEN";                          
$table[22]="topcategories"  ;                       
$table[23]="news_ad_cat" . $yy ;                    
$table[24]="catnav_inquiries" . $yy ;               
$table[25]="catnav_keyword_search" . $yy ;          
$table[26]="catnav_referring_domains" . $yy ;       
$table[27]="catnav_ref_keyword_searches" . $yy ;    
$table[28]="catnav_summmary" . $yy ;                
$table[29]="tnetlogPNN" . $yy ;                     
$table[30]="news_conversions" . $yy ;               
#$table[31]="tgrams.testdrive_cnts" ;                
$table[31]="tnetlogORGSITED" . $yy . "_$mm";               
$table[32]="thomtnetlogORGCATD" . $yy . "_$mm"; 
 
sub CheckTables { 
  $table=$_[0]; 
  $dbh=$_[1];
  $fdate=$_[2];

 if($table !~ /tgr/) {
     
  $query = "select count(*) from $table where date='$fdate' ";  
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  if (my $row = $sth->fetchrow_arrayref)
   {          
    print  "$table\t$$row[0]\n";
   }
  $sth->finish;
 }

}
 
print "\n";
 
foreach $table (@table) {
 
 if($table ne "")
  { 
   &CheckTables($table,$dbh,$fdate); 
  }

} 

print "\n";

$rc = $dbh->disconnect;
