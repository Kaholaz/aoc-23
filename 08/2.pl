use warnings;
use strict;
use v5.34;
use List::Util qw(reduce);

my @dirs = map { tr/LR/01/r } <> =~ /./g;
my %map = map { /([A-Z]+) = \(([A-Z]+), ([A-Z]+)\)/ ? ($1 => [$2, $3]) : () } <>;

my @cycles = map {
    my $step = 0;
    $_ = $map{$_}->[$dirs[$step++ % @dirs]] until $_ =~ /Z$/;
    $step;
} grep { /A$/ } keys %map;

sub gcd {
    ($a, $b) = ($b, $a % $b) until $b == 0;
    return $a;
}

say reduce { $a * $b / gcd } @cycles;

