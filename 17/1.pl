use warnings;
use strict;
use v5.34;

my @tiles =  grep { @$_ } map { chomp; [split ''] } <>;

my %visited = ();
my $result;
my $target = [$#tiles, $#{$tiles[0]}];
my @queue = ([0, [0,0], '.']);
while (@queue) {
	my $min_index;
	my $min = 'inf';
	for (0..$#queue) {
		if ($queue[$_]->[0] < $min) {
			$min_index = $_;
			$min = $queue[$_]->[0];
		}
	}

	my ($dist, $pos, $dir) = @{$queue[$min_index]};
	splice @queue, $min_index, 1;

	my $pos_str = join ',', @$pos;
	my $oposite = $dir eq '|' ? '-' : '|';
	if (exists $visited{$pos_str}) {
		if ($visited{$pos_str} eq $oposite) {
			$visited{$pos_str} = 1;
		} else {
			next;
		}
	} else {
		$visited{$pos_str} = $dir;
	}

	say scalar @queue;

	# Match!
	if ($pos->[0] == $target->[0] && $pos->[1] == $target->[1]) {
		$result = $dist;
		last;
	}

	if ($dir ne '|') {
		my $new_dist = $dist;
		for (1..3) {
			my $dest = [$pos->[0] + $_, $pos->[1]];
			last if out_of_bounds($dest);
			$new_dist += $tiles[$dest->[0]]->[$dest->[1]];
			push @queue, [$new_dist, $dest, '|'];
		}

		$new_dist = $dist;
		for (1..3) {
			my $dest = [$pos->[0] - $_, $pos->[1]];
			last if out_of_bounds($dest);
			$new_dist += $tiles[$dest->[0]]->[$dest->[1]];
			push @queue, [$new_dist, $dest, '|'];
		}
	}

	if ($dir ne '-') {
		my $new_dist = $dist;
		for (1..3) {
			my $dest = [$pos->[0], $pos->[1] - $_];
			last if out_of_bounds($dest);
			$new_dist += $tiles[$dest->[0]]->[$dest->[1]];
			push @queue, [$new_dist, $dest, '-'];
		}

		$new_dist = $dist;
		for (1..3) {
			my $dest = [$pos->[0], $pos->[1] + $_];
			last if out_of_bounds($dest);
			$new_dist += $tiles[$dest->[0]]->[$dest->[1]];
			push @queue, [$new_dist, $dest, '-'];
		}
	}
}

say "Result: $result";

sub out_of_bounds {
	my $pos = shift;
	return (
		$pos->[0] < 0 || $pos->[0] >$target->[0] ||
		$pos->[1] < 0 || $pos->[1] >$target->[1]
	);
}
