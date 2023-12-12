use warnings;
use strict;
use v5.34;
use List::Util qw(all);

my @grid = ();
while (<>) {
	next if ($_ eq "\n");

	chomp;
	my @row = split "";
	push @grid, \@row if (not m"#");
	push @grid, \@row;
}

my @cols_to_explode = grep
	{ my $col = $_; all { $_->[$col] eq '.' } @grid }
	(0..scalar @{$grid[0]} - 1);

for my $col (@cols_to_explode) {
	for my $row (0..scalar @grid - 1) {
		splice @{$grid[$row]}, $col, 0, '.';
	}
	@cols_to_explode = map { $_ + 1 } @cols_to_explode;
}

my @galaxies = ();
for my $row (0..scalar @grid - 1) {
	for my $col (0..scalar @{$grid[0]} -1 ) {
		next if ($grid[$row]->[$col] eq '.');
		push @galaxies, [$row, $col];
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

