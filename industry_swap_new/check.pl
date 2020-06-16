#!/usr/bin/perl
# 

$table         = $ARGV[0];
$fdate         = $ARGV[1];
 
if($table eq "" || $fdate eq "") {print "\n\nForgot to add table or date\n\n"; exit;}

if($table =~ /adcvmaster/ || $table =~ /tnetlogADviewsServerOrg/)  { $usedate = "fdate"; }
else                                                               { $usedate = "date";  }
 
use DBI;
require "/usr/wt/trd-reload.ph";  

 
 
if($usedate eq "") { $usedate = "date";  }

#print "\n$table\t$fdate\t$usedate\n";  

$fdate = "$fdate";

sub CheckTable
{ 
  $q = $_[0];
  #print "$q\n";
  my $sth = $dbh->prepare($q);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  if (my $row = $sth->fetchrow_arrayref)
   {
    print  "$table\t$$row[0]\n";
   }
  $sth->finish;
print "\n";
 
 sleep(1);
}   

CheckTable("SELECT count(*) FROM $table WHERE $usedate  = '$fdate' ");


