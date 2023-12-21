use warnings;
use strict;
use v5.34;

my @inp = map { chomp; [ split '' ] } <>;
my @coords = map { my $row = $_; map { [$row, $_] } (0..$#{$inp[0]}) } (0..$#inp);
my @start = grep { $inp[$_->[0]]->[$_->[1]] eq 'S' } @coords;

my @dirs = (
	[0,1],
	[1,0],
	[0,-1],
	[-1,0],
);

say "Finding filled square sizes...";
my $steps = 26501365;
my $size = $#inp;
my $halfway = ($size) / 2;
my ($odd, $even) = find_all([$halfway, $halfway]);
my $radius = ($steps - $halfway) / scalar @inp;

my $top_parity = ($halfway) % 2;
my $center_parity = $radius % 2 ? not $top_parity : $top_parity;
my $odd_squares = $center_parity;
my $even_squares = not $center_parity;

my $squares = 0;
for ((1 - not $center_parity)..($radius - not $center_parity)) {
	if ($_ % 2) {
		$odd_squares += $squares;
	} else {
		$even_squares += $squares;
	}
	$squares += 4;
}

my $inside_whole = $odd_squares * $odd + $even_squares * $even;

say "Finding small sub-square sizes...";
my $small_se = find_some([0    ,     0], $halfway - 1);
my $small_sw = find_some([0    , $size], $halfway - 1);
my $small_ne = find_some([$size,     0], $halfway - 1);
my $small_nw = find_some([$size, $size], $halfway - 1);

say "Finding big sub-square sizes...";
my $big_se = find_some([    0,     0], $size + $halfway);
my $big_sw = find_some([    0, $size], $size + $halfway);
my $big_ne = find_some([$size,     0], $size + $halfway);
my $big_nw = find_some([$size, $size], $size + $halfway);

say "Finding vertex sub-square sizes...";
my $big_s = find_some([       0, $halfway], $size);
my $big_e = find_some([$halfway,        0], $size);
my $big_n = find_some([   $size, $halfway], $size);
my $big_w = find_some([$halfway,    $size], $size);

say "Result:";
say $inside_whole +
	$big_n + ($radius - 1) * $big_ne + $radius * $small_ne +
	$big_e + ($radius - 1) * $big_se + $radius * $small_se +
	$big_s + ($radius - 1) * $big_sw + $radius * $small_sw +
	$big_w + ($radius - 1) * $big_nw + $radius * $small_nw;

sub find_all {
	my $start = shift;
	my %map = (join(',', @{$start}) => 1);
	my @squares = ();
	while (1) {
		last if @squares >= 4 && $squares[-1] == $squares[-3] && $squares[-2] == $squares[-4];
	 	my %next_map = ();
		for my $loc (keys %map) {
			$loc = [ split ',', $loc ];
			for my $dir (@dirs) {
				my $new_loc = [$loc->[0] + $dir->[0], $loc->[1] + $dir->[1]];
				next if out_of_bounds($new_loc);
				next if $inp[$new_loc->[0]]->[$new_loc->[1]] eq '#';
				$next_map{join ',', @$new_loc} = 1;
			}
		}
		%map = %next_map;
		push @squares, scalar keys %map;
	}

	if (@squares % 2) {
		return $squares[-1], $squares[-2];
	} else {
		return $squares[-2], $squares[-1];
	}
}

sub find_some {
	my ($start, $steps) = @_;
	my %map = (join(',', @{$start}) => 1);
	for (1..$steps) {
	 	my %next_map = ();
		for my $loc (keys %map) {
			$loc = [ split ',', $loc ];
			for my $dir (@dirs) {
				my $new_loc = [$loc->[0] + $dir->[0], $loc->[1] + $dir->[1]];
				next if out_of_bounds($new_loc);
				next if $inp[$new_loc->[0]]->[$new_loc->[1]] eq '#';
				$next_map{join ',', @$new_loc} = 1;
			}
		}
		%map = %next_map;
	}

	return scalar keys %map;
}

sub out_of_bounds {
	my $pos = shift;
	return (
		$pos->[0] < 0 || $pos->[0] > $#inp ||
		$pos->[1] < 0 || $pos->[1] > $#{$inp[0]}
	);
}
