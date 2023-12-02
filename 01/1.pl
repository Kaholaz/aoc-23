use List::Util qw(sum);
use strict;
use warnings;
use v5.34;

my @result = ();
while (<>) {
	$_ = $_ =~ s/[^0-9]//rg;
	next if ($_ eq '');
	push @result, (substr $_, 0, 1) . substr($_, -1, 1);
}

say sum @result;
