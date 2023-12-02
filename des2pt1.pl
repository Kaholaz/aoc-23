use List::Util qw(sum);
use strict;
use warnings;
use v5.34;

my @possible_games = ();
outer: while (<>) {
	next if ($_ eq "\n");
	$_ =~ /Game (\d+):/;
	my $game = $1;

	while ($_ =~ /(\d+) red/g) {
		next outer if ($1 > 12);
	}

	while (my $green = $_ =~ /(\d+) green/g) {
		next outer if ($1 > 13);
	}

	while (my $blue = $_ =~ /(\d+) blue/g) {
		next outer if ($1 > 14);
	}

	push @possible_games, $game;
}

say sum @possible_games;
