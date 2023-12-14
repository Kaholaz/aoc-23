# WARNING: THIS IS EXTREMELY UGLY
# Maybe i will clean it ut... maybe i won't :)
use warnings;
use strict;
use v5.34;
use List::Util qw(reduce);

my @grid =  grep { @$_ } map { chomp; [split ''] } <>;

my $period = 0;
my $cycle_start;
my %boards = ();
my $cycles = 1000000000;
for (1..$cycles) {
	say $_ if not $_ % 1000;
	# North
	for my $col (0..scalar @{$grid[0]} - 1) {
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

	# West
	for my $col (0..scalar @grid - 1) {
		for (my $piv = 0; $piv < scalar @{$grid[0]};) {
			for (; $piv < scalar @{$grid[0]} && not $grid[$col]->[$piv] =~ /\./; ++$piv) {}

			my $counter = $piv;
			my $rocks = 0;
			for (;$counter < scalar @{$grid[0]}; ++$counter) {
				last if $grid[$col]->[$counter] =~ m/#/;
				$rocks++ if $grid[$col]->[$counter] =~ s/O/./;
			}

			for my $i ($piv..$piv + $rocks - 1) {
				$grid[$col]->[$i] = 'O';
			}
			$piv = $counter;
		}
	}

	# South
	for my $col (0..scalar @{$grid[0]} - 1) {
		for (my $piv = scalar @grid - 1; $piv > 0;) {
			for (; $piv > 0 && not $grid[$piv]->[$col] =~ /\./; --$piv) {}

			my $counter = $piv;
			my $rocks = 0;
			for (;$counter >= 0; --$counter) {
				last if $grid[$counter]->[$col] =~ m/#/;
				$rocks++ if $grid[$counter]->[$col] =~ s/O/./;
			}

			for my $i (0..$rocks - 1) {
				$grid[$piv - $i]->[$col] = 'O';
			}
			$piv = $counter;
		}
	}

	# East
	for my $col (0..scalar @grid - 1) {
		for (my $piv = scalar @{$grid[0]} - 1; $piv > 0;) {
			for (; $piv > 0 && not $grid[$col]->[$piv] =~ /\./; --$piv) {}

			my $counter = $piv;
			my $rocks = 0;
			for (;$counter >= 0; --$counter) {
				last if $grid[$col]->[$counter] =~ m/#/;
				$rocks++ if $grid[$col]->[$counter] =~ s/O/./;
			}

			for my $i (0..$rocks - 1) {
				$grid[$col]->[$piv - $i] = 'O';
			}
			$piv = $counter;
		}
	}

	my $board = join "\n", map { join '', @$_ } @grid;
	if (exists $boards{$board}) {
		say "Match!";
		$cycle_start = $boards{$board};
		$period = $_ - $cycle_start;
		last;
	} else {
		$boards{$board} = $_;
	}
}

# I am too lazy to store the load of the elements of the cycle..
# just run the cycle a couple more times.
my $remaining_loops = ($cycles - $cycle_start) % $period;
for (1..$remaining_loops) {
	# North
	for my $col (0..scalar @{$grid[0]} - 1) {
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

	# West
	for my $col (0..scalar @grid - 1) {
		for (my $piv = 0; $piv < scalar @{$grid[0]};) {
			for (; $piv < scalar @{$grid[0]} && not $grid[$col]->[$piv] =~ /\./; ++$piv) {}

			my $counter = $piv;
			my $rocks = 0;
			for (;$counter < scalar @{$grid[0]}; ++$counter) {
				last if $grid[$col]->[$counter] =~ m/#/;
				$rocks++ if $grid[$col]->[$counter] =~ s/O/./;
			}

			for my $i ($piv..$piv + $rocks - 1) {
				$grid[$col]->[$i] = 'O';
			}
			$piv = $counter;
		}
	}

	# South
	for my $col (0..scalar @{$grid[0]} - 1) {
		for (my $piv = scalar @grid - 1; $piv > 0;) {
			for (; $piv > 0 && not $grid[$piv]->[$col] =~ /\./; --$piv) {}

			my $counter = $piv;
			my $rocks = 0;
			for (;$counter >= 0; --$counter) {
				last if $grid[$counter]->[$col] =~ m/#/;
				$rocks++ if $grid[$counter]->[$col] =~ s/O/./;
			}

			for my $i (0..$rocks - 1) {
				$grid[$piv - $i]->[$col] = 'O';
			}
			$piv = $counter;
		}
	}

	# East
	for my $col (0..scalar @grid - 1) {
		for (my $piv = scalar @{$grid[0]} - 1; $piv > 0;) {
			for (; $piv > 0 && not $grid[$col]->[$piv] =~ /\./; --$piv) {}

			my $counter = $piv;
			my $rocks = 0;
			for (;$counter >= 0; --$counter) {
				last if $grid[$col]->[$counter] =~ m/#/;
				$rocks++ if $grid[$col]->[$counter] =~ s/O/./;
			}

			for my $i (0..$rocks - 1) {
				$grid[$col]->[$piv - $i] = 'O';
			}
			$piv = $counter;
		}
	}
}

my $points = scalar @grid;
my $result = reduce { $a + $b } map { $points-- * grep {/O/} @$_ } @grid;
say $result;
