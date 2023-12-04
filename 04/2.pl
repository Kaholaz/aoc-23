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

my $result = 0;
my @winnings = map {scalar @$_} @all_matches;
my @counts = map {1} @all_matches;
for my $i ((0..scalar @counts - 1)) {
	my $winning = $winnings[$i];
	my $count = $counts[$i];

	$result += 1 + $winning * $count;
	next if (not $winning);
	for (($i + 1..$i + $winning)) {
		$counts[$_] += $count;
	}
}
say $result;

