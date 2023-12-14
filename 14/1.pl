use warnings;
use strict;
use v5.34;
use List::Util qw(reduce all);

my @grid =  grep { @$_ } map { chomp; [split ''] } <>;

for my $col (0..scalar @{$grid[0]} - 1) {
	my $piv = 0;
	for (my $piv = 0; $piv < scalar @grid;) {
		for (; $piv < scalar @grid && not $grid[$piv]->[$col] =~ /\./; ++$piv) {}

		my $counter = $piv;
		my $rocks = 0;
		for (;$counter < scalar @grid; ++$counter) {
			last if $grid[$counter]->[$col] =~ m/#/;
			$rocks++ if $grid[$counter]->[$col] =~ s/O/./;
		}

		for my $i ($piv..$piv + $rocks - 1) {
			$grid[$i]->[$col] = 'O';
		}
		$piv = $counter;
	}
}

my $points = scalar @grid;
my $result = reduce { $a + $b } map { $points-- * grep {/O/} @$_ } @grid;
say $result;
