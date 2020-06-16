#!/usr/bin/perl
#
#  Makes word table out of company
 
$wordfile = "catregcoall.txt";
$MAXWORDLEN = 10;

use DBI;
$dbh = DBI->connect("dbi:mysql:tgrams:localhost", "", "");

#$MAXLINES = 100;
#$limitq = " limit 10000 ";

# Open output file for writing company words
open (WF, ">$wordfile") || die(print "Could not open word file $wordfile\n");

# Get company words from catreg_history_all
$i=0;    
$query  = " select trim(company),tinid from  catreg_history_all  ";
#$query  = " select trim(company),tinid from  catreg_history_all where length(company)>1 and origin='TNET' $limitq ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
  { 
    $record[$i] = "$$row[0]:$$row[01]";
    $i++;
   }
$sth->finish;
$rc = $dbh->disconnect;


foreach $record (@record)
 { 
  ($clean,$tinid) = split(/\:/, $record);  

  # Write words out to text file
  $clean =~ s/ +$//;
  $clean =~ s/^ +//;
  $clean =~ s/ (corp|inc|llc|ltd|Ltd|Inc)$//;
  $clean =~ s/ (CORP|INC|LLC|LTD)$//;
  $clean =~ s/\&/ /;
  $clean =~ s/\,//;
  $clean =~ s/\(//;
  $clean =~ s/\)//;
  @words = split(/ +/, $clean);
  $j = 0; 
  $wordct = @words;
  while ($j < @words)
  {
    if (length($words[$j]) > $MAXWORDLEN) { $words[$j] = substr($words[$j], 0, $MAXWORDLEN); }

    if(length($words[$j]) >1)
    {
      if ($words[$j] ne "co" && $words[$j] ne "inc" && $words[$j] ne "and" && $words[$j] ne "." && $words[$j] ne "Inc." && $words[$j] ne "inc." &&
          $words[$j] ne "Ltd."  && $words[$j] ne "Co." && $words[$j] ne "INC" )
      { 
        print WF "$words[$j]\t$tinid\t\n";
        if ( ($j < @words-1) && (length($words[$j]) > 1) && ($words[$j+1] eq "s") )
         {print WF "$words[$j]s\t$tinid\t\n"; }
      }
    }

   $j++;
  }
 }


system("mysqlimport -di tgrams $wordfile");

