#!/usr/bin/perl
#
# Makes conversion report A - L

use DBI;
require "/usr/wt/trd-reload.ph";
 
$outfile = "convAL15.txt"; 
$rdate = " '1501','1502','1503','1504','1505','1506','1507','1508','1509','1510','1511','1512' ";    
$rlet    =  " '3','5','6','7','A','B','C','D','E','F','G','H','I','J','K','L'  ";
 
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");   
print wf "Category Name\tCategory ID\t2015 Category Site User Sessions\t2015 Category Site Conversion Actions\n"; 
           
# All headings in array     
$query  = " select description, heading from tgrams.headings where left(description, 1) in ($rlet) order by description ";
#$query .= " limit 5 ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {   
  $$row[0] =~ s/\,//g;
  $hd[$i]="$$row[0]|$$row[1]";
  $i++;
 }
$sth->finish;
  
$i=0; 
foreach $hd (@hd)         
 {                               
   ($d,$h) = split(/\|/,$hd);                       
  print "$i $d\n";
  
  # Total 2015 US
  $query  = " select  sum(cnt) from thomquickUS15 where heading='$h' and covflag='t' and date in ($rdate) ";
  #$query  = " select  sum(us) from thomqlog15Y where heading='$h' and covflag='t' and date in ($rdate) ";
  # print " $query\n"; 
   my $sth = $dbh->prepare($query); 
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {  
     $y2015US = $$row[0];
     if($y2015US eq "") {$y2015US=0;}
    }
   $sth->finish;

  # total 2015 conversions
   $query = " select ";
   $query .= "sum(pv) + ";
   $query .= "sum(pc) + ";
   $query .= "sum(lw) + ";
   $query .= "sum(em) + ";
   $query .= "sum(ec) + ";
   $query .= "sum(mt) + ";                                    
   $query .= "sum(cd) + ";
   $query .= "sum(lc) + ";
   $query .= "sum(vv) + ";
   $query .= "sum(dv) + ";
   $query .= "sum(iv) + ";
   $query .= "sum(sm) + ";
   $query .= "sum(pp) + ";
   $query .= "sum(mv) as tot ";    
   $query .= "from  qlog15Y  where heading='$h' and covflag='t' and date in ( $rdate )  ";
   #print "$query\n";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
   { $y2015 = $$row[0]; } 
   $sth->finish;
   if($y2015 eq "") {$y2015=0;}   
 
   print wf "$d\t$h\t$y2015US\t$y2015\n";
 
  $y2015US = $y2015 = 0;  
  $i++;
  #if ($i%1000 == 0) { print "$i\r"; }

 }
close(wf);

$dbh->disconnect;

print "\n\nDone...\n\n";
