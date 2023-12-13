use warnings;
use strict;
use v5.34;
use Data::Dumper;

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
		my $correct = 1;
		for my $offset (0..int($end/2)) {
			next if ($_[$start + $offset] eq $_[$end - $offset]);
			$correct = 0;
			last;
		}
		return ($end + 1) / 2 if $correct;
	}

	my $end = scalar @_ - 1;
	for ($start = scalar @_ % 2; $start < $end; $start += 2) {
		my $correct = 1;
		for my $offset (0..int(($end - $start)/2)) {
			next if ($_[$start + $offset] eq $_[$end - $offset]);
			$correct = 0;
			last;
		}
		return ($end + $start + 1) / 2 if $correct;
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

