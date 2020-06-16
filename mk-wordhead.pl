#!/usr/bin/perl
#
# loads alternate heading table

require "trd-reload.ph";

$outfile   = "wordhead.txt";
     
use DBI;
require "/usr/wt/trd-reload.ph";

$fyear    = "20" . $yr;
     
# Get and process all headings            
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
$i=0;  
$MAXWORDLEN=20;
$query = "select heading ,cleanname from tgrams.headings where heading>0  order by cleanname ";
#$query .= " limit 100 ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {  
   if ($i % 1000 == 0) { print "$i\r"; }
   $hd   = $$row[0];   
   $clean   = $$row[1];
   #$clean = &MakeCleanName($clean);  
   $clean =~ s/ +$//;
   $clean =~ s/^ +//;
   @words = split(/ +/, $clean);
   $j = 0; 
   $wordct = @words;
   while ($j < @words)
    {
        if (length($words[$j]) > $MAXWORDLEN)
          { $words[$j] = substr($words[$j], 0, $MAXWORDLEN); }
        if ($words[$j] ne "co" && $words[$j] ne "inc" && $words[$j] ne ".")
          { print wf "$words[$j]\t$hd\n"; }
        $j++;
    }


  $i++;
 }
$sth->finish;

close(wf);
   
system("mysqlimport -dL tgrams $DIR/$outfile"); 
#system("rm -f $outfile");  
       
$rc = $dbh->disconnect;

exit; 



