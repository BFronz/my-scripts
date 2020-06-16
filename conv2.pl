#!/usr/bin/perl
#
# Makes conversion report A - L

use DBI;
$dbh      = DBI->connect("", "", "");

# All headings in array
$query  = " select description, heading from tgrams.headings  order by description ";
#$query .= " limit 10 ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
  $$row[0] =~ s/\,//g;
  $hd[$i]="$$row[0]|$$row[1]";
  $i++;
 }
$sth->finish;

$rdate10 = " '1001','1002','1003','1004','1005','1006','1007','1008','1009','1010','1011','1012'";

open(wf,  ">convupdate.txt")  || die (print "Could not open convupdate.txt\n");

$i=0;
foreach $hd (@hd)
 {
   ($d,$h) = split(/\|/,$hd);
   print "$z.\t$d\n"; 

   $query = " select ";
   $query .= "sum(pv) + ";
   $query .= "sum(pc) + ";
   $query .= "sum(lw) + ";
   $query .= "sum(em) + ";
   $query .= "sum(ec) + ";
   $query .= "sum(mt) + ";
   $query .= "sum(cd) + ";
   $query .= "sum(lc)   ";
   $query .= "from  qlog10Y  where heading='$h' and covflag='t' and date in ( $rdate10 ) and acct>0 ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    { 
     print wf "update convAZ set conv2010='$$row[0]' where heading='$h' ;\n";
    }
   $sth->finish;

 
  $z++;
}
