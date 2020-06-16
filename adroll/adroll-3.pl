#!/usr/bin/perl
#
# get adroll expanded data by month
 
$start_date=$ARGV[0];
$end_date=$ARGV[1];
$fdate=$ARGV[2];
  

use URI::Escape;
#use strict;
#use warnings;
use lib qw(..);
use JSON qw( );

use DBI;
require "/usr/wt/trd-reload.ph";
   
# authorization
$U="";
$P="";

# files
$outfile = "adroll_data.txt";
open(wf, ">$outfile")  || die (print "$outfile\n"); 
$jfile = "/usr/wt/adroll/data3.json";

# delete month records form table
$query  = "DELETE FROM thomadroll_data WHERE fdate='$fdate'  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;


# put eid in an array
# put campaign eids in an array
$i = 0;
$query  =  "SELECT eid FROM thomadroll_map WHERE acct > 0 AND adgroups>'' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
        $record[$i] = "$$row[0]";
        $i++;
}
$sth->finish;


$j=1;
foreach $record (@record)
{     
	
	$URL = "";
	$URL .= "&campaigns=$record";
	$URL .= "&start_date=$start_date&end_date=$end_date";  
     
	print "\n\nstart_date: $start_date\nend_date: $end_date\nfdate: $fdate\nURL: $URL\n\n";
	$cmd = "curl -v  -o $jfile -u $U:$P  \"$URL\" ";
	system("$cmd");  
	#print "\n$cmd\n"; exit;
  
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
	$i=0;
	for ( @{$data->{results}} ) {
	print "$i)\t";
	print $_->{campaign}." - campaign\n";
	print $_->{eid}." - eid\n";
	print $_->{impressions}." - impressions\n";
	print $_->{clicks}." - clicks\n";
	print "----------------------------------------------\n";
	$i++;  
   
	print wf "$_->{advertiser}\t";
	print wf "$_->{campaign}\t";
	print wf "$_->{adjusted_view_through_ratio}\t";
	print wf "$_->{adjusted_attributed_view_through_rev}\t";
	print wf "$_->{adjusted_ctc}\t";
	print wf "$_->{attributed_click_through_rev}\t";
	print wf "$_->{cpc_USD}\t";
	print wf "$_->{adjusted_cpa}\t";	
	print wf "$_->{click_cpa}\t";
	print wf "$_->{attributed_view_through_rev}\t";
	print wf "$_->{adjusted_total_conversions}\t";
	print wf "$_->{adjusted_total_conversion_rate}\t";
	print wf "$_->{type}\t";
	print wf "$_->{total_conversions}\t";
	print wf "$_->{end_date}\t";
	print wf "$_->{cost_USD}\t";
	print wf "$_->{adjusted_attributed_view_through_rev_USD}\t";
	print wf "$_->{roi}\t";
	print wf "$_->{start_date}\t";
	print wf "$_->{cpm_USD}\t";
	print wf "$_->{budget}\t";
	print wf "$_->{adjusted_vtc}\t";
	print wf "$_->{clicks}\t";
	print wf "$_->{eid}\t";
	print wf "$_->{adjusted_attributed_rev}\t";
	print wf "$_->{adjusted_click_through_ratio}\t";
	print wf "$_->{total_conversion_rate}\t";
	print wf "$_->{view_through_ratio}\t";
	print wf "$_->{cost}\t";
	print wf "$_->{click_through_conversions}\t";
	print wf "$_->{impressions}\t";
	print wf "$_->{adjusted_attributed_click_through_rev}\t";
	print wf "$_->{adjusted_attributed_click_through_rev_USD}\t";
	print wf "$_->{paid_impressions}\t";
	print wf "$_->{budget_USD}\t";
	print wf "$_->{attributed_rev_USD}\t";
	print wf "$_->{click_through_ratio}\t";
	print wf "$_->{click_cpa_USD}\t";	
	print wf "$_->{status}\t";
	print wf "$_->{adjusted_attributed_rev_USD}\t";
	print wf "$_->{created_date}\t";
	print wf "$_->{attributed_view_through_rev_USD}\t";
	print wf "$_->{cpa_USD}\t";
	print wf "$_->{attributed_rev}\t";
	print wf "$_->{attributed_click_through_rev_USD}\t";
	print wf "$_->{prospects}\t";
	print wf "$_->{cpm}\t";
 	print wf "$_->{ctr}\t";
	print wf "$_->{cpa}\t";
	print wf "$_->{cpc}\t";
	print wf "$_->{adjusted_cpa_USD}\t";
	print wf "$_->{view_through_conversions}\t";
	print wf "$fdate\t";

	# parse tgrams
	$acct = substr($_->{campaign}, 0, 8);
	$acct =~ s/^\s+//;
	$acct =~ s/\s+$//;
	if($acct eq "") {  $acct = "0"; }
	print wf "$acct\n";
	}  

}


close(wf);

# import data
system("mysqlimport -L thomas $outfile");
 
$rc = $dbh->disconnect;

print "\nDone...\n";


