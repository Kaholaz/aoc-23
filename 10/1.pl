use warnings;
use strict;
use v5.34;

sub sym_to_cors {
	my ($start, $symbol) = @_;
	my @out = ();

	if ($symbol eq 'S') {
		push @out, 'S';
	}

	if (grep { $symbol eq $_ } ('|', 'L', 'J')) {
		push @out, [$start->[0] - 1, $start->[1]];
	}
	if (grep { $symbol eq $_ } ('-', 'L', 'F')) {
		push @out, [$start->[0], $start->[1] + 1];
	}
	if (grep { $symbol eq $_ } ('|', 'F', '7')) {
		push @out, [$start->[0] + 1, $start->[1]];
	}
	if (grep { $symbol eq $_ } ('-', 'J', '7')) {
		push @out, [$start->[0], $start->[1] - 1];
	}

	return @out;
}

my @grid = ();
my $start;
while (<>) {
	next if (/^$/);
	if (/S/) {
		$start = [$. - 1, $-[0]];
	}
	my @symbols = split '';
	my $col = 0;
	my @row = map { my @coords = sym_to_cors [$. - 1, $col++], $_; \@coords } @symbols;
	push @grid, \@row;
}

sub is_out_of_bounds {
	my $pipe = shift;
	return (
		$pipe->[0] < 0 ||
		$pipe->[1] < 0 ||
		$pipe->[0] >= scalar @grid ||
		$pipe->[1] >= scalar @{$grid[0]}
	);
}

sub find_home {
	my ($src, $cur, $dist) = @_;
	return -1 if (is_out_of_bounds $cur);

	my $pipe = $grid[$cur->[0]]->[$cur->[1]];
	return $dist + 1 if ($pipe->[0] eq 'S');

	my @filtered_pipe = grep { $_->[0] != $src->[0] || $_->[1] != $src->[1] } @$pipe;
	if (@filtered_pipe == 0 || @filtered_pipe == 2) {
		return -1;
	}

	return find_home ($cur, $filtered_pipe[0], $dist + 1);
}

my $dist;
for my $dir ([-1, 0], [0, 1], [1, 0], [0, -1]) {
	$dist = find_home $start, [$start->[0] + $dir->[0], $start->[1] + $dir->[1]], 0;
	last if ($dist > 0);
}
say int(($dist + 1) / 2);

