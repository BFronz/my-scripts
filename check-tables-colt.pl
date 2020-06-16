#!/usr/bin/perl  
#                
# Check tables for data

$fdate   = $ARGV[0];                                                
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}   
$yy       =  substr($fdate, 0, 2);
$mm       =  substr($fdate, 2, 2);
  
use DBI;
#require "/usr/wt/trd-reload.ph";
 
        $data_source2 = "dbi:mysql:thomas:colt.rds.c.net";
        $user2 = "logadm";
        $auth2  = "R0ck5!n";
        $dbh   = DBI->connect($data_source2, $user2, $auth2);
        $loc = "-tealium-data-";
        $source = "colt";


$table[0]="thomtnetlogARTU" . $yy ;              
$table[1]="thomtnetlogALINKS" . $yy ;            
$table[2]="tnetlogCADDET" . $yy ;                   
$table[3]="tgrams.tnetlogREG" . $yy ;               
$table[4]="tgrams.tnetlogREGCAT" . $yy ;            
$table[5]="tnetlogREFHD" . $yy ;                    
$table[6]="quickUS" . $yy ;                         
$table[7]="tnetlogPNN" . $yy ;                     
$table[8]="qlog" . $yy . "Y";                      
$table[9]="tnetlogSITEN";                          
$table[10]="topcategories"  ;                       
$table[11]="news_ad_cat" . $yy ;                    
$table[12]="tnetlogPNN" . $yy ;                     
$table[13]="news_conversions" . $yy ;               


  

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
