use warnings;
use strict;
use v5.34;
use List::Util qw(zip);

my %sym_to_num = (
	'T' => 10,
	'J' => 1, # Joker ;)
	'Q' => 12,
	'K' => 13,
	'A' => 14,
);

sub hand_to_numbers {
	my $hand = shift;
	return map { $sym_to_num{$_} // $_ } split //, $hand;
}

sub counter {
	my %counter = ();
	for (@_) {
		$counter{$_} = ($counter{$_} // 0) + 1;
	}

	my $jokers = $counter{1} // 0;
	$counter{1} = 0;

	return $jokers, %counter;
}

sub compare_hands {
	my @scores;
	for my $hand ($a, $b) {
		my ($jokers, %counter) = counter hand_to_numbers $hand;
		my @hand_scores = sort { $b <=> $a } values %counter;
		$hand_scores[0] += $jokers;
		push @scores, \@hand_scores;
	}

	for (zip @scores) {
		next if ($_->[0] == $_->[1]);
		return $_->[0] <=> $_->[1];
	}

	my @a_hand = hand_to_numbers $a;
	my @b_hand = hand_to_numbers $b;
	for (0..scalar @a_hand - 1) {
		next if ($a_hand[$_] == $b_hand[$_]);
		return $a_hand[$_] <=> $b_hand[$_];
	}
}

my %hands = ();
while (<>) {
	next if not (/(.+) (\d+)/);
	$hands{$1} = $2;
}

my $result = 0;
my @sorted_hands = sort compare_hands (keys %hands);
while (my ($i, $hand) = each @sorted_hands) {
	$result += $hands{$hand} * ($i + 1);
}

say $result;

