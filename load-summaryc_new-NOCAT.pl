#!/usr/bin/perl
#
# loads summarycnocat table "conversion summary"
# run as ./load-summaryc_new-NOCAT.pl YY Q  
    
$yr   = $ARGV[0]; 
$qt   = $ARGV[1];
$fdate = "20" . $yr;
if($yr eq "" || $qt eq "") {print "\n\nMissing params\n\n"; exit;}

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

if($qt==1)     { $quarter = " '$yr$m1',  '$yr$m2',  '$yr$m3' "; }
elsif ($qt==2) { $quarter = " '$yr$m4',  '$yr$m5',  '$yr$m6' "; }
elsif ($qt==3) { $quarter = " '$yr$m7',  '$yr$m8',  '$yr$m9' "; }
elsif ($qt==4) { $quarter = " '$yr$m10', '$yr$m11', '$yr$m12' "; }
 
$datatable = "qlog" . $yr . "Y" ;
$fyear    = "20" . $yr;


# Heading array
$i=0; 
$query = "select heading from tgrams.headings where heading>0  ";
#$query .= "and heading=6101307 ";
$query .="order by heading ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
  $head[$i] = $$row[0];   
  #if($head[$i] eq 97004202){print "\n\nFound $i \n\n";}
  $i++;
 }
$sth->finish;
print "\nTotal Headings: $i\n";

 
# Run through headings by date , group by covflag. Too much of a group by if not done this way, qlog tables 
# are big by the end of the year
$i=0;     
open(wf,  ">summarycnocat.txt")         || die (print "Could not open summarycnocat.txt\n");
open(wf2, ">summarycnocat_update.txt")  || die (print "Could not open summarycnocat_update.txt\n");
# heading [0]
# cov [1]
# count [2]
foreach $head (@head)                       
 {                                                                         
  if ($z % 10 == 0) { print "$z\r"; }   
  $query  = "select heading, covflag, sum(cd + cl + ec + em + lw + mi + mt  + pv + lc + vv + dv + iv + sm + pp + mv) as n ";      
  $query .= "from thom$datatable ";                                                            
  $query .= "where heading=$head ";                                                        
  $query .= "and date in ($quarter) and covflag REGEXP '[[:alpha:]]'  "; # added this saw some junk                      
  $query .= "group by covflag ";          
  #if($head eq 97004202){print "\n\n$query\n\n";}
  
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
   {   
    if($$row[0] > 0  && $$row[1] ne "" && $$row[2] > 0)
     {
      # Caps check 
      if($$row[1] ne "n" && $$row[1] ne "t") { $$row[1] =~ tr/a-z/A-Z/; }       

      # If a new heading or year start do an insert first
      print wf "$fdate\t$$row[0]\t$$row[1]\t0\t0\t0\t0\t0\n";     
 
      # Update quarter 
      print wf2 "update thomsummarycnocat set q$qt=$$row[2] ";
      print wf2 "where date='$fdate' and heading=$$row[0] and covflag='$$row[1]';\n";        
     } 
  } 
  $sth->finish;
  
  $z++;
 }


close(wf);
close(wf2);
          
system("mysqlimport -iL thomas $DIR/summarycnocat.txt");  
system("mysql thomas < $DIR/summarycnocat_update.txt"); 

 
# Update year count
$z=0;
open(wf2, ">summarycnocat_update2.txt")  || die (print "Could not open summarycnocat_update2.txt\n");
foreach $head (@head)                        
 {                            
  if ($z % 10 == 0) { print "$z\r"; }   
  $query  = "select heading, covflag, sum(q1 + q2 + q3 + q4) as n ";      
  $query .= "from thomsummarycnocat ";                                                            
  $query .= "where heading=$head ";                                                        
  $query .= "and date = '$fdate'  and covflag REGEXP '[[:alpha:]]'  "; # added this saw some junk                      
  $query .= "group by covflag ";  
   
  #if($head eq 97004202){print "\n\n$query\n\n";}

  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
   {   
    if($$row[0] > 0  && $$row[1] ne "" && $$row[2] > 0)
     { 
      # Caps check 
      if($$row[1] ne "n" && $$row[1] ne "t") { $$row[1] =~ tr/a-z/A-Z/; }       
 
      print wf2 "update summarycnocat set yr=$$row[2] ";
      print wf2 "where date='$fdate' and heading=$$row[0] and covflag='$$row[1]';\n";        
     } 
  } 
  $sth->finish;
 $z++;  
 } 

close(wf2);

system("mysql thomas < $DIR/summarycnocat_update2.txt"); 
     
$rc = $dbh->disconnect;

exit; 



