use warnings;
use strict;
use v5.34;
use List::Util qw(reduce);

my %workflows;
while (<>) {
	last if (/^$/);
	/^(.+)\{(.+)\}/;
	my $rules = [split ',', $2];
	$workflows{$1} = $rules;
}

my @parts;
while (<>) {
	last if (/^$/);
	my $part = {};

	/x=(\d+)/;
	$part->{'x'} = $1;
	/m=(\d+)/;
	$part->{'m'} = $1;
	/a=(\d+)/;
	$part->{'a'} = $1;
	/s=(\d+)/;
	$part->{'s'} = $1;

	push @parts, $part;
}

sub apply_rules {
	my $part = shift;
	my $w = 'in';

	OUTER: while (1) {
		return 1 if $w eq 'A';
		return 0 if $w eq 'R';

		for (@{$workflows{$w}}) {
			if (/(\w)<(\d+):(.+)/) {
				next if ($part->{$1} >= $2);
				$w = $3;
				next OUTER;
			} elsif (/(\w)>(\d+):(.+)/) {
				next if ($part->{$1} <= $2);
				$w = $3;
				next OUTER;
			} else {
				/(.+)/;
				$w = $1;
				next OUTER;
			}
		}
	}
}

say reduce { $a + $b } map { values %$_ } grep { apply_rules $_ } @parts;
