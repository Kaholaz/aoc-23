use List::Util qw(sum any);
use strict;
use warnings;
use v5.34;

my @possible_games = ();
while (<>) {
	next if (/^$/);
	/Game (\d+):/;
	my $game = $1;

	next if (any {$_ > 12} /(\d+) red/g);
	next if (any {$_ > 13} /(\d+) green/g);
	next if (any {$_ > 14} /(\d+) blue/g);

	push @possible_games, $game;
}

say sum @possible_games;
