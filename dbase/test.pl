#!/usr/bin/perl
#

$| = 1; # it's important for autoflush to be on
my $i;
for ( $i = 0; $i < 500000; $i++ )
{
    # ...

    # check, is this the 5th object?
    if ( ( $i % 100 ) == 0 )
    {
        printf( "%5d\r", $i );
    }

}
# clear status
print( ( " " x 5 ) . "\n" );
