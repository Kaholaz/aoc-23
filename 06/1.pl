use strict;
use warnings;
use v5.34;


my @durations = <> =~ /\d+/g;
my @distances = <> =~ /\d+/g;

my $score = 1;
for my $i (0..scalar @durations - 1) {
	my $duration = $durations[$i];
	my $distance = $distances[$i];

	my $ways_to_beat = 0;
	for my $hold (1..$duration) {
		my $remaining = $duration - $hold;
		$ways_to_beat += 1 if ($remaining * $hold > $distance);
	}

	$score *= $ways_to_beat;
}

say $score;

