#!/usr/bin/perl
#
#

use DBI;
require "/usr/wt/trd-reload.ph";


# connect to po  
$data_source = "dbi:mysql:$db:po.rds.c.net";
$user        = ;
$auth        = ;
$dbh         = DBI->connect($data_source, $user, $auth);
      
$outfile = "mark_ispV2.txt";
system("rm -f $outfile");
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
 
$query = "select org  from thomwizlogos where isp='Y' and approved >''";
my $sth = $dbh->prepare($query);  
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{ 
	print wf "$$row[0]\n";  
} 
$sth->finish;

close(wf);
 
$dbh->disconnect;

system("mysqlimport -iL thomas $outfile");


print "\n\nDone...\n\n";
