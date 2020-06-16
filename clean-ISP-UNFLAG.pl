#!/usr/bin/perl
# 

$table         = $ARGV[0];
$visitortype   = $ARGV[1];
if($table eq "" || $visitortype eq "") {print "\n\nForgot to add table or visitor name\n\n"; exit;} 

print "\n$table\t$visitortype\n";
   
use DBI;
$dbh      = DBI->connect("", "", "");

sub updateTable
{ 
	$q = $_[0];
	#print "\n\n$q\n\n"; 
	print "\nUpdating $table\n";
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
	$sth->finish;
	sleep(1);
}   

$query = "SELECT org FROM thomtnetlogORGUnflag WHERE org>'' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{   
	$$row[0] =~ s/([\\\'\"])/\\$1/gi;   
	$$row[0] =~ s/([\(\"])/\\$1/gi;   
	$$row[0] =~ s/([\)\"])/\\$1/gi;   
	$ISPS   .= "'$$row[0]',";
	$count++;
}    
$sth->finish;
chop($ISPS);
print "\nTotal Unflag ISPs: $count\n";
updateTable("UPDATE $table SET isp='N', block='N' WHERE $visitortype IN ( $ISPS ) ");    
 
print "\nDone...\n";
