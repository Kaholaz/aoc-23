use List::Util qw(sum max);
use strict;
use warnings;
use v5.34;

my @power = ();
while (<>) {
	next if (/^$/);

	my $min_red = max 0, map {/\d+/; $&} /\d+ red/g;
	my $min_green = max 0, map {/\d+/; $&} /\d+ green/g;
	my $min_blue = max 0, map {/\d+/; $&} /\d+ blue/g;

	push @power, $min_red * $min_green * $min_blue;
}

say sum @power;
