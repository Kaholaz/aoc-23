use warnings;
use strict;
use v5.34;
use List::Util qw(any);

my @mirrors =  grep { @$_ } map { chomp; [split ''] } <>;

my %beams;
sub send_beem {
	%beams = ();
	my ($dir, $coords) = @_;

	my @queue = [$dir, $coords];
	while (@queue) {
		my $q = shift @queue;
		($dir, $coords) = @$q;
		while (1) {
			last if out_of_bounds ($coords);
			last if check_beam ($dir, $coords);

			my $tile = $mirrors[$coords->[0]]->[$coords->[1]];
			if ($tile eq "\\") {
				$dir = [$dir->[1], $dir->[0]];
				$coords = [$coords->[0] + $dir->[0], $coords->[1] + $dir->[1]];
				next;
			}

			if ($tile eq '/') {
				$dir = [-$dir->[1], -$dir->[0]];
				$coords = [$coords->[0] + $dir->[0], $coords->[1] + $dir->[1]];
				next;
			}

			my $split = ($dir->[1] == 0) ? '-' : '|';
			if ($tile eq $split) {
				$dir = [$dir->[1], $dir->[0]];
				push @queue, [$dir, [$coords->[0] + $dir->[0], $coords->[1] + $dir->[1]]];
				$dir = [-$dir->[0], -$dir->[1]];
				push @queue, [$dir, [$coords->[0] + $dir->[0], $coords->[1] + $dir->[1]]];
				last;
			}

			$coords = [$coords->[0] + $dir->[0], $coords->[1] + $dir->[1]];
			next;
		}
	}
}

sub out_of_bounds {
	my $coords = shift;
	return (
		$coords->[0] < 0 ||
		$coords->[0] >= @mirrors ||
		$coords->[1] < 0 ||
		$coords->[1] >= @{$mirrors[0]}
	);
}

sub check_beam {
	my ($dir, $coords) = @_;

	my $coord_str = join ',', @$coords;
	my $dir_str = join '', @$dir;
	if (exists $beams{$coord_str}) {
		return 1 if (any { $_ eq $dir_str } @{$beams{$coord_str}});
		push @{$beams{$coord_str}}, $dir_str;
	} else {
		$beams{$coord_str} = [$dir_str];
	}
	return 0;
}

my $max_row = $#mirrors;
my $max_col = $#{$mirrors[0]};
my @possible_starts = map { ([[1, 0], [0, $_]], [[-1, 0], [$max_row, $_]]) } (0..$max_col);
@possible_starts = @possible_starts, map { ([[0, 1], [$_, 0]], [[0, -1], [$_, $max_col]]) } (0..$max_row);
my $possible_starts = $#possible_starts;

my $max = 0;
for (0..$possible_starts) {
	say "$_/$possible_starts";
	send_beem @{$possible_starts[$_]};
	my $cur = scalar keys %beams;
	$max = $cur if $cur > $max;
}

say $max

