#!/usr/bin/perl
# 
# resolve IPs via dbase
# process ip addresses from dbaseNetAcuityIP, these include CAD, CATNAV & News loaded monthly

$| = 1;
 
use DBI;
require "/usr/wt/trd-reload.ph";

use LWP::Simple;
use JSON;
use Data::Dumper;
use utf8;
#use HTML::Entities;
#use Encode;
#use strict;
#use warnings;
  
sub CleanDbase {      
	my $data=shift;
	$data =~ s/\/N//i;  
	$data =~ s/^\s+//;
	$data =~ s/\s+$//;
	$data =~ tr/[A-Z]/[a-z]/; 
	#$data = encode_entities($data);
	utf8::decode($data);
	#utf8::encode($data);
	return $data;
}     
    
$start = time(); 

  
my $outfile  = "registration-resolved.txt";
open(wf,  ">$DIR/dbase/$outfile")  || die (print "Could not open $outfile\n");
print wf "tinid\tip\tcreated\tvisitor\tdom\tcity\tstate\tzip\tcountry\tisp\tnaics\tprimary_sic\tdunsnum\tdomestichqdunsnumber\thqdunsnumber\tgltdunsnumber\tcountrycode\tcountrycode3\taudience\taudiencesegment\tb2b\temployee_range\tforbes2k\tfortune1k\tindustry\tinformationlevel\tlatitude\tlongitude\tphone\trevenue_range\tsubindustry\n"; 
 


my $dbkey    = "9b07d129aa62479636667e2bf1e891054714d307";
my $dburl    = "http://api.dbase.com/api/v2/ip.json?key=$dbkey&query=";
my $now = time(); 
my $i = 1;
my $badrec = 0;
 
#print "$dburl"; exit;
       
# pull ip addresses,  created=0 will only pull new ips
 
