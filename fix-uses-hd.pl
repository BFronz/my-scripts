#!/usr/bin/perl 
#
# select heading, count(*) as n  into outfile '/tmp/fix-uses-hd-in.txt' from temp where heading>0 group by heading having n>1;
#
         
$outfile = "fix-uses-hd.txt";
$infile  = "/tmp/fix-uses-hd-in.txt";

open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
open(rf, "$infile")  || die (print "Could not open $infile\n");  
 
use DBI;
use POSIX;
$dbh = DBI->connect("", "", "");
 
$i=0;
open(rf, "$infile")  || die (print "Could not open $infile\n");
while (!eof(rf))
 { 
  $line = <rf>;
  chop($line);
  print "$line | ";
  ($hd,$cnt) = split(/\t/,$line);
                   
  $query  = "select max(cnt) from thomtemp where  heading=$hd";
  my $sth = $dbh->prepare($query); 
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  if (my $row = $sth->fetchrow_arrayref)
  { print "$$row[0]\n";  
    print wf "update quickUS10 set cnt='$$row[0]' where heading='$hd' and date='1008' and covflag='n';\n";  
  }
  $sth->finish;  
    
 }

close(rf);
close(wf);
  
$dbh->disconnect;
 
print "\n\nrun mysql thomas < $outfile\n";
print "Then run fix-uses-hd2.pl\n";
