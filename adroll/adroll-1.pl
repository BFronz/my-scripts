#!/usr/bin/perl
#
# 
# Get all campaign_eids, tgrams # and adgroups and insert into a table adroll_map
     
 
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
$outfile = "adroll_map.txt";
open(wf, ">$outfile")  || die (print "$outfile\n"); 
$jfile = "/usr/wt/adroll/data1.json";
     
# get mapping data, parse and insert
$URL="";
$cmd = "curl -v  -o $jfile -u $U:$P  \"$URL\" ";
system("$cmd");  
print "\n$cmd\n"; 
#exit;
  
# json parsing
my $filename = 'data.json';
my $filename = $jfile;
 
my $json_text = do {
   open(my $json_fh, "<:encoding(UTF-8)", $filename)
      or die("Can't open \$filename\": $!\n");
   local $/;
   <$json_fh>
};

my $json = JSON->new;
my $data = $json->decode($json_text);
  
# create import file     
print "\n";
$i=0; 
for ( @{$data->{results}} ) {
	print "$i)\t";
	print $_->{name}." - name\n";
	print $_->{eid}." - eid\n";
	print "----------------------------------------------\n";
	$i++;   
   
	print wf "$_->{updated_date}\t";
	print wf "$_->{is_pubgraph}\t";
	print wf "$_->{is_fb_lookalike}\t";
	print wf "$_->{spend_limit_until}\t";
	print wf "$_->{is_fbx_newsfeed}\t";
	print wf "$_->{is_cats4gold}\t";
	print wf "$_->{is_facebook}\t";
	print wf "$_->{is_rtb}\t";
	print wf "$_->{is_retargeting}\t";
	print wf "$_->{start_date}\t";
	print wf "$_->{status}\t";
	print wf "$_->{campaign_type}\t";
	print wf "$_->{end_date}\t";
	print wf "$_->{created_date}\t";
	print wf "$_->{is_active}\t";
	print wf "$_->{is_fb_wca}\t";
	print wf "$_->{max_cpm}\t";
	print wf "$_->{cpm}\t";
	print wf "$_->{advertisable}\t";
	print wf "$_->{bid_type}\t";
	print wf "$_->{name}\t";
	print wf "$_->{cpc}\t";
	print wf "$_->{budget}\t";
	print wf "$_->{is_coop}\t";

	#print wf "$_->{pricing_strategies}\t";
	print wf " \t";	 # leaving this out for now, don't think I need it.

	print wf "$_->{eid}\t";
 
	# get adgroups
	#print wf "$_->{adgroups}\t";
	#print Dumper($_->{adgroups}); 
	$adarray =$_->{adgroups};
	while (my ($i, $el) = each @$adarray) {
		#print "$i | $el\n";
		$adg .= $el . "|";
	} 
	print wf "$adg\t";

	print wf "$_->{is_apple}\t";

	# parse tgrams
	$acct = substr($_->{name}, 0, 8);
	$acct =~ s/^\s+//;
	$acct =~ s/\s+$//;	
	if($acct eq "") {  $acct = "0"; }
	print wf "$acct\n"; 

	undef($adg); 
	$acct = 0;
}  

close(wf);
 
# import data
system("mysqlimport -Ld thomas $outfile");
 
$rc = $dbh->disconnect;

print "\nDone...\n";


