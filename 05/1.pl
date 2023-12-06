use strict;
use warnings;
use v5.34;
use List::Util qw(min zip);

sub replace {
	my ($dst, $src, $range, $default, $num) = @_;
	return $default if ($num < $src || $src + $range <= $num);
	return $num - $src + $dst;
}

my $first_line = <>;
my @new_seeds = $first_line =~ /\d+/g;
my @seeds = ();
while (<>) {
	if (/map:/) { @seeds = @new_seeds; next; }
	elsif (not /(\d+) (\d+) (\d+)/) { next; }
	@new_seeds = map { replace $1, $2, $3, @$_ } zip (\@new_seeds, \@seeds);
}
say min @new_seeds;

