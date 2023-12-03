use strict;
use warnings;
use v5.34;
use List::Util qw(any sum);

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
while (my ($r, $l) = each @input) {
	my $current_num = [];
	while (my ($c, $value) = each @$l) {
		if (not $value =~ /\d/) {
			push @nums, $current_num if (scalar @$current_num);
			$current_num = [];
			next;
		}

		if (scalar @$current_num) {
			$current_num->[1] = $c;
		} else {
			$current_num = [$c, $c, $r];
		}
	}
	push @nums, $current_num if (scalar @$current_num);
}

# A list of adjacent squares given (start, stop, row).
sub adj {
	my ($start, $stop, $row) = @_;
	my @top =
		map {[$_, $row - 1]}
		grep {$_ <= $max_col}
		grep {$_ >= 0}
		grep {$row > 0}
		($start - 1..$stop + 1);
	my @sides =
		map {[$_, $row]}
		grep {$_ <= $max_col}
		grep {$_ >= 0}
		($start - 1, $stop + 1);
	my @bot =
		map {[$_, $row + 1]}
		grep {$_ <= $max_col}
		grep {$_ >= 0}
		grep {$row < $max_row}
		($start - 1..$stop + 1);
	return (@top, @sides, @bot);
}

my @part_num_pos =
	grep {
		any {$input[$_->[1]]->[$_->[0]] =~ /[^\.\d]/} adj @$_
	} @nums;

sub part_num {
	my ($start, $end, $row) = @_;
	my $out = '';
	for my $col (($start..$end)) {
		$out .= $input[$row]->[$col];
	}
	return $out;
}

say sum map {part_num @$_} @part_num_pos;
