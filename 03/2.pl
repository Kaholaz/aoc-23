use strict;
use warnings;
use v5.34;
use List::Util qw(any sum reduce);

my @input = ();
while (<>) {
	next if (not /.+/);
	my @line = split //, $&;
	push @input, \@line;
}
my $max_row = scalar @input - 1;
my $max_col = scalar @{$input[0]} - 1;

# Find each number and make a list of (start, stop, row)
my @nums = ();
while (my ($r, $line) = each @input) {
	my $line_str = join '', @$line;
	while ($line_str =~ /\d+/g) {
		push @nums, [$-[0], $+[0] - 1, $r];
	}
}

# A list of adjacent squares given (start, stop, row).
sub adj {
	my ($start, $stop, $row) = @_;
	my @row =
		grep {$_ <= $max_col}
		grep {$_ >= 0}
		($start - 1..$stop + 1);

	# The top row has no row above it, same for the bottom row.
	my @top = $row == 0 ? () : map {[$_, $row - 1]} @row;
	my @bot = $row == $max_row ? () : map {[$_, $row + 1]} @row;
	my @sides =
		map {[$_, $row]}
		grep {$_ <= $max_col}
		grep {$_ >= 0}
		($start - 1, $stop + 1);
	return (@top, @sides, @bot);
}

my @part_num_pos =
	grep {
		any {$input[$_->[1]]->[$_->[0]] =~ /[^\.\d]/} adj @$_
	} @nums;

sub part_num {
	my ($start, $end, $row) = @_;
	return join '', map {$input[$row]->[$_]} ($start..$end);
}

my %adj_gears = ();
for (@part_num_pos) {
	my $part_num = part_num @$_;
	for (adj @$_) {
		my $symbol = $input[$_->[1]]->[$_->[0]];
		if ($symbol =~ /\*/) {
			$adj_gears{$_->[1]} //= {};
			$adj_gears{$_->[1]}->{$_->[0]} //= [];
			push @{$adj_gears{$_->[1]}->{$_->[0]}}, $part_num;
		}
	}
}

my $gears_product = reduce {$a + $b->[0] * $b->[1]} 0,
	grep { scalar @$_ == 2 }
	map { values %$_ } values %adj_gears; # Flatten

say sum $gears_product;
