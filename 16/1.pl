use warnings;
use strict;
use v5.34;
use List::Util qw(any);

my @mirrors =  grep { @$_ } map { chomp; [split ''] } <>;

my %beams = ();
sub send_beem {
	my ($dir, $coords) = @_;

	my @queue = [$dir, $coords];
	while (@queue) {
		($dir, $coords) = @{shift @queue};
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

send_beem [0,1], [0,0];
say scalar keys %beams;

