#!/usr/bin/perl
#
# loads summaryu table "user session summary"
# run as ./load-summaryu.pl yy 
    
$yr   = $ARGV[0]; 
if($yr eq "") {print "\n\nForgot to add year yy\n\n"; exit;}

use DBI;
require "/usr/wt/trd-reload.ph";
 

$m1  = "01";  
$m2  = "02";  
$m3  = "03";  
$m4  = "04";  
$m5  = "05";  
$m6  = "06";  
$m7  = "07";  
$m8  = "08";  
$m9  = "09";  
$m10 = "10";  
$m11 = "11";  
$m12 = "12";  

$loadtable = "summaryu"; 
$datatable = "quickUS" . $yr ;
$outfile   = $loadtable . ".txt";
     

$fyear    = "20" . $yr;
  
# Delete from csummary table
$query = "delete from  thom$loadtable where right(date, 2)='$yr' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

# Get all headings            
$i=0; 
$query = "select heading from tgrams.headings where heading>0  order by heading";
#$query .= " limit 100 ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
  $head[$i]   = $$row[0];   
  $i++;
 }
$sth->finish;

# Get data
$i=0; 
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
foreach $head (@head)         
 {                                
  if ($i % 1000 == 0) { print "$i\r"; }
  $query  = "select heading, covflag, ";                                                    
  $query .= "sum(if (date='$yr$m1'  || date='$yr$m2'  || date='$yr$m3',  cnt, 0)) as q1, ";
  $query .= "sum(if (date='$yr$m4'  || date='$yr$m5'  || date='$yr$m6',  cnt, 0)) as q2, ";
  $query .= "sum(if (date='$yr$m7'  || date='$yr$m8'  || date='$yr$m9',  cnt, 0)) as q3, ";
  $query .= "sum(if (date='$yr$m10' || date='$yr$m11' || date='$yr$m12', cnt, 0)) as q4  ";
  $query .= "from thom$datatable ";                                                            
  $query .= "where heading=$head and covflag>'' ";                                                        
  $query .= "group by covflag ";         

  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
   { 
    if($$row[1] ne "n" && $$row[1] ne "t") { $$row[1] =~ tr/a-z/A-Z/; }       
    $total = 0;
    $total = $$row[2] + $$row[3] + $$row[4] + $$row[5];
    print wf "$fyear\t$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$$row[5]\t$total\n";          
   }
  $sth->finish;

  $i++;
 }
close(wf);
 
system("mysqlimport -rL thomas $DIR/$outfile"); 
#system("rm -f $DIR/$outfile"); 
     
$rc = $dbh->disconnect;

exit; 



