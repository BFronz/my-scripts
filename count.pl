#!/usr/bin/perl
# 



use DBI;
require "/usr/wt/trd-reload.ph";   
 


$query = "SELECT vis FROM thomtempvis WHERE vis>'' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{    
	$$row[0] =~ s/([\\\'\"])/\\$1/gi;   
	$$row[0] =~ s/([\(\"])/\\$1/gi;   
	$$row[0] =~ s/([\)\"])/\\$1/gi;   
	$RECS   .= "'$$row[0]',";
	$count++;
}    
$sth->finish;
chop($RECS);
print "\nTotal: $count\n";

 
$q = "select count(distinct org) from thomtnetlogORGSITED15M where org in ($RECS) and latitude!='0.0001' ";
#print "$q";
my $sth = $dbh->prepare($q);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  print "Count: $$row[0]\n";
 }
$sth->finish;
 

print "\nDone...\n";
