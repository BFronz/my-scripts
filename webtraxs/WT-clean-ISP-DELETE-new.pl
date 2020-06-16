#!/usr/bin/perl
# 
 
use DBI;
require "/usr/wt/trd-reload.ph";

sub updateTable
{
	$q = $_[0];
	#print "\n\n$q\n\n";
	print "\nUpdating $table by delete\n";
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
	$sth->finish;
	sleep(1);
}   
 
    
# demand base isps 
$query = "SELECT org FROM thomtnetlogORGflagDbase WHERE org>'' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
        $$row[0] =~ s/([\\\'\"])/\\$1/gi;
        $ISPS   .= "'$$row[0]',";
        $count++;
}
$sth->finish;
chop($ISPS);
print "\nTotal dbase ISPs: $count\n"; 
updateTable(" delete from thomwebtraxs_cross where visitor in ( $ISPS ) ");

 
# extra isps
$query = "select org from thommark_ispV2";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{   
	$$row[0] =~ s/([\\\'\"])/\\$1/gi;   
	$ISPS   .= "'$$row[0]',";
	$count++;
}   
$sth->finish;
chop($ISPS);
print "\nTotal Mark ISPs: $count\n";
updateTable("delete from thomwebtraxs_cross where visitor in ($ISPS) ");



# suppress
$query = "select org from thomorg_suppressV2";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{   
	$$row[0] =~ s/([\\\'\"])/\\$1/gi;   
	$BLOCKS   .= "'$$row[0]',";
	$count++;
}    
$sth->finish;
chop($BLOCKS);
print "\nTotal BLOCKSs: $count\n";
updateTable("delete from thomwebtraxs_cross where visitor in ($BLOCKS) ");
 
 
print "\nDone...\n";
