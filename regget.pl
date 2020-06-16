#!/usr/bin/perl
# 

use DBI;
require "/usr/wt/trd-reload.ph";

$outfile="reg-visitors1607-1706.txt";
system("rm -f $outfile");
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");

$i=1;

sub AddSlashes {
    $text = shift;
    ## Make sure to do the backslash first!
    $text =~ s/\\/\\\\/g;
    $text =~ s/'/\\'/g;
    $text =~ s/"/\\"/g;
    $text =~ s/\\0/\\\\0/g;
    return $text;
}

 

$query ="select t.org, jobfunction, t.industry, t.city, t.state, t.zip from tnetlogORGDAllM as t
left join tgrams.sso_profile  as p on t.org=p.company
where t.date in ('1607','1608','1609','1610','1611','1612','1701','1702','1703','1704','1705','1706')
and  (t.longitude='0.0001' && t.latitude='0.0001')
group by t.org, t.city, t.state, t.zip ";
 
$query ="select t.org, t.industry, t.city, t.state, t.zip from tnetlogORGDWIZ as t
where t.date in ('1607','1608','1609','1610','1611','1612','1701','1702','1703','1704','1705','1706')
and  (t.longitude='0.0001' && t.latitude='0.0001') and  t.org>''
group by t.org, t.city, t.state, t.zip "; 


my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $org   = $$row[0];
  $ind   = $$row[1];
  $city  = $$row[2];
  $state = $$row[3];
  $zip   = $$row[4];
 
 $orgsearch = AddSlashes($org);	
 
 
      
  $subq = "select jobfunction from tgrams.sso_profile2 where company='$orgsearch' order by created desc limit 1 ";
  #print "\n$subq\n";
  my $subr = $dbh->prepare($subq);
  if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
  while (my $srow = $subr->fetchrow_arrayref)
   { 
    $jf  = $$srow[0]; 
   }
  $subr->finish;
 
  print  "$i. $org\t$jf\n";

  print wf "$org\t$jf\t$ind\t$city\t$state\t$zip\n";
 
 $org = $jf = $ind = $city = $state = $zip ="";
 
 $i++;
 } 
$sth->finish; 


close(wf);

$dbh->disconnect;

print "\n\nDone...\n\n";
