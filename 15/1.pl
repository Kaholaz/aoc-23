use warnings;
use strict;
use v5.34;
use List::Util qw(reduce sum);

my @elements =  grep { $_ } map { chomp; split ',' } <>;

sub hash {
	my @letters = split '';
	return reduce { (($a + $b) * 17) % 256 } 0, map { ord $_ } @letters;
}

say sum map { hash } @elements;
