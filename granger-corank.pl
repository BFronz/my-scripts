#!/usr/bin/perl
#
#
 
$cid   = $ARGV[0];
$date   = $ARGV[1];
if($cid eq "" || $date eq "" ) {print "\n\nForgot to add cid and or date\n\n"; exit;}

$ALLCOV = "National";

$COVAREA{"NA"} = "$ALLCOV";
$COVAREA{"AL"} = "Alabama";
$COVAREA{"AK"} = "Alaska";
$COVAREA{"AZ"} = "Arizona";
$COVAREA{"AR"} = "Arkansas";
$COVAREA{"CN"} = "California - Northern";
$COVAREA{"CS"} = "California - Southern";
$COVAREA{"CO"} = "Colorado";
$COVAREA{"CT"} = "Connecticut";
$COVAREA{"DE"} = "Delaware";
$COVAREA{"DC"} = "District of Columbia";
$COVAREA{"FL"} = "Florida";
$COVAREA{"GA"} = "Georgia";
$COVAREA{"HI"} = "Hawaii";
$COVAREA{"ID"} = "Idaho";
$COVAREA{"IL"} = "Illinois";
$COVAREA{"IN"} = "Indiana";
$COVAREA{"IA"} = "Iowa";
$COVAREA{"KS"} = "Kansas";
$COVAREA{"KY"} = "Kentucky";
$COVAREA{"LA"} = "Louisiana";
$COVAREA{"ME"} = "Maine";
$COVAREA{"MD"} = "Maryland";
$COVAREA{"EM"} = "Massachusetts - Eastern";
$COVAREA{"WM"} = "Massachusetts - Western";
$COVAREA{"MI"} = "Michigan";
$COVAREA{"MN"} = "Minnesota";
$COVAREA{"MS"} = "Mississippi";
$COVAREA{"MO"} = "Missouri";
$COVAREA{"MT"} = "Montana";
$COVAREA{"NE"} = "Nebraska";
$COVAREA{"NV"} = "Nevada";
$COVAREA{"NH"} = "New Hampshire";
$COVAREA{"JN"} = "New Jersey - Northern";
$COVAREA{"JS"} = "New Jersey - Southern";
$COVAREA{"NM"} = "New Mexico";
$COVAREA{"DN"} = "New York - Metro";
$COVAREA{"UN"} = "New York - Upstate";
$COVAREA{"NC"} = "North Carolina";
$COVAREA{"ND"} = "North Dakota";
$COVAREA{"NO"} = "Ohio - Northern";
$COVAREA{"SO"} = "Ohio - Southern";
$COVAREA{"OK"} = "Oklahoma";
$COVAREA{"OR"} = "Oregon";
$COVAREA{"EP"} = "Pennsylvania - Eastern";
$COVAREA{"WP"} = "Pennsylvania - Western";
$COVAREA{"PR"} = "Puerto Rico";
$COVAREA{"RI"} = "Rhode Island";
$COVAREA{"SC"} = "South Carolina";
$COVAREA{"SD"} = "South Dakota";
$COVAREA{"TN"} = "Tennessee";
$COVAREA{"NT"} = "Texas - North";
$COVAREA{"GT"} = "Texas - South";
$COVAREA{"UT"} = "Utah";
$COVAREA{"VT"} = "Vermont";
$COVAREA{"VA"} = "Virginia";
$COVAREA{"WA"} = "Washington";
$COVAREA{"WV"} = "West Virginia";
$COVAREA{"WI"} = "Wisconsin";
$COVAREA{"WY"} = "Wyoming";

$COVAREA{"AB"} = "Alberta";
$COVAREA{"BC"} = "British Columbia";
$COVAREA{"MB"} = "Manitoba";
$COVAREA{"NB"} = "New Brunswick";
$COVAREA{"NF"} = "Newfoundland";
$COVAREA{"NW"} = "Northwest Territories";
$COVAREA{"NS"} = "Nova Scotia";
$COVAREA{"NU"} = "Nunavut";
$COVAREA{"ON"} = "Ontario";
$COVAREA{"PE"} = "Prince Edward Island";
$COVAREA{"QC"} = "Quebec";
$COVAREA{"SK"} = "Saskatchewan";
$COVAREA{"YT"} = "Yukon";

use DBI;
$dbh      = DBI->connect("dbi:mysql:tgrams:localhost", "", "");
                          
