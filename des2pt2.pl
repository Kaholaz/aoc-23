use List::Util qw(sum);
use strict;
use warnings;
use v5.34;

my @power = ();
while (<>) {
	next if ($_ eq "\n");

	my $min_red = 0;
	while ($_ =~ /(\d+) red/g) {
		$min_red = $1 if ($1 > $min_red);
	}

	my $min_green = 0;
	while ($_ =~ /(\d+) green/g) {
		$min_green = $1 if ($1 > $min_green);
	}

	my $min_blue = 0;
	while ($_ =~ /(\d+) blue/g) {
		$min_blue = $1 if ($1 > $min_blue);
	}

	push @power, $min_red * $min_green * $min_blue;
}

say sum @power;
