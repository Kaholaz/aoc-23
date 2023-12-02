use List::Util qw(sum);
use strict;
use warnings;
use v5.34;

my @possible_games = ();
while (<>) {
	next if (/^$/);
	/Game (\d+):/;
	my $game = $1;

	next if (grep {$_ > 12} map {/\d+/; $&} /\d+ red/g);
	next if (grep {$_ > 13} map {/\d+/; $&} /\d+ green/g);
	next if (grep {$_ > 14} map {/\d+/; $&} /\d+ blue/g);

	push @possible_games, $game;
}

say sum @possible_games;
