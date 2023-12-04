use strict;
use warnings;
use v5.34;
use List::Util qw(sum);

my @num_matches = ();
while (<>) {
	next if (not /^Card\s+(\d+):(.*)\|(.*)$/);

	my ($game, $winnings, $numbers) = ($1, $2, $3);
	my @winnings = sort { $a <=> $b } $winnings =~ /\d+/g;
	my @numbers = sort { $a <=> $b } $numbers =~ /\d+/g;

	my $num_matches = 0;
	my $w = 0;
	my $n = 0;
	while ($w < (scalar @winnings) && $n < (scalar @numbers)) {
		my $winning = $winnings[$w];
		my $number = $numbers[$n];
		if ($winning < $number) { ++$w; }
		elsif ($winning > $number) { ++$n; }
		else {
			++$w;
			++$n;
			++$num_matches;
		}
	}
	push @num_matches, $num_matches;
}

say sum map { $_ ? 2 ** ($_ - 1) : 0 } @num_matches;

