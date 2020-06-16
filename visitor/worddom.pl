#!/usr/bin/perl
#
# loads domain word tables
# run as ./mk-worddom.pl



use DBI;
require "/usr/wt/trd-reload.ph";
    
$MAXWORDLEN=20;
#$test=1;
 

# domains 
$i = 0;  
print "worddom2\n";
$outfile = "worddom2.txt";            
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
$query  = "select oid, dcleanname ";
$query .= "from visitor_tool ";
#$query .= "where orgid>0 and isp='N' and length(domain)>1 and length(org)>1  and checked=''  ";
$query .= "where orgid>0 and length(domain)>1 and length(org)>1  and checked=''  ";
$query .= "order by dcleanname ";
if($test eq 1) { $query .= " limit 1000 "; print "$query\n"; } 
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {       
   $oid   = $$row[0];   
   $clean   = $$row[1];
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
          { print wf "$words[$j]\t$oid\n"; }
        $j++;
    }
  undef(@words);
  $i++;
 }
$sth->finish;
close(wf);
if($test ne 1) { system("mysqlimport -iL thomas $DIR/visitor/$outfile"); } 
  

# domains by heading
$i=0;   
print "worddomhead2\n\n";
$outfile = "worddomhead2.txt";
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
$query = "select heading, dcleanname, oid ";
$query .= "from visitor_cat_tool ";
#$query .= "where orgid>0 and isp='N' and block='N' and length(domain)>1 and length(org)>1  and checked=''  ";
$query .= "where orgid>0 and  length(domain)>1 and length(org)>1  and checked=''  ";
$query .= "order by dcleanname  ";
if($test eq 1) { $query .= " limit 1000 ";  print "$query\n";}
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {   
   $hd    = $$row[0];   
   $clean = $$row[1];  
   $oid = $$row[2]; 
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
          { print wf "$words[$j]\t$hd\t$oid\n"; }
        $j++;
    }
  undef(@words);
  $i++;
 }
$sth->finish;
close(wf);
if($test ne 1) { system("mysqlimport -iL thomas $DIR/visitor/$outfile"); } 
   
$rc = $dbh->disconnect;

exit; 


