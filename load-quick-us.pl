#!/usr/bin/perl
#
# Loads sate heading by coverage table
# run ./load-quick-us.pl date(yymm)

$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
require "/usr/wt/trd-reload.ph";


$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);             

$outfile  = "quickUSlog.txt";
       
$file[0]  = "t:allCategories"; 
$file[1]  = "x:VisitsCatCov"; 
$file[2]  = "n:visitsNationalCat"; 
   
# Delete from table          
$query = "delete from thomquickUS$yy where date='$fdate'";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

# Delete from tables
$query = "delete from thomquickUSlog";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

# Load files into table
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
foreach $file (@file)        
 {                               
   ($type,$f) = split(/\:/, $file);
   $infile    =$fyear . "/" . $f . "-" . $fdate . ".txt";
   print "$infile\n";

   open(rf, "$infile")  || die (print "Could not open $infile\n");
   while (!eof(rf))
    {
      $instr = <rf>;
      chop($instr); 
      if($type eq "x")   # cov 
         { 
          ($d,$ct,$hd,$cov) = split(/\t/,$instr);
          if(length $cov == 2){ $cov =~ tr/a-z/A-Z/; }
          print wf "$d\t$hd\t$ct\t$cov\n";
         }  
       else   # total & nat
        {
         ($d,$ct,$hd) = split(/\t/,$instr);
         print wf "$d\t$hd\t$ct\t$type\n";
        } 

      $d = $hd =  $ct =  $cov = ""; 

    }
   close(rf);
 }
close(wf);
system("mysqlimport -iL thomas $DIR/$outfile"); 


# Query and load summary table

$outfile  = "quickUS$yy.txt";
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");  
 
$query  = "select date, heading, covflag, sum(cnt) ";
$query .= "from  thomquickUSlog  where date=$fdate ";
$query .= "group by heading,covflag ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {        
  $date        = $$row[0];
  $heading     = $$row[1];
  $covflag     = $$row[2];
  $cnt         = $$row[3];
  print wf "$date\t$heading\t$cnt\t$covflag\n";
 }

close(wf);

system("mysqlimport -iL thomas $DIR/$outfile"); 

$rc = $dbh->disconnect;


exit;

=for comment

=cut


