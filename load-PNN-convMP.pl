#!/usr/bin/perl
#
# Loads pnn conversions
# run ./load-PNN-conv.pl date

$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
$dbh      = DBI->connect("", "", "");
$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);             
$outfile  = "news_conversions.txt";
$outfile2 = "news_conversions$yy.txt";
     
$file[0]  = "nsv:advPRIDViews";         # story & press        
$file[1]  = "nlw:advPRIDWebLinks";      # weblinks  
 
#$file[]  = "nes:advPRIDEmailStory";    # email story          
#$file[]  = "ncc:advPRIDEmailCompany";  # contact company

# Load news_flag table used for scheduler
$outfile3 = "news_flag.txt";
open(wf,  ">$outfile3")  || die (print "Could not open $outfile3\n");
$query = " select distinct(acct) from thomnews_conversions$yy where date='$fdate' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
  print wf "$$row[0]\tC\n";
 }
$sth->finish;
   
# Delete from tables
$query = "delete from thomnews_conversions";
		#my $sth = $dbh->prepare($query);
		#if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
		#$sth->finish;
          
$query = "delete from thomnews_conversions$yy where date='$fdate'";
		#my $sth = $dbh->prepare($query);
		#if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
		#$sth->finish;

# Load files into log file
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
foreach $file (@file)        
 {                               
   ($type,$f) = split(/\:/, $file);
   $infile    = $fyear . "/" . $f . "-" . $fdate . ".txt";
   print "$infile\n";
  
   open(rf, "$infile")  || die (print "Could not open $infile\n");
   while (!eof(rf))
    {
      $instr = <rf>;
      chop($instr);
      print wf "$instr\t$type\n"; 
    } 
   close(rf); 
 }
close(wf);
system("mysqlimport -di thomas $outfile"); 
#system("rm -f $outfile"); 
  
# Query and load summary table
$query  = " select date, acct, prid,   ";
$query .= " sum(if(type='nsv',cnt,0)),  ";
$query .= " sum(if(type='ncc',cnt,0)), ";
$query .= " sum(if(type='nes',cnt,0)) , ";
$query .= " sum(if(type='nlw',cnt,0))  ";
$query .= " from news_conversions where date='$fdate'  group by prid "; 
#print "\n$query\n";
 
open(wf,  ">$outfile2")  || die (print "Could not open $outfile2\n");
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $date   = $$row[0];   
  $acct   = $$row[1];   
  $prid   = $$row[2];   
  $nsv     = $$row[3];   
  $ncc     = $$row[4];   
  $nes     = $$row[5];   
  $nlw     = $$row[6];   
   
  $subq = "select datepublished, headline from tgrams.news where prid=$prid ";
  my $subr = $dbh->prepare($subq);
  if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
  while (my $srow = $subr->fetchrow_arrayref)
   {
    $dpub  = $$srow[0];
    $hdl   = $$srow[1];
    $hdl =~ s/^\s+//; 
    $hdl  =~ s/\s+$//;
    $hdl  =~ s/\'//g;
   }
  $subr->finish;
 
  print wf "$date\t$acct\t$prid\t$nsv\t$ncc\t$nes\t$nlw\t$dpub\t$hdl\n";

  $acct = $prid = $nsv = $ncc = $nes = $nlw = $dpub = $hdl  = "";
 }
$sth->finish;
close(wf);
 
#system("mysqlimport -i thomas $outfile2");
#system("rm -f $outfile2"); 
  


$rc = $dbh->disconnect;



exit;


# this now run in newsxml
# Load news_flag table used for scheduler
$outfile3 = "news_flag.txt";
open(wf,  ">$outfile3")  || die (print "Could not open $outfile2\n");
$query = " select distinct(acct) from thomnews_conversions$yy where date='$fdate' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
  print wf "$$row[0]\tC\n";
 }
$sth->finish;

$query = " select distinct(AdvertiserCid) from thomnews_ad_cat$yy where date='$fdate' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
  print wf "$$row[0]\tI\n";
 }
$sth->finish;
close(wf);
system("mysqlimport -i thomas $outfile3");



=for comment

  CREATE TABLE news_conversions07 (               
  date varchar(4) NOT NULL default '',          
  acct bigint(20) NOT NULL default '0',         
  prid int(20) NOT NULL default '0',            
  nsv int(11) NOT NULL default '0',             
  ncc int(11) NOT NULL default '0',             
  nes int(11) NOT NULL default '0',             
  nlw int(11) NOT NULL default '0',             
  datepublished datetime default NULL,
  headline  varchar(255) NOT NULL default '',
  PRIMARY KEY  (date,acct,prid),
  key (datepublished)) ;  

 CREATE TABLE news_conversions (               
  date varchar(4) NOT NULL default '',          
  acct bigint(20) NOT NULL default '0',         
  cnt int(20) NOT NULL default '0',            
  prid int(11) NOT NULL default '0', 
  type varchar(6) NOT NULL default '',                           
  KEY  (date,acct,prid,type));                 
 
 CREATE TABLE news_flag (               
  acct bigint(20) NOT NULL default '0',
  rpt char(1) NOT NULL default '',    
  PRIMARY KEY  (acct,rpt));                                   

#advNewsCompanyStoryViews
#advPRIDViews

#advNewsEmailStory
#advPRIDEmailStory

#advNewsEmailCompany
#advPRIDEmailCompany

#advNewsWebLinks
#advPRIDWebLinks




=cut


