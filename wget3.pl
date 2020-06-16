#!/usr/bin/perl
#
 
use strict;
use warnings;

use lib qw(..);

use JSON qw( );

my $filename = 'data.json';

my $json_text = do {
   open(my $json_fh, "<:encoding(UTF-8)", $filename)
      or die("Can't open \$filename\": $!\n");
   local $/;
   <$json_fh>
};

my $json = JSON->new;
my $data = $json->decode($json_text);

for ( @{$data->{results}} ) {
my $campaingn =  $_->{campaign};
print "$campaingn"; exit;



print $_->{cdvertiser}."\n";
print $_->{campaign}."\n";
print $_->{adjusted_view_through_ratio}."\n";
print $_->{adjusted_attributed_view_through_rev}."\n";
print $_->{adjusted_ctc}."\n";
print $_->{attributed_click_through_rev}."\n";
print $_->{cpc_USD}."\n";
print $_->{adjusted_cpa}."\n";
print $_->{click_cpa}."\n";
print $_->{attributed_view_through_rev}."\n";
print $_->{adjusted_total_conversions}."\n";
print $_->{adjusted_total_conversion_rate}."\n";
print $_->{type}."\n";
print $_->{total_conversions}."\n";
print $_->{end_date}."\n";
print $_->{cost_USD}."\n";
print $_->{adjusted_attributed_view_through_rev_USD}."\n";
print $_->{roi}."\n";
print $_->{start_date}."\n";
print $_->{cpm_USD}."\n";
print $_->{budget}."\n";
print $_->{adjusted_vtc}."\n";
print $_->{clicks}."\n";
print $_->{eid}."\n";
print $_->{adjusted_attributed_rev}."\n";
print $_->{adjusted_click_through_ratio}."\n";
print $_->{total_conversion_rate}."\n";
print $_->{view_through_ratio}."\n";
print $_->{cost}."\n";
print $_->{click_through_conversions}."\n";
print $_->{impressions}."\n";
print $_->{adjusted_attributed_click_through_rev}."\n";
print $_->{adjusted_attributed_click_through_rev_USD}."\n";
print $_->{paid_impressions}."\n";
print $_->{budget_USD}."\n";
print $_->{attributed_rev_USD}."\n";
print $_->{click_through_ratio}."\n";
print $_->{click_cpa_USD}."\n";
print $_->{status}."\n";
print $_->{adjusted_attributed_rev_USD}."\n";
print $_->{created_date}."\n";
print $_->{attributed_view_through_rev_USD}."\n";
print $_->{cpa_USD}."\n";
print $_->{attributed_rev}."\n";
print $_->{attributed_click_through_rev_USD}."\n";
print $_->{prospects}."\n";
print $_->{cpm}."\n";
print $_->{ctr}."\n";
print $_->{cpa}."\n";
print $_->{cpc}."\n";
print $_->{adjusted_cpa_USD}."\n";
print $_->{view_through_conversions}."\n";

}
