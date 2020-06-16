#!/usr/bin/perl
# 
# loads test of new cad data

$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
$dbh      = DBI->connect("", "", "");
$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);  

sub CleanFormat
{
  $val=$_[0]; 
  $val =~ s/&gt;/\>/gi;
  $val =~ s/&lt;/\</gi;
  $val =~ tr/a-z/A-Z/;
  return $val;
}

$query = "select file_type, description  from CAD_file_type where file_type>'' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
  $c   = $$row[0];
  $d = $$row[1];
  $cft{$c} = $d;
  $c =~ tr/a-z/A-Z/;  
  $cft{$c} = $d; # uppercase version
  #print "$c\t$cft{$c}\n";
 }
$sth->finish;

### Load old    
$query = "delete from tnetlogCADDET_old where date='$fdate'";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
          
$infile   = $fyear . "/" . "advCADActionDetail-old" . "-" . $fdate . ".txt";
$outfile  = "tnetlogCADDET_old" . ".txt";
 
open(wf, ">$outfile")   || die (print "Could not open $outfile\n");
open(rf, "$infile")     || die (print "Could not open $infile\n");
while (!eof(rf))
  {
   $instr = <rf>;
   chop($instr);

   ($date, $acct, $ipaddress, $action_date, $action_time, $action, $partnum, $partname, $partdes, $format, $tinid) = split(/\t/, $instr);   
 
   ($mon,$day,$year) =  split(/\//, $action_date);

   $sortdate = $year . $mon . $day;
     
   $format  = &CleanFormat($format);
   $nformat = $cft{$format};
   if($nformat eq "") {$nformat = $format;}             
   
   if($action eq "cad part email")       {$action = "email";}
   elsif($action eq "cad part insert")   {$action = "insert";}
   elsif($action eq "cad part download") {$action = "download";}
   elsif($action eq "email")             {$action = "email";}
   elsif($action eq "E-mail")             {$action = "email";}
   elsif($action eq "download")          {$action = "download";}
   elsif($action eq "Download")          {$action = "download";}
   elsif($action eq "insert")            {$action = "insert";}
   elsif($action eq "Insert")            {$action = "insert";}
   else {$action="skip";}
  
   if($acct ne "" and $action ne "skip") 
    { 
     print wf  "$fdate\t$acct\t$ipaddress\t$action_date\t$action_time\t$partnum\t$partdes\t$partname\t$tinid\t$nformat\t$action\t$sortdate\n";
    }	
    $nformat = $date = $acct = $ipaddress = $action_date = $action_time = $partnum = $partname = $tinid =  $partdes  = $format = $action = $sortdate = $mon = $day = $year = "";

  }
close(rf);
close(wf);
system("mysqlimport -i thomas $outfile"); 



### Load new    
$query = "delete from tnetlogCADDET_new where date='$fdate'";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
          
$infile   = $fyear . "/" . "advCADActionDetail-new" . "-" . $fdate . ".txt";
$outfile  = "tnetlogCADDET_new" . ".txt";
 
open(wf, ">$outfile")   || die (print "Could not open $outfile\n");
open(rf, "$infile")     || die (print "Could not open $infile\n");
while (!eof(rf))
  {
   $instr = <rf>;
   chop($instr);

   ($date, $acct, $ipaddress, $action_date, $action_time, $action, $partnum, $partname, $partdes, $format, $tinid) = split(/\t/, $instr);   
 
   ($mon,$day,$year) =  split(/\//, $action_date);

   $sortdate = $year . $mon . $day;
     
   $format  = &CleanFormat($format);
   $nformat = $cft{$format};
   if($nformat eq "") {$nformat = $format;}             
   
   if($action eq "cad part email")       {$action = "email";}
   elsif($action eq "cad part insert")   {$action = "insert";}
   elsif($action eq "cad part download") {$action = "download";}
   elsif($action eq "email")             {$action = "email";}
   elsif($action eq "E-mail")             {$action = "email";}
   elsif($action eq "download")          {$action = "download";}
   elsif($action eq "Download")          {$action = "download";}
   elsif($action eq "insert")            {$action = "insert";}
   elsif($action eq "Insert")            {$action = "insert";}
   else {$action="skip";}
  
   if($acct ne "" and $action ne "skip") 
    { 
     print wf  "$fdate\t$acct\t$ipaddress\t$action_date\t$action_time\t$partnum\t$partdes\t$partname\t$tinid\t$nformat\t$action\t$sortdate\n";
    }	
    $nformat = $date = $acct = $ipaddress = $action_date = $action_time = $partnum = $partname = $tinid =  $partdes  = $format = $action = $sortdate = $mon = $day = $year = "";

  }
close(rf);
close(wf);
system("mysqlimport -i thomas $outfile"); 



