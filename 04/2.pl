use strict;
use warnings;
use v5.34;

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

my $result = 0;
my @counts = map {1} @num_matches;
for my $i ((0..scalar @counts - 1)) {
	my $winning_count = $num_matches[$i];
	my $card_dupes = $counts[$i];

	$result += 1 + $winning_count * $card_dupes;
	for (($i + 1..$i + $winning_count)) {
		$counts[$_] += $card_dupes;
	}
}
say $result;

