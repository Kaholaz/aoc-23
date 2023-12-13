use warnings;
use strict;
use v5.34;
use List::Util qw(zip);

my @input = ();
my $picture = [];
while (<>) {
	if ($_ eq "\n") {
		next if not @$picture;
		push @input, $picture;
		$picture = [];
	} else {
		chomp;
		push @$picture, $_;
	}
}

sub reflection_line {
	my $start = 0;
	for (my $end = int(scalar @_/2) * 2 - 1; $end > $start; $end -= 2) {
		my $diffs = 0;
		for my $offset (0..int($end/2)) {
			my @first = split '', $_[$start + $offset];
			my @second = split '', $_[$end - $offset];
			my $diff = grep { $_->[0] ne $_->[1] } zip \@first, \@second;
			$diffs += $diff;
			last if $diffs > 1;
		}
		return ($end + $start + 1) / 2 if ($diffs == 1);
	}

	my $end = scalar @_ - 1;
	for ($start = scalar @_ % 2; $start < $end; $start += 2) {
		my $diffs = 0;
		for my $offset (0..int(($end - $start)/2)) {
			my @first = split '', $_[$start + $offset];
			my @second = split '', $_[$end - $offset];
			my $diff = grep { $_->[0] ne $_->[1] } zip \@first, \@second;
			$diffs += $diff;
			last if $diffs > 1;
		}
		return ($end + $start + 1) / 2 if ($diffs == 1);
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

