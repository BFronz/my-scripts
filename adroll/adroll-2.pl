#!/usr/bin/perl
#
#
# Get detailed account data 
 

use URI::Escape;
#use strict;
#use warnings;
use lib qw(..);
use JSON qw( );
use Data::Dumper;

use DBI;
require "/usr/wt/trd-reload.ph";

# authorization
$U="";
$P="";

# files
$outfile = "adroll_accts.txt";
open(wf, ">$outfile")  || die (print "$outfile\n");
$jfile = "/usr/wt/adroll/data2.json";
system("rm -f $jfile"); 

 
# put campaign eid in an array
$i = 0;
$query  =  "SELECT acct, eid, adgroups FROM thomadroll_map WHERE acct > 0 AND adgroups>'' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{ 
	$record[$i] = "$$row[0]|$$row[1]";
	$i++;
}
$sth->finish;
 
# get mapping data, parse and insert
$i=1;
foreach $record (@record)
{ 
	($acct,$campid) = split(/\|/,$record);
	
 
	$URL = "";
	$cmd = "curl -v  -o $jfile -u $U:$P  \"$URL\" ";
	print "\n$cmd\n";
	system("$cmd");
   
	# json parsing
	my $filename = 'dataimg.json';
	my $filename = $jfile;

	my $json_text = do {
		open(my $json_fh, "<:encoding(UTF-8)", $filename)
		or die("Can't open \$filename\": $!\n");
	local $/;
	<$json_fh>
	};

	# create import file
	my $json = JSON->new;
	my $data = $json->decode($json_text);
   
	for ( @{$data->{results}} ) {
	print "$i )$acct\t$campid\n";

	#print Dumper($data->{results}); 



	print $_->{name}." - name\n";
	print $_->{eid}." - eid\n";
	print "----------------------------------------------\n";

        # get ad
        $ads="";
      
        my $aref = $_->{ads};
	#print Dumper($aref); 
        for my $pick (@$aref) {
                print $pick->{id}, "\n";
                $ads .= "$pick->{id}|";
        } 
        print wf  "$ads\t";
    
	print wf "$_->{status}\t";
	print wf "$_->{updated_date}\t";

	#print wf "$_->{coops}\t";
	print wf " \t";  # leaving some these out for now, don't think I need it.

	print wf "$_->{ad_optimization}\t";
	print wf "$_->{campaign}\t";

	#print wf "$_->{site_exclusions}\t";
	print wf " \t";

	#print wf "$_->{platform_targets}\t";
	print wf " \t";

	print wf "$_->{type}\t";

	#print wf "$_->{segments}\t";
	print wf " \t";

	#print wf "$_->{geo_targets}\t";
	print wf " \t";
 
	#print wf "$_->{placement_targets}\t";
	print wf " \t";

 	print wf "$_->{eid}\t";
	print wf "$_->{is_cats4gold}\t";
	print wf "$_->{created_date}\t";

	#print wf "$_->{demographic_targets}\t";
	print wf " \t";

	print wf "$_->{space_optimization}\t";
	print wf "$_->{flight_timezone}\t";
	print wf "$_->{name}\t";
	print wf "$acct\n";
	}

	$i++; 


} 

close(wf);
 
# import data
system("mysqlimport -Ld thomas $outfile");

$rc = $dbh->disconnect;

print "\nDone...\n";


