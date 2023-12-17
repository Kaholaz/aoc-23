use warnings;
use strict;
use v5.34;

my @tiles =  grep { @$_ } map { chomp; [split ''] } <>;

# <heap>
my @queue = ([0, [0,0], '.']);
sub pop_queue {
	@queue[0,$#queue] = @queue[$#queue, 0];
	my $out = pop @queue;

	my $i = 0;
	while ($i * 2 < $#queue) {
		my $l = ($i * 2) + 1;
		my $r = ($i * 2) + 2;

		my $smallest = $i;
		if ($queue[$l]->[0] < $queue[$smallest]->[0]) {
			$smallest = $l;
		}
		if ($r < @queue && $queue[$r]->[0] < $queue[$smallest]->[0]) {
			$smallest = $r;
		}

		last if $smallest == $i;
		@queue[$i, $smallest] = @queue[$smallest, $i];
		$i = $smallest;
	}

	return $out;
}

sub insert_queue {
	my $insert = shift;
	push @queue, $insert;
	my $i = $#queue;

	while ($i > 0 && $queue[int(($i - 1) / 2)]->[0] > $queue[$i]->[0]) {
		@queue[$i, int(($i - 1) / 2)] = @queue[int(($i - 1) / 2), $i];
		$i = int(($i - 1) / 2);
	}
}
# </heap>

my %visited = ();
my $result;
my $target = [$#tiles, $#{$tiles[0]}];
while (@queue) {
	my ($dist, $pos, $dir) = @{pop_queue()};
	my $oposite = $dir eq '|' ? '-' : '|';
	if (exists $visited{join ',', @$pos}) {
		if ($visited{join ',', @$pos} eq $oposite) {
			$visited{join ',', @$pos} = 1;
		} else {
			next;
		}
	} else {
		$visited{join ',', @$pos} = $dir;
	}

	say scalar @queue;

	# Match!
	if ($pos->[0] == $target->[0] && $pos->[1] == $target->[1]) {
		$result = $dist;
		last;
	}

	if ($dir ne '|') {
		my $new_dist = $dist;
		for (1..10) {
			my $dest = [$pos->[0] + $_, $pos->[1]];
			last if out_of_bounds($dest);
			$new_dist += $tiles[$dest->[0]]->[$dest->[1]];
			insert_queue([$new_dist, $dest, '|']) if $_ >= 4;
		}

		$new_dist = $dist;
		for (1..10) {
			my $dest = [$pos->[0] - $_, $pos->[1]];
			last if out_of_bounds($dest);
			$new_dist += $tiles[$dest->[0]]->[$dest->[1]];
			insert_queue([$new_dist, $dest, '|']) if $_ >= 4;
		}
	}

	if ($dir ne '-') {
		my $new_dist = $dist;
		for (1..10) {
			my $dest = [$pos->[0], $pos->[1] - $_];
			last if out_of_bounds($dest);
			$new_dist += $tiles[$dest->[0]]->[$dest->[1]];
			insert_queue([$new_dist, $dest, '-']) if $_ >= 4;
		}

		$new_dist = $dist;
		for (1..10) {
			my $dest = [$pos->[0], $pos->[1] + $_];
			last if out_of_bounds($dest);
			$new_dist += $tiles[$dest->[0]]->[$dest->[1]];
			insert_queue([$new_dist, $dest, '-']) if $_ >= 4;
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
