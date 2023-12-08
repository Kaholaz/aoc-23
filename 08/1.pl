use warnings;
use strict;
use v5.34;

my @dirs = map { tr/LR/01/r } <> =~ /./g;
my %map = map { /([A-Z]+) = \(([A-Z]+), ([A-Z]+)\)/ ? ($1 => [$2, $3]) : () } <>;

my ($cur, $step) = ('AAA', 0);
$cur = $map{$cur}->[$dirs[$step++ % @dirs]] until $cur eq 'ZZZ';
say $step;

