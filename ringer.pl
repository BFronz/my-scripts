#!/usr/bin/perl
#
#
# Matches bad words/phrases in mt_profile_history with mt_badwords. 
# Pulls tinid and adds to mt_ringer table. Run at least each month.  

use DBI;
require "/usr/wt/trd-reload.ph";

$maxlines=500000;
$writefile="mt_ringer.txt";

# First put ringer words/phrases into an array
$query  = " select word from tgrams.mt_badword  ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
$i = 0;
while (my $row = $sth->fetchrow_arrayref)
 {      
  $$row[0] =~ tr/A-Z/a-z/;
  $word[$i] = $$row[0];
  #print "$word{$$row[0]}\n"; 
  $i++;
 }
$sth->finish;
print "\nRinger words/phrases: $i\n\n";

 
# Loop through mt_profile_history table (fname,lname,company,zip fields) and loop through word array. 
# Pull tinid's that have a match
# Don't touch tinids that are already in mt_ringer file(only as new). These controled by Thomas 
open (wf,  ">$writefile") || die (print "Could not open file: $writefile\n"); 

$query  = " select fname, lname, company, zip, p.tinid from tgrams.mt_profile_history as p ";
$query .= " LEFT JOIN tgrams.mt_ringer as r ON  p.tinid=r.tinid ";
$query .= " where r.tinid is null ";    
#$query .= " limit 10  "; 

my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
$line = 0;
while (my $row = $sth->fetchrow_arrayref)
 {
  $$row[0] =~ s/\s+$//;
  $$row[0]=~ s/^\s+//;
  $$row[1] =~ s/\s+$//;
  $$row[1]=~ s/^\s+//;
  $$row[2] =~ s/\s+$//;
  $$row[2]=~ s/^\s+//;
  $$row[3] =~ s/\s+$//;
  $$row[3]=~ s/^\s+//;

  $$row[0] =~ tr/A-Z/a-z/;
  $$row[1] =~ tr/A-Z/a-z/;
  $$row[2] =~ tr/A-Z/a-z/;
  $$row[3] =~ tr/A-Z/a-z/;
  $tinid   = $$row[4];
  
  $fname     = $$row[0];
  foreach $word (@word) { 
     # if($fname =~ /$word / ) { print wf "$tinid\n"; $r++; }
      if($fname eq "$word" ) { print wf "$tinid\n"; $r++; }
   }
 
  $lname     = $$row[1];
  foreach $word (@word) { 
    #if($lname =~ /$word/ ) { print wf "$tinid\n"; $r++; } 
     if($lname eq "$word" ) { print wf "$tinid\n"; $r++; } 
  } 

  $company   = $$row[2];
  foreach $word (@word) { 
    #if($company =~ /$word / ) { print wf "$tinid\n"; $r++; } 
     if($company eq "$word" ) { print wf "$tinid\n"; $r++; } 
  }  

  $zip       = $$row[3];
  foreach $word (@word) { 
    #if($zip =~ /$word/ ) { print wf "$tinid\n";  $r++; } 
     if($zip eq "$word" ) { print wf "$tinid\n";  $r++; } 
  } 
    
  # print "$fname,$lname,$company,$zip\n";
  $fname==""; $lname==""; $company=""; $zip="";
  $line++;
 }
$sth->finish;
close(wf);  
 
print "\nProfile records processed: $line\n\n";
print "\nBad word/phrases matched: $r\n\n";

system("mysqlimport -iL tgrams $DIR/$writefile");
