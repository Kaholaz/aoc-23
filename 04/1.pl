use strict;
use warnings;
use v5.34;
use List::Util qw(any sum reduce);

my @all_matches = ();
while (<>) {
	next if ($_ eq "\n");

	my ($game, $all_numbers) = split /:/;
	my ($winnings, $numbers) = split /\|/, $all_numbers;
	my @winnings = sort { $a <=> $b } map {/\d*/; $&} grep { length $_ } split / /, $winnings;
	my @numbers = sort { $a <=> $b } map {/\d*/; $&} grep { length $_ } split / /, $numbers;

	my $matches = [];
	my $w = 0;
	my $n = 0;
	while ($w < (scalar @winnings) && $n < (scalar @numbers)) {
		my $winning = $winnings[$w];
		my $number = $numbers[$n];
		if ($winning < $number) {
			++$w;
		} elsif ($winning > $number) {
			++$n;
		} elsif ($winning == $number) {
			++$w;
			++$n;
			push @$matches, $winning;
		}
	}
	push @all_matches, $matches;
}

sub points {
	my $numbers = shift;
	my $l = scalar @$numbers;
	return 0 if (not $l);
	return 2 ** ($l - 1);
}

say sum map { points $_ } @all_matches;

