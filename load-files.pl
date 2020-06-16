#!/usr/bin/perl
#
# Adds date to CATNAV tab delimited file and imports 
# Run as ./load-files.pl yymm file
#
# USER_IP_ADDRESSES don't get imported here need to run lookup.php then import

use utf8;

if($ARGV[0] eq "" || $ARGV[1] eq "") 
 {print "\n\nMissing date(yymm) or file\n\n"; exit;}

use DBI;
require "/usr/wt/trd-reload.ph";

$fdate  = $ARGV[0];
$infile = $ARGV[1];
$yy     = substr($fdate, 0, 2);
$mm     =  substr($fdate, 2, 2);

 
if   ($infile =~ /CN_ACTIVITY_MONTHLY/ )        { $table="catnav_summmary_log";  $table2="catnav_summmary" . $yy;  }
elsif($infile =~ /INQUIRIES/ )                  { $table="catnav_inquiries" . $yy; }
elsif($infile =~ /REFERRING_DOMAINS/ )          { $table="catnav_referring_domains" . $yy; }
elsif($infile =~ /REFERRING_KEYWORD_SEARCHES/ ) { $table="catnav_ref_keyword_searches" . $yy; }
elsif($infile =~ /CATALOG_KEYWORD_SEARCHES/ )   { $table="catnav_keyword_search" . $yy; }
elsif($infile =~ /USER_IP_ADDRESSES/ )          { $table="catnav_ipn" . $yy  . "_" . $mm ; $dontimport=1; }
else                                            { print "\n\nError - file/table match\n\n"; exit; }
  
$outfile  = $table . ".txt";
$outfile2 = $table2 . ".txt";
      
# Delete from table
$query = "delete from thom$table where date = '$fdate' ";
print "$query\n";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
  
if($infile =~ /CN_ACTIVITY_MONTHLY/ ){
$query = "delete from thom$table2 where date = '$fdate' ";
print "$query\n";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
}

system("rm -f $DIR/catnav/$outfile");
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");

open(rf, "$infile")  || die (print "Could not open $infile\n");
while (!eof(rf))
 {
  $instr = <rf>;
  chop($instr);
  utf8::encode($instr);

  if($infile =~ /REFERRING_KEYWORD_SEARCHES/ || $infile =~ /CATALOG_KEYWORD_SEARCHES/  )
   {  
    $instr =~ s/'/\\'/g; 
    $instr =~ s/"/\\"/g;	
    if($instr !~ /[^\x00-\x7e]/ ) {  print wf "$fdate\t$instr\n"; } 
    #     $instr =~ s/^\s+//; 
    #   $instr =~ s/\s+$//;
   } 
  else
   {
    print wf "$fdate\t$instr\n";
   }

 }
close(rf);
close(wf);
     
if($dontimport ne 1) 
 {
  system("mysqlimport -iL thomas $DIR/catnav/$outfile");
  #system("rm -f $outfile");
 }
else
 {
  system("mv $outfile ispin.txt");
  print "\nFile ispin.txt created used in Process IPs (lookup.php)\n ";
 } 


if($infile =~ /CN_ACTIVITY_MONTHLY/ )       
 { 
  $query = "delete from thomcatnav_summmary_log where  isactive='yes' and company like '%-test' and date=$fdate  ";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
  $sth->finish;
    
  system("rm -f $outfile2");
  open(wf2, ">$outfile2") || die (print "Could not open $outfile2\n");
  $query  = "select * from thomcatnav_summmary_log where date='$fdate' group by tgramsid,isactive ";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
    { 
     print wf2 "$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$$row[5]\t$$row[6]\t$$row[7]\t$$row[8]\t$$row[9]\t$$row[10]\t";
     print wf2 "$$row[11]\t$$row[12]\t$$row[13]\t$$row[14]\t$$row[15]\t$$row[16]\t$$row[17]\t$$row[18]\t$$row[19]\t$$row[20]\t";
     print wf2 "$$row[21]\t$$row[22]\t$$row[23]\t$$row[24]\t$$row[25]\t$$row[26]\t$$row[27]\t$$row[28]\t$$row[29]\t$$row[30]\t";
     print wf2 "$$row[31]\t$$row[32]\t$$row[33]\t$$row[34]\t$$row[35]\t$$row[36]\t$$row[37]\t$$row[38]\n";
    }
  $sth->finish; 
  close($wf2);
  system("mysqlimport -L thomas $DIR/catnav/$outfile2");
  

  $query  = "update thomcatnav_summmary$yy ";
  $query .= "set totalsearchend = ( ( (percentsesgoogleref + percentsesothersengref) / 100 )  * totalses) "; 
  $query .= "where date='$fdate' "; 
  #print "$query\n";  
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
  $sth->finish;
}


$rc = $dbh->disconnect; 

exit;


=for comment

Tables:
 
catnav_summmary{yy} 
catnav_keyword_search{yy}
catnav_inquiries{yy}
catnav_referring_domains{yy}
catnav_ref_keyword_searches{yy}
catnav_ip{yy}

=cut