$query = "SELECT  trim(user_id), trim(value)  FROM tgrams.sso_user_ext_prop WHERE user_id!=0 "; 
#print "\n$query\n"; exit;       
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{    
	$tinid = $$row[0];
	$ip = $$row[1];
	print "$i) $ip\t$tinid\n";
	$badrec = 0;
 
	# create dbase url
	my $dburl =  $dburl . $ip ;
	#print "$dburl\n"; 
 
	# retreive data, print out 404 urls
	my $json = get( $dburl ) || $badrec++;
  
	#if($badrec == 1) { print wf2 "$ip\t$dburl\n"; print "$i) $ip\n"; }
   
	if($badrec == 0) 
	{   
		# decode data
		my $jvars = decode_json( $json );
		#print Dumper $jvars;
      
		# know if detailed data is returned
		my $level = $jvars->{'information_level'};
 
		# use basic vs detailed as flag, basic limited fields returned, detailed all fields returned
		if($level eq "Basic") 
		{
			$org                   = $jvars->{'registry_company_name'};  # basic
			$dom                   = $jvars->{'web_site'};  
			$city                  = $jvars->{'registry_city'};          # basic
			$state                 = $jvars->{'registry_state'};         # basic
			$zip                   = $jvars->{'registry_zip_code'};      # basic
			$naics                 = $jvars->{'naics'}; 
			$country               = $jvars->{'registry_country'};       # basic
			$isp                   = $jvars->{'isp'};                    # basic
			$naics                 = $jvars->{'naics'};
			$primary_sic           = $jvars->{'primary_sic'};
			$dunsnum               = $jvars->{'duns_num'};
			$domestichqdunsnumber  = $jvars->{'domduns_num'};
			$hqdunsnumber	       = $jvars->{'hqduns_num'};
			$gltdunsnumber	       = $jvars->{'gltduns_num'};
			$countrycode	       = $jvars->{'registry_country_code'};  # basic
			$countrycode3	       = $jvars->{'registry_country_code3'}; # basic
			$audience	       = $jvars->{'audience'};               # basic
			$audiencesegment       = $jvars->{'audience_segment'};       # basic
			$b2b	               = $jvars->{'b2b'};
			$employee_range	       = $jvars->{'employee_range'};
			$forbes2k	       = $jvars->{'forbes_2000'};
			$fortune1k	       = $jvars->{'fortune_1000'};
			$industry	       = $jvars->{'industry'};
			$informationlevel      = $jvars->{'information_level'};
			$latitude	       = $jvars->{'registry_latitude'};       # basic
			$longitude	       = $jvars->{'registry_longitude'};      # basic
			$phone	               = $jvars->{'phone'};
			$revenue_range	       = $jvars->{'revenue_range'};
			$subindustry	       = $jvars->{'sub_industry'};
			$hqdunsnumber	       = $jvars->{'hqduns_num'};
		}  
		else
		{
			$org                   = $jvars->{'company_name'};
			$dom                   = $jvars->{'web_site'};
			$city                  = $jvars->{'city'};
			$state                 = $jvars->{'state'};
			$zip                   = $jvars->{'zip'};
			$country               = $jvars->{'country_name'};
			$isp                   = $jvars->{'isp'};
			$naics                 = $jvars->{'naics'};
			$primary_sic           = $jvars->{'primary_sic'};
			$dunsnum               = $jvars->{'duns_num'};
			#$domestichqdunsnumber  = $jvars->{domestichq}->{'domduns_num'};
			$domestichqdunsnumber  = $jvars->{'domduns_num'};
			$hqdunsnumber	       = $jvars->{'hq'}->{'hqduns_num'};
			#$gltdunsnumber	       = $jvars->{'gltduns_num'};
			$gltdunsnumber	       = $jvars->{domestichq}->{'gltduns_num'};
			$countrycode	       = $jvars->{'registry_country_code'};
			$countrycode3	       = $jvars->{'registry_country_code3'};
			$audience	       = $jvars->{'audience'};
			$audiencesegment       = $jvars->{'audience_segment'};
			$b2b	               = $jvars->{'b2b'};
			$employee_range	       = $jvars->{'employee_range'};
			$forbes2k	       = $jvars->{'forbes_2000'};
			$fortune1k	       = $jvars->{'fortune_1000'};
			$industry	       = $jvars->{'industry'};
			$informationlevel      = $jvars->{'information_level'};
			$latitude	       = $jvars->{'latitude'};
			$longitude	       = $jvars->{'longitude'};
			$phone	               = $jvars->{'phone'};
			$revenue_range	       = $jvars->{'revenue_range'};
			$subindustry	       = $jvars->{'sub_industry'};
		} 
   
	$org                     = &CleanDbase($org);
	$dom                     = &CleanDbase($dom);
	$city                    = &CleanDbase($city);	
	$state                   = &CleanDbase($state);
	$zip                     = &CleanDbase($zip);
	$country                 = &CleanDbase($country);
	$isp                     = &CleanDbase($isp);
	$naics                   = &CleanDbase($naics);
	$primary_sic             = &CleanDbase($primary_sic);
	$dunsnum                 = &CleanDbase($dunsnum);
	$domestichqdunsnumber    = &CleanDbase($domestichqdunsnumber);
	$hqdunsnumber            = &CleanDbase($hqdunsnumber);
	$gltdunsnumber           = &CleanDbase($gltdunsnumber);
	$countrycode             = &CleanDbase($countrycode);
	$countrycode3            = &CleanDbase($countrycode3);
	$audience                = &CleanDbase($audience);
	$audiencesegment         = &CleanDbase($audiencesegment);
	$b2b                     = &CleanDbase($b2b);
	$employee_range          = &CleanDbase($employee_range);
	$forbes2k                = &CleanDbase($forbes2k);
	$fortune1k               = &CleanDbase($fortune1k);
	$industry                = &CleanDbase($industry);
	$informationlevel        = &CleanDbase($informationlevel);
	$latitude                = &CleanDbase($latitude);
	$longitude               = &CleanDbase($longitude);
	$phone                   = &CleanDbase($phone);
	$revenue_range           = &CleanDbase($revenue_range);
	$subindustry             = &CleanDbase($subindustry);
    
	# write out
	print wf "$tinid\t$ip\t$created\t$org\t$dom\t$city\t$state\t$zip\t$country\t$isp\t$naics\t$primary_sic\t$dunsnum\t$domestichqdunsnumber\t$hqdunsnumber\t$gltdunsnumber\t$countrycode\t$countrycode3\t$audience\t$audiencesegment\t$b2b\t$employee_range\t$forbes2k\t$fortune1k\t$industry\t$informationlevel\t$latitude\t$longitude\t$phone\t$revenue_range\t$subindustry\n";
	}    
	
	# counter, cleanup & little bit of delay
	#if ($i % 10 == "0") { print "$i\r"; } 
 
	if ( ( $i % 100 ) == 0 ) { printf( "%5d\r", $i ); } 

	$i++; 
	$org=$dom=$city=$state=$zip=$country=$isp=$naics=$primary_sic=$country_code=$dunsnum=$domestichqdunsnumber="";
	$hqdunsnumber=$gltdunsnumber=$countrycode=$countrycode3=$audience=$audiencesegment=$b2b=$employee_range="";
	$forbes2k=$fortune1k=$industry=$informationlevel=$latitude=$phone=$revenue_range=$subindustry="";
	undef(@json);
	select(undef, undef, undef, 0.0005);
 }    
$sth->finish;

# Time
$end = time(); 
$ttime  =  ($end - $start) / 60; 
$ttime = sprintf("%.3f", $ttime);
print "\n\nMinutes: $ttime\n\n";

close(wf);
close(wf2);

$rc = $dbh->disconnect;