open(wf, ">corank-$cid.csv")  || die (print "Could not open corank-$cid.csv\n");

# set timeout 
$query = "SET wait_timeout=2500";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
 

# print out some company data
$q  = "select company, address1,city, state, zip from tgrams.main where acct=$cid";
my $sth = $dbh->prepare($q);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{    
  $company  = $$row[0];
  $addr1    = $$row[1];
  $city     = $$row[2];
  $state    = $$row[3];
  $zip      = $$row[4];
} 
$sth->finish;

print wf "\"Company Ranking Report $date\"\n";
print wf "\n";
print wf "\"$company\",\"$acct\"\n";
print wf "\"$addr1 $city, $state $zip\"\n";
print wf "\n";
       
# Get preimum data and put into an array   
$q = "select heading from tgrams.premiums where acct=$cid and premium='D'";
my $sth = $dbh->prepare($q);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
 $h  = $$row[0];
 $premium[$h]=$h;   
 #print "$premium[$h]\n";
} 
$sth->finish;  


# Get position and company count data and put into array  
$q  = "select cov, p.heading as hd, pos, pop, trim(description) as d ";                     
$q .= "from tgrams.position as p left join tgrams.headings h on p.heading=h.heading  ";    
#$q .= "and cov='NA' ";                                                                                                  
$q .= "where acct=$cid and p.heading>0 and cov>'' order by cov, d  ";                       
#$q .= " limit 100 ";
#print "\n$q\n"; exit;
$n = $a = 0;
$z = 1;
my $sth = $dbh->prepare($q);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{    
  $cov    = $$row[0];
  $hd     = $$row[1];
  $pos    = $$row[2];
  $pop    = $$row[3];
  $des    = $$row[4]; 
 
  #print "$z\t$cov\t$hd\n";
 
  if($premium[$hd] ne ""){ $pv="x"; }   
  else                   { $pv=" "; }   

  if($pos eq ""){$pos=0;}          
  if($pop eq ""){$pop=0;}          
        
  #$desc =~ s/\"//g;
                                 
  $sq  = "select cnt_headin  as c from tgrams.covprodhd where heading='$hd' and area='$cov'";
  #print "\n$sq\n"; exit;
  my $subr = $dbh->prepare($sq);
  if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
  while (my $srow = $subr->fetchrow_arrayref)
   {        
    $cocnt = $$srow[0];   
   }     
  $subr->finish; 
  if($cocnt eq ""){$cocnt=0;} 


  if($cov eq "NA") 
    {
     $recnat[$n]="$cov|$hd|$pv|$pos|$des|$pop|$cocnt";
     $n++;
    }
   else
    {
     $reccov[$a]="$cov|$hd|$pv|$pos|$des|$pop|$cocnt";
     $a++; 
    }
  $z++;
 
 $cov=$hd=$pv=$pos=$des=$pop=$cocnt="";
} 
$sth->finish; 

 
# National
print "National";
$covhold ="";
foreach $record (@recnat)
 {
  ($cov,$hd,$pv,$pos,$des,$pop,$cocnt) = split(/\|/,$record);
 
  if($covhold ne $cov)
     {       
      print wf "\"Coverage Area: National\"\n"; 
      print wf "\"Product Category\",\"Preview Ad\",\"Rank\",\"Ranking Points\",\"Total Co's by Category\"\n";
      $covhold=$cov; 
     }  
 
  print wf "\"$des\",\"$pv\",\"$pos\",\"$pop\",\"$cocnt\"\n";
}  

print wf "\n";


# Coverages
print "\nCoverages\n";
$covhold = $cov="";
foreach $recordcov (@reccov)
 {
  ($cov,$hd,$pv,$pos,$des,$pop,$cocnt) = split(/\|/,$recordcov);
 
  if($covhold ne $cov)
     {      
      print wf "\n";   
      print wf "\"Coverage Area: $COVAREA{$cov}\"\n";   
      print wf "\"Product Category\",\"Preview Ad\",\"Rank\",\"Ranking Points\",\"Total Co's by Category\"\n";
      $covhold=$cov;
     } 

  print wf "\"$des\",\"$pv\",\"$pos\",\"$pop\",\"$cocnt\"\n";
  #print wf "$des\t$pv\t$pos\t$pop\t$cocnt\n";
}




close(rf);  
close(wf);

$dbh->disconnect;

print "\n\Done...\n" 




