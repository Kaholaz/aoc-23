use warnings;
use strict;
use v5.34;
use List::Util qw(reduce all);
use Data::Dumper;

my %workflows;
while (<>) {
	last if (/^$/);
	/^(.+)\{(.+)\}/;
	my $rules = [split ',', $2];
	$workflows{$1} = $rules;
}

my $part = {
	'x' => [1,4000],
	'm' => [1,4000],
	'a' => [1,4000],
	's' => [1,4000],
};

my $stack_counter = 0;
sub apply_rules {
	my ($part, $w) = @_;
	$stack_counter++;
	my $stack_id = $stack_counter;


	my @out = ();
	OUTER: while (1) {
		return @out, $part if ($w eq 'A');
		return @out if ($w eq 'R');

		for (@{$workflows{$w}}) {
			if (/(\w)<(\d+):(.+)/) {
				my $parm = $part->{$1};
				next if ($parm->[0] >= $2);
				if ($parm->[1] < $2) {
					$w = $3;
					next OUTER;
				}

				my $other = dcopy($part);
				$other->{$1}->[1] = $2 - 1;

				# Need to store these cause $1 and $2 are global (dumb perl...)
				my ($attr, $thres) = ($1, $2);
				push @out, apply_rules($other, $3);
				$part->{$attr}->[0] = $thres;
			} elsif (/(\w)>(\d+):(.+)/) {
				my $parm = $part->{$1};
				next if ($parm->[1] <= $2);
				if ($parm->[0] > $2) {
					$w = $3;
					next OUTER;
	 			}

				my $other = dcopy($part);
				$other->{$1}->[0] = $2 + 1;

				# Need to store these cause $1 and $2 are global (dumb perl...)
				my ($attr, $thres) = ($1, $2);
				push @out, apply_rules($other, $3);
				$part->{$attr}->[1] = $thres;
			} else {
				/(.+)/;
				$w = $1;
				next OUTER;
			}
		}

	}
	return @out;
}

my @parts = apply_rules($part, 'in');

# Turnes out this check was not neccessary (the input contains no overlaps)
# I added it when i was trying to get the correct result.
my @overlaps;
for my $i (0..$#parts - 1) {
	for my $j ($i+1..$#parts) {
		my $part_a = $parts[$i];
		my $part_b = $parts[$j];

		my $overlap = 1;
		for my $k (keys %$part_a) {
			$overlap = 0 if
				$part_a->{$k}->[0] > $part_b->{$k}->[1] ||
				$part_a->{$k}->[1] < $part_b->{$k}->[0];
		}
		next if not $overlap;

		$overlap = {};
		for my $k (keys %$part_a) {
			my @values = sort { $a <=> $b } (
				@{$part_a->{$k}},
				@{$part_b->{$k}},
			);
			$overlap->{$k} = [@values[1,2]];
		}
		push @overlaps, $overlap;
	}
}

my $perms = reduce { $a + $b } map { reduce { $a * (($b->[1] - $b->[0]) + 1) } (1, values(%$_)) } @parts;
my $extra = reduce { $a + $b } 0, map { reduce { $a * (($b->[1] - $b->[0]) + 1) } (1, values(%$_)) } @overlaps;
say $perms - $extra;

sub dcopy {
	my $in = shift;
	my $out = {};
	while (my ($k, $v) = each %$in) {
		$out->{$k} = [ @$v ];
	}

	return $out;
}
