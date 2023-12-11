use warnings;
use strict;
use v5.34;
use List::Util qw(any);

sub sym_to_cors {
	my ($start, $symbol) = @_;
	my @out = ();

	if ($symbol eq 'S') {
		push @out, 'S';
	}

	if (any { $symbol eq $_ } ('|', 'L', 'J')) {
		push @out, [$start->[0] - 1, $start->[1]];
	}
	if (any { $symbol eq $_ } ('-', 'L', 'F')) {
		push @out, [$start->[0], $start->[1] + 1];
	}
	if (any { $symbol eq $_ } ('|', 'F', '7')) {
		push @out, [$start->[0] + 1, $start->[1]];
	}
	if (any { $symbol eq $_ } ('-', 'J', '7')) {
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
	chomp;
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

my @loop = ();
my ($N, $E, $S, $W) = ([-1, 0], [0, 1], [1, 0], [0, -1]);
OUTER: for my $dir ($N, $S, $E, $W) {
	my ($src, $cur) = ($start, [$start->[0] + $dir->[0], $start->[1] + $dir->[1]]);
	@loop = ();

	while (1) {
		push @loop, $src;
		last if (is_out_of_bounds $cur);

		my $pipe = $grid[$cur->[0]]->[$cur->[1]];
		last if (scalar @$pipe == 0);
		last OUTER if ($pipe->[0] eq 'S');

		my @filtered_pipe = grep { $_->[0] != $src->[0] || $_->[1] != $src->[1] } @$pipe;
		last if (@filtered_pipe == 0 || @filtered_pipe == 2);

		($src, $cur) = ($cur, $filtered_pipe[0]);
	}
}

my @seen = ();
my @outside = ();
my @queue = ([$S, [0,0]]);
my $target = [4,15];
while (@queue) {
	say scalar @queue;
	my $q = shift @queue;
	my ($src, $cur) = @$q;

	next if (is_out_of_bounds $cur);
	next if any { $_->[0] == $cur->[0] && $_->[1] == $cur->[1] } @seen;
	push @seen, $cur;

	my $is_pipe = 0;
	my $index = 0;
	for (@loop) {
		if ($_->[0] == $cur->[0] && $_->[1] == $cur->[1]) {
			$is_pipe = 1;
			last;
		}
		++$index;
	}

	if ($is_pipe) {
		my $inv_src = [$src->[0] * -1, $src->[1] * -1];

		my @difs = ();
		my $prev = $loop[($index  - 1) % scalar @loop];
		push @difs, [$prev->[0] - $cur->[0], $prev->[1] - $cur->[1]];
		my $next = $loop[($index  + 1) % scalar @loop];
		push @difs, [$next->[0] - $cur->[0], $next->[1] - $cur->[1]];

		if ($difs[0]->[0] != $src->[0] && $difs[0]->[1] != $src->[1]) {
			push @queue, [$src, $prev];
		} elsif ($difs[0]->[0] == $src->[0] && $difs[0]->[1] == $src->[1]) {
			push @queue, [$difs[1], $prev];
			push @queue, [[-$difs[1]->[0], -$difs[1]->[1]], [$cur->[0] - $difs[1]->[0], $cur->[1] - $difs[1]->[1]]];
		} else {
			push @queue, [[-$difs[1]->[0], -$difs[1]->[1]], $prev];
		}

		if ($difs[1]->[0] != $src->[0] && $difs[1]->[1] != $src->[1]) {
			push @queue, [$src, $next];
		} elsif ($difs[1]->[0] == $src->[0] && $difs[1]->[1] == $src->[1]) {
			push @queue, [$difs[0], $next];
			push @queue, [[-$difs[0]->[0], -$difs[0]->[1]], [$cur->[0] - $difs[0]->[0], $cur->[1] - $difs[0]->[1]]];
		} else {
			push @queue, [[-$difs[0]->[0], -$difs[0]->[1]], $next];
		}
	} else {
		push @outside, $cur;
		for my $dir ($N, $S, $E, $W) {
			push @queue, [$dir, [$cur->[0] + $dir->[0], $cur->[1] + $dir->[1]]];
		}
	}
}

my $inside = 0;
for my $row (0..scalar @grid - 1) {
	for my $col (0..scalar @{$grid[0]} - 1) {
		if (any { $_->[0] == $row && $_->[1] == $col } @outside) {
			print "O";
		} elsif (any { $_->[0] == $row && $_->[1] == $col } @loop) {
			print ".";
		} else {
			print "I";
			++$inside;
		}
	}
	print "\n";
}
say $inside;

