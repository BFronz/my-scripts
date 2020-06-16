#!/usr/bin/perl
#
# Get images and update some tables


$fdate=$ARGV[0];

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
$outfile = "adroll_img.txt";
open(wf, ">$outfile")  || die (print "$outfile\n");
$jfile = "/usr/wt/adroll/data5.json";
 
# delete month records form table
$query  = "DELETE FROM thomadroll_img WHERE fdate='$fdate'  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
 
# put eid in an array
# put campaign eids in an array
$i = 0;
$query  =  "SELECT eid FROM thomadroll_data_img  WHERE fdate='$fdate' ";
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
        $URL .= "ad=$record";
	$cmd = "curl -v  -o $jfile -u $U:$P  \"$URL\" ";
	print "\n$cmd\n"; 
	system("$cmd");
	print "\n$URL\n\n";

	# json parsing
	my $filename = 'dataimg.json';
	my $filename = $jfile;

	my $json_text = do {
		open(my $json_fh, "<:encoding(UTF-8)", $filename)
		or die("Can't open \$filename\": $!\n");
	local $/;
	<$json_fh>
	};

	my $json = JSON->new;
	my $data = $json->decode($json_text);
  
	print "$j)  $data->{'results'}->{'name'}\t$URL\n";
	my $simg = $data->{'results'}->{'src'};   # full image source 
	@imgs = split(/\//, $simg);               # page [6] 
	@img  = split(/\?/, $imgs[6]);            # get image name [0]
	$imgloc  = "/usr/adroll/$img[0]";
 
	if ( ( -e "$imgloc" ) && ( -s "$imgloc" ) )  # check for image if doesn't exist pull
	{
		print "EXISTS $img[0]\n";
	}
	else
	{  
		print "GET $img[0]\n";
		$cmd     = "wget \"$simg\" -O $imgloc";
		system("$cmd"); 
		system("mv $imgloc /usr/adroll");
	}         

	print wf "$data->{'results'}->{'status'}\t";
	print wf "$data->{'results'}->{'body'}\t";
	print wf "$data->{'results'}->{'is_outlined'}\t";
	print wf "$data->{'results'}->{'updated_date'}\t";
	print wf "$data->{'results'}->{'ad_format'}\t";
	print wf "$data->{'results'}->{'is_liquid'}\t";
	print wf "$data->{'results'}->{'original_ad'}\t";
	print wf "$data->{'results'}->{'message_dynamic'}\t";
	print wf "$data->{'results'}->{'body_dynamic'}\t";
	print wf "$data->{'results'}->{'has_edits'}\t";
	print wf "$data->{'results'}->{'is_active'}\t";
	print wf "$data->{'results'}->{'app_id'}\t";
	print wf "$data->{'results'}->{'replacement_ad'}\t";
	print wf "$data->{'results'}->{'height'}\t";
  
        # get adgroups
	$adg="";
	#print wf "$data->{'results'}->{'adgroups'}\t";
        print Dumper($data->{'results'}->{'adgroups'});   
	my $aref = $data->{'results'}->{'adgroups'};
	for my $pick (@$aref) {
        	#print $pick->{id}, "\n";
		$adg = "$pick->{id}";
	}  
	print wf "$adg\t";	
 
	# get acct number from map
	$acct   =  0;
	$query  =  "SELECT acct  FROM thomadroll_map WHERE adgroups like '%$adg%' ";
	print "GET ACCT #: \n$query\n";
	my $sth = $dbh->prepare($query); 
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	if (my $row = $sth->fetchrow_arrayref)
	{ 
        	$acct = "$$row[0]";
	}

	print wf "$data->{'results'}->{'id'}\t";
	print wf "$data->{'results'}->{'headline_dynamic'}\t";
	print wf "$data->{'results'}->{'ad_format_id'}\t";
	print wf "$data->{'results'}->{'multi_share_optimized'}\t";
	print wf "$data->{'results'}->{'message'}\t";
	print wf "$data->{'results'}->{'destination_url'}\t";
	print wf "$data->{'results'}->{'has_pending_edits'}\t";
	print wf "$data->{'results'}->{'src'}\t";
	print wf "$data->{'results'}->{'advertisable'}\t";
	print wf "$data->{'results'}->{'outline_color'}\t";
	print wf "$data->{'results'}->{'name'}\t";
	print wf "$data->{'results'}->{'has_future_campaigns'}\t";
	print wf "$data->{'results'}->{'call_to_action'}\t";
	print wf "$data->{'results'}->{'headline'}\t";
	print wf "$data->{'results'}->{'inventory_type'}\t";
	print wf "$data->{'results'}->{'is_fb_dynamic'}\t";
	print wf "$data->{'results'}->{'width'}\t";
	print wf "$data->{'results'}->{'multiple_products'}\t";
 
	print wf "$data->{'results'}->{'eid'}\t";

	# update basic data using the eid
	$query = "UPDATE thomadroll_data_img SET acct='$acct' WHERE eid='$data->{'results'}->{'eid'}' AND fdate='$fdate'";
	print "\nUPDATE: $query\n";
	my $sth = $dbh->prepare($query);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	$sth->finish;
 
	print wf "$data->{'results'}->{'ad_format_name'}\t";
	print wf "$data->{'results'}->{'ad_parameters'}\t";
	print wf "$data->{'results'}->{'valid_clicktag'}\t";
	print wf "$data->{'results'}->{'type'}\t";
	print wf "$data->{'results'}->{'created_date'}\t";
	print wf "$fdate\t"; 
	print wf "$img[0]\t";  
	print wf "$acct\n";  
  

	undef %imgs; 
	undef %img; 
	undef %data;
	$j++;
} 

close(wf);

# import data
system("mysqlimport -L thomas $outfile");

$rc = $dbh->disconnect;

print "\nDone...\n";


