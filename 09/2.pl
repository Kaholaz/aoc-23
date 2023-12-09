use warnings;
use strict;
use v5.34;
use List::Util qw(any);

my $result = 0;
while (<>) {
	my @nums = /-?\d+/g;
	next if (not @nums);

	my @difs = (\@nums);
	do {
		my $prev = 0;
		my @dif = (map { my $out = $_ - $prev; $prev = $_; $out } @{$difs[-1]});
		@dif = @dif[1..$#dif];
		@difs = (@difs, \@dif);
	} while (any {$_} @{$difs[-1]});

	for (my $i = scalar @difs - 2; $i >= 0; --$i) {
		$difs[$i]->[0] = $difs[$i]->[0] - $difs[$i + 1]->[0];
	}
	$result += $difs[0]->[0];
}

say $result;

