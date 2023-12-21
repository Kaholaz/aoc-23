use warnings;
use strict;
use v5.34;
use Data::Dumper;

my @inp = map { chomp; [ split '' ] } <>;
my @start = grep { $inp[$_->[0]]->[$_->[1]] eq 'S' } map { map { [$_, $_] } (0..$#{$inp[0]}) } (0..$#inp);
my @dirs = (
	[0,1],
	[1,0],
	[0,-1],
	[-1,0],
);

my %map = (
	(join ',', @{$start[0]}) => 1,
);

for (1..64) {
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

say scalar keys %map;

sub out_of_bounds {
	my $pos = shift;
	return (
		$pos->[0] < 0 || $pos->[0] > $#inp ||
		$pos->[1] < 0 || $pos->[1] > $#{$inp[0]}
	);
}
