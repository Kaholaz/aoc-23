use warnings;
use strict;
use v5.34;
use List::Util qw(reduce);

my @inp = map { m/([^#]+)(\d)\)/; [$2, hex $1] } grep {$_} map {chomp; $_} <>;

my %dirs = (
	'0' => [0,1],
	'1' => [1,0],
	'2' => [0,-1],
	'3' => [-1,0],
);

my $pos = [0,0];
my @corners = ($pos);
for (@inp) {
	my ($dir_str, $len) = @$_;
	my $dir = $dirs{$dir_str};
	$pos = [$pos->[0] + $len * $dir->[0], $pos->[1] + $len * $dir->[1]];
	push @corners, $pos;
}

# Shoelace
my $area = 0;
for (1..$#corners) {
	my ($cur, $prev) = @corners[$_-1, $_];
	$area += ($cur->[1] * $prev->[0] - $cur->[0] * $prev->[1]) / 2;
}
$area = abs $area;

# Pick
my $boundry_points = reduce { $a + $b->[1] } 0, @inp;
say $area + $boundry_points / 2 + 1;
