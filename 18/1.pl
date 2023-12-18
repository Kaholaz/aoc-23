use warnings;
use strict;
use v5.34;
use List::Util qw(reduce);

my @inp = map { /([RUDL]) (\d+)/; [$1, $2] } grep {$_} map {chomp; $_} <>;

my %dirs = (
	'R' => [0,1],
	'D' => [1,0],
	'L' => [0,-1],
	'U' => [-1,0],
);

my $pos = [0,0];
my %dug = ('0,0' => 1);
for (@inp) {
	my ($dir_str, $len) = @$_;
	my $dir = $dirs{$dir_str};
	for my $dist (1..$len) {
		$pos = [$pos->[0] + $dir->[0], $pos->[1] + $dir->[1]];
		$dug{join ',', @$pos} = 1;
	}
}

my $start = reduce { [$a->[0] + $b->[0], $a->[1] + $b->[1]] } map { $dirs{$_->[0]} } @inp[0,1];
my @queue = ($start);
while (@queue) {
	my $cur = shift @queue;
	next if exists $dug{join ',', @$cur};
	$dug{join ',', @$cur} = 1;

	for (values %dirs) {
		push @queue, [$cur->[0] + $_->[0], $cur->[1] + $_->[1]];
	}
}

say scalar keys %dug;
