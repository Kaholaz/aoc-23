use warnings;
use strict;
use v5.34;

my @grid = ();
my @rows_to_explode = ();
while (<>) {
	next if ($_ eq "\n");

	chomp;
	my @row = split "";
	push @rows_to_explode, $. - 1 if (not m"#");
	push @grid, \@row;
}

my @cols_to_explode = grep
	{ my $col = $_; all { $_->[$col] eq '.' } @grid }
	(0..scalar @{$grid[0]} - 1);

my @galaxies = ();
my $ef = 1000000 - 1;
my $row_offset = 0;
for my $row (0..scalar @grid - 1) {
	$row_offset += $ef if (grep { $_ == $row } @rows_to_explode);

	my $col_offset = 0;
	for my $col (0..scalar @{$grid[0]} -1 ) {
		$col_offset += $ef if (grep { $_ == $col } @cols_to_explode);

		next if ($grid[$row]->[$col] eq '.');
		push @galaxies, [$row + $row_offset, $col + $col_offset];
	}
}

my $result = 0;
for my $i (0..scalar @galaxies - 2) {
	for my $j ($i + 1..scalar @galaxies - 1) {
		$result +=
			abs ($galaxies[$i]->[0] - $galaxies[$j]->[0]) +
			abs ($galaxies[$i]->[1] - $galaxies[$j]->[1]);
	}
}
say $result;

