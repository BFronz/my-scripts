#!/usr/bin/perl
#
#
   
use DBI; 
require "/usr/wt/trd-reload.ph";

# Change these vars

# Q1 2013
$outfile = "tnetRegistry34.csv";
$START=1357016400;
$END=1364788800;

# Q2 2013
$outfile = "tnetRegistry35.csv";
$START=1364788800;
$END=1372651200;

# Q3 2013
$outfile = "tnetRegistry36.csv";
$START=1372651200;
$END=1380600000;

# Q4 2013
$outfile = "tnetRegistry37.csv";
$START=1380600000;
$END=1388552400;

# Q1 2014
$outfile = "tnetRegistry38.csv";
$START=1388552400;
$END=1396324800;

# Q2 2014
$outfile = "tnetRegistry39.csv";
$START=1396324800;
$END=1404187200;

# Q3 2014
$outfile = "tnetRegistry40.csv";
$START=1404187200;
$END=1412136000;

# Q4 2014
$outfile = "tnetRegistry41.csv";
$START=1412136000;
$END=1420088400;

# Q1 2015
$outfile = "tnetRegistry42.csv";
$START=1420088400;
$END=1427860800;

# Q2 2015
$outfile = "tnetRegistry43.csv";
$START=1427860800;
$END=1435723200;

# Q2 2015
$outfile = "tnetRegistry44.csv";
$START=1435723200;
$END=1443672000;

# Q4 2015
$outfile = "tnetRegistry45.csv";
$START=1443672000;
$END=1451624400;

# Q1 2016
$outfile = "tnetRegistry46.csv";
$START=1451624400;
$END=1459483200;
 
# Q2 2016
$outfile = "tnetRegistry47.csv";
$START=1459483200;
$END=1467345600;


# Q3 2016
$outfile = "tnetRegistry48.csv";
$START=1467345600;
$END=1475294400;

# Q4 2016
$outfile = "tnetRegistry49.csv";
$START=1475294400;
$END=1483246800;

# Q1 201y
$outfile = "tnetRegistry50.csv";
$START=1483246800;
$END=1491019200;

  
# Q2 2017
$outfile = "tnetRegistry51.csv";
$START=1491019200;
$END=1498881600;

# Q3 2017
$outfile = "tnetRegistry52.csv";
$START=1498881600;
$END=1506830400;

 
# Put fips stuff into array
$i=0;
$query  = "select zip, state  from tgrams.fips group by zip "; 
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
  {
    $z = $$row[0];
    $s = $$row[1];
    $state{$z} = $s;
    $i++; 
   }
$sth->finish;  
print "\n\nTotal zip codes/states: $i\n\n";



        

open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
print wf "\"Company\",\"Industry\",\"Job Function\",\"State\",\"Zip\",\"Country\"\n";
$query = "SELECT  trim(company), trim(industry) as Industry, trim(jobfunction) as JobFunction, trim(zip) as Zip, trim(country) as Country ";
$query .= "FROM tgrams.sso_profile  AS h LEFT JOIN tgrams.mt_ringer as r ON h.tinid=r.tinid ";
$query .= "WHERE r.tinid  is null  AND company>'' AND company not in ('>','<','*','******','-','---','.','?','????','.....') ";
$query .= " and (created >=$START  and created<$END) and email like '%@%.%' and length(company)<200  and length(company)>1 and company not like '%-----%' and company not like '%******%' ";
$query .= "ORDER BY company "; 

$query = "SELECT  trim(company), trim(industry) as Industry, trim(jobfunction) as JobFunction, trim(zip) as Zip, trim(country) as Country ";
$query .= "FROM tgrams.mt_profile_history   AS h LEFT JOIN tgrams.mt_ringer as r ON h.tinid=r.tinid ";
$query .= "WHERE r.tinid  is null  AND company>'' AND company not in ('>','<','*','******','-','---','.','?','????','.....') ";
$query .= " and (created >=$START  and created<$END) and email like '%@%.%' and length(company)<200  and length(company)>1 and company not like '%-----%' and company not like '%******%' ";
$query .= "ORDER BY company "; 
 
#print "\n\n$query\n\n"; exit;
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
   $$row[0]=~ s/\"//g;
   $$row[1]=~ s/\"//g;
   $$row[2]=~ s/\"//g;
   $$row[3]=~ s/\"//g;
   $$row[4]=~ s/\"//g;
   print wf "\"$$row[0]\",\"$$row[1]\",\"$$row[2]\",\"$state{$$row[3]}\",\"$$row[3]\",\"$$row[4]\"\n";  
   $j++;
 }  
$sth->finish;
close(wf);
print "Total Records: $j in $outfile\n\n"; 
#system("rm -f /usr/pdf/csv/catreg/$outfile");
#system("cp -f $outfile /usr/pdf/csv/catreg/");

 

