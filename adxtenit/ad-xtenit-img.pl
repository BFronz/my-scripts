#!/usr/bin/perl
#
# Pulls images 


use DBI;
require "/usr/wt/trd-reload.ph";
 
$query  = "select trim(img) from thomad_xtenit_id  where found='' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
   $theimg= $$row[0] ;
   $$row[0] =~ s/^\s+//;
   $$row[0] =~ s/\s+$//;
   # @lines =   `curl  $$row[0]`;  # > /usr/wt/adxtenit  
  
   ($a,$b,$c,$d) = split(/\//, $$row[0]);
   system ("curl  -sf -o /usr/pdf/imagesx/newsletter/$d $$row[0]");
   
   print "$$row[0]\n/usr/pdf/imagesx/newsletter/$d\n\n";
 
  if (( -e "/usr/pdf/imagesx/newsletter/$d" ) && ( -s "/usr/pdf/imagesx/newsletter/$d" ))  # check for image if doesn't exist pull
   {  
    print "Image OK\n";
             
    $subq = "update thomad_xtenit_id  set found='Y' where  img='$theimg'";
    my $subr = $dbh->prepare($subq);
    if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
    $subr->finish;
   }  
  else
   { 
    print "Missing Image\n";
   }

  sleep(2);
  
} 
$sth->finish;

 

