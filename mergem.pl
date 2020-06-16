#!/usr/bin/perl
# Makes main_history table and main_map 

use DBI;

$data_source = "dbi:mysql:tgrams:localhost";
$user = "";
$auth = "";
 
$maxlines=500000;

$readfile=$ARGV[0];
$outfile="main_history.txt"; 
$outfile2="main_map.txt"; 
$i = 0;
$line = 0;
$flag="Y"; 

## Connect to mysql database 
$dbh = DBI->connect($data_source, $user, $auth);
  
## Open readfile
open (rf,  "$readfile") || die (print "Could not open file: $readfile\n");
open (wf,  ">$outfile") || die (print "Could not open file: $outfile\n");
open (wf2,  ">$outfile2")|| die (print "Could not open file: $outfile2\n");
while (!eof(rf) && $line < $maxlines)
  { 
    $instr=""; $oldacct=""; $newacct=""; $date="";
    $instr = <rf>;
    chop($instr); 

    ($oldacct,$newacct,$date) = split(/\t/, $instr);
    $oldacct =~ s/\s//g;
    $newacct =~ s/\s//g;
    $date    =~ s/\s//g;

    print wf2 "$oldacct\t$newacct\t$date\n";  
     
    $subq = "select * from main where acct='$newacct'";
    my $sth = $dbh->prepare($subq);
    if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
    while (my $row = $sth->fetchrow_arrayref)
     {                  
      print wf "$oldacct\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$$row[5]\t$$row[6]\t$$row[7]\t$$row[8]\t$$row[9]\t$$row[10]\t$$row[11]\t";
      print wf "$$row[12]\t$$row[13]\t$$row[14]\t$$row[15]\t$$row[16]\t$$row[17]\t$$row[18]\t$$row[19]\t$$row[20]\t$$row[21]\t$$row[22]\t";
      print wf "$$row[23]\t$$row[24]\t$$row[25]\t$$row[26]\t$$row[27]\t$$row[28]\t$$row[29]\t$$row[30]\t$$row[31]\t$$row[32]\t$$row[33]\t";
      print wf "$$row[34]\t$$row[35]\t$$row[36]\t$$row[37]\t$$row[38]\t$$row[39]\t$$row[40]\t$$row[41]\t$$row[42]\t$$row[43]\t$$row[44]\t";
      print wf "$$row[45]\t$$row[46]\t$$row[47]\tY\t$$row[49]\t$$row[50]\t$$row[51]\t$$row[52]\n";
     }
    $sth->finish;
 
   $line++;
  }
close(rf);
close(wf);
close(wf2);
 
## Disconnect from database 
$rc = $dbh->disconnect;
 
#system("mysqlimport -r tgrams $outfile");
system("mysqlimport -r tgrams $outfile2");

print "Total Records: $line\n";

