#!/usr/bin/perl
#
# Makes conversion report A - L

use DBI;
require "/usr/wt/trd-reload.ph";
  
$outfile = "convMZ16.txt"; 
$rdate = " '1601','1602','1603','1604','1605','1606','1607','1608','1609','1610','1611','1612' ";
$rlet    =  " 'M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'   ";
  
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");   
print wf "Category Name\tCategory ID\t2016 Category Site User Sessions\t2016 Category Site Conversion Actions\n";
           
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
    
  # Total 2016 US
   $query  = " select  sum(cnt) from thomquickUS16 where heading='$h' and covflag='t' and date in ($rdate) ";
   #$query  = " select  sum(us) from thomqlog16Y where heading='$h' and covflag='t' and date in ($rdate) ";
   #print " $query\n";
   my $sth = $dbh->prepare($query); 
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {  
     $y2016US = $$row[0];
     if($y2016US eq "") {$y2016US=0;}
    }
   $sth->finish;

  # total 2016 conversions
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
   $query .= "from  qlog16Y  where heading='$h' and covflag='t' and date in ( $rdate ) ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
   { $y2016 = $$row[0]; } 
   $sth->finish;
   if($y2016  eq "") {$y2016 =0;}
    
   print wf "$d\t$h\t$y2016US\t$y2016\n";
   $y2016US = $y2016 = 0;

  $i++;
  #if ($i%1000 == 0) { print "$i\r"; }
 }
close(wf);

$dbh->disconnect;

print "\n\nDone...\n\n";
