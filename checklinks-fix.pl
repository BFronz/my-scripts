#!/usr/bin/perl
#
# writes a file that can be used to fix links

$fdate   = $ARGV[0];
if($ARGV[0] eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
use POSIX;
$dbh = DBI->connect("", "", "");

$infile="checklinks.txt";
open(rf, "$infile")  || die (print "Could not open $infile\n");

$outfile = "checklinks-update.txt";
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");

$outfile2 = "checklinks-update-problem.txt";
open(wf2,  ">$outfile2")  || die (print "Could not open $outfile2\n");
  

while (!eof(rf))
 {
  $instr = <rf>;
  chop($instr);
  ($acct,$diff) = split(/\|/,$instr);
  print "$j)$acct\n";
 
  $query  = " select alink, cnt from thomtnetlogALINKS09  where date='$fdate' and acct='$acct' order by cnt desc limit 1 ";
  #print "$query\n";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
   {
     if($$row[1] > $diff)
      {
       print wf "#$acct\t$$row[1]\t$$row[0]\n";
       print wf "update thomtnetlogALINKS09 set cnt = cnt - $diff where date='$fdate' and acct='$acct' and alink='$$row[0]' and cnt='$$row[1]' limit 1 ;\n";
      }
     else
      {
       #print "$query\n";
       print wf2 "$acct\t$alink\t$$row[1]\t$diff\n";
      }
   }

 $j++;
 }

close(rf);
close(wf);
close(wf2);

print "\nDone. Check output, run if needed\n"; 


$dbh->disconnect;



=for comment
 

=cut
