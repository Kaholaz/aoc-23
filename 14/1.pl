use warnings;
use strict;
use v5.34;
use List::Util qw(reduce);

my @grid =  grep { @$_ } map { chomp; [split ''] } <>;

for my $col (0..scalar @{$grid[0]} - 1) {
	my $piv = 0;
	while ($piv < scalar @grid) {
		++$piv until $piv >= scalar @grid || $grid[$piv]->[$col] =~ /\./;

		my $rocks = 0;
		my $counter = $piv;
		while ($counter < @grid && not $grid[$counter]->[$col] =~ m/#/) {
			++$rocks if $grid[$counter]->[$col] =~ s/O/./;
			++$counter;
		}

		for (0..$rocks - 1) {
			$grid[$piv + $_]->[$col] = 'O';
		}
		$piv = $counter;
	}
}

my $points = scalar @grid;
my $result = reduce { $a + $b } map { $points-- * grep {/O/} @$_ } @grid;
say $result;
