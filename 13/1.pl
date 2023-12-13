use warnings;
use strict;
use v5.34;
use List::Util qw(reduce all);

my $input =
	reduce { $b ? push @{$a->[-1]}, $b : push @$a, []; $a } [[]],
	map { chomp; $_ } <>;
my @input = grep { @$_ } @$input;

sub reflection_line {
	my $start = 0;
	for (my $end = int(scalar @_/2) * 2 - 1; $end > $start; $end -= 2) {
		return ($end + $start + 1) / 2 if (
			all { $_[$start + $_] eq $_[$end - $_] }
			(0..int(($end - $start)/2))
		);
	}

	my $end = scalar @_ - 1;
	for ($start = scalar @_ % 2; $start < $end; $start += 2) {
		return ($end + $start + 1) / 2 if (
			all { $_[$start + $_] eq $_[$end - $_] }
			(0..int(($end - $start)/2))
		);
	}

	return -1;
}

sub rotate {
	my $height = length $_[0];
	my @chars = map { split '' } @_;
	my @out = ();
	for my $row (0..$height - 1) {
		my $i = 0;
		push @out, join '', grep { $i++ % $height == $row } @chars;
	}
	return @out;
}

my $result = 0;
for my $i (0..scalar @input - 1) {
	my $picture = $input[$i];
	my $reflection = 100 * reflection_line @$picture;
	if ($reflection < 0) {
		$reflection = reflection_line rotate @$picture;
	}
	$result += $reflection;
}

say $result;

