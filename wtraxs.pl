#!/usr/bin/perl
#
#

use DBI;
require "/usr/wt/trd-reload.ph";

$max_lor_date = 20151201;
  
$data_source2 = "dbi:mysql:$db:po.rds.c.net";
$user2 = ;
$auth2 = ;
$dbh2  = DBI->connect($data_source2, $user2, $auth2);
 


    
sub PrintQ
{
 $q = $_[0];
 #print "\n$q\n";
}

$outfile = "wt.txt";
system("rm -f $outfile");
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
 
print wf "Account Name\t";                     
print wf "Account Number\t";                   
print wf "Live\t";
print wf "New\n";
 
$i=0;
 
$query = "select m.company, m.acct from thomwebtraxs_cross as r, tgrams.main as m where m.acct=r.acct  and date_format(webtraxs_session_start, '%Y%m%d') < $max_lor_date  group by m.acct order by m.company ";
#$query  .= "LIMIT 10 "; # for testing 
my $sth = $dbh->prepare($query);  
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $record[$i]="$$row[0]|$$row[1]";
  $i++;
 }
$sth->finish;

$z=1;
foreach $record (@record)
{
 print "$z) $record\n";
 ($comp,$acct) = split(/\|/,$record);
 
 $pcount = "0";
 $q = "SELECT count(*) FROM thomwebtraxs_cross WHERE acct='$acct'  and date_format(webtraxs_session_start, '%Y%m%d') < $max_lor_date ";
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  { 
   $pcount = "$$row[0]";
  }
 $sth->finish;

 $mcount = "0";
 $q = "SELECT count(*) FROM thomwebtraxs_cross WHERE acct='$acct' and date_format(webtraxs_session_start, '%Y%m%d') < $max_lor_date ";
 my $sth2 = $dbh2->prepare($q);
 if (!$sth2->execute) { print "Error" . $dbh2->errstr . "<BR>\n"; exit(0); }
 while (my $row2 = $sth2->fetchrow_arrayref)
  { 
   $mcount = "$$row2[0]";
  }
 $sth->finish;

 if($pcount > $mcount) {$flag="***";}
 else     {$flag=" ";}
  
 print wf "$comp\t";
 print wf "$acct\t";

 print wf "$mcount\t";
 print wf "$pcount\t";

 print wf "$flag\n"; 

 $z++;
}

close(wf);
 
$dbh->disconnect;
$dbh2->disconnect;
 
print "\n\nDone...\n\n";
