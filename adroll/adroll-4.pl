#!/usr/bin/perl
#
#
# Get ads serverd with data by date and insert into a table


$start_date=$ARGV[0];
$end_date=$ARGV[1];
$fdate=$ARGV[2];
  

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
$outfile = "adroll_data_img.txt";
open(wf, ">$outfile")  || die (print "$outfile\n"); 
$jfile = "/usr/wt/adroll/data4.json"; 
 
# delete month records form tabl e
$query  = "DELETE FROM thomadroll_data_img WHERE fdate='$fdate'  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
 
      
# get data, parse and insert 
$URL="";
$URL .= "&start_date=$start_date&end_date=$end_date";
$cmd = "curl -v  -o $jfile -u $U:$P  \"$URL\" ";
system("$cmd");  
print "\n$cmd\n"; 
  
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
	print $_->{ad}." - ad\n";
	print $_->{eid}." - eid\n";
	print "----------------------------------------------\n";
	$i++;   
   
        print wf "$_->{status}\t";
        print wf "$_->{advertiser}\t";
        print wf "$_->{total_conversion_rate}\t";
        print wf "$_->{ad}\t";
        print wf "$_->{view_through_ratio}\t";
        print wf "$_->{cost_USD}\t";
        print wf "$_->{view_through_conversions}\t";
        print wf "$_->{height}\t";
        print wf "$_->{cpa_USD}\t";
        print wf "$_->{cost}\t";
        print wf "$_->{click_through_conversions}\t";
        print wf "$_->{adjusted_click_through_ratio}\t";
        print wf "$_->{impressions}\t";
        print wf "$_->{cpc_USD}\t";
        print wf "$_->{adjusted_cpa}\t";
        print wf "$_->{adjusted_view_through_ratio}\t";
        print wf "$_->{click_through_ratio}\t";
        print wf "$_->{prospects}\t";
        print wf "$_->{cpm}\t";
        print wf "$_->{ctr}\t";
        print wf "$_->{adjusted_vtc}\t";
        print wf "$_->{cpa}\t";
        print wf "$_->{cpc}\t";
        print wf "$_->{cpm_USD}\t";
        print wf "$_->{paid_impressions}\t";
        print wf "$_->{click_cpa}\t";
        print wf "$_->{total_conversions}\t";
        print wf "$_->{width}\t";
        print wf "$_->{ad_size}\t";
        print wf "$_->{adjusted_ctc}\t";
        print wf "$_->{adjusted_cpa_USD}\t";
        print wf "$_->{eid}\t";
        print wf "$_->{created_date}\t";
        print wf "$_->{adjusted_total_conversions}\t";
        print wf "$_->{adjusted_total_conversion_rate}\t";
        print wf "$_->{type}\t";
        print wf "$_->{clicks}\t";
        print wf "$_->{click_cpa_USD}\t";
	
	print wf "$fdate\t";
	print wf "0\n";
}  

close(wf);
 
# import data
system("mysqlimport -L thomas $outfile");
 
$rc = $dbh->disconnect;

print "\nDone...\n";


