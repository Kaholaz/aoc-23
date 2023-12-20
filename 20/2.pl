use warnings;
use strict;
use v5.34;
use List::Util qw(reduce any all first);

my %flips = ();
my %conj = ();
my $broadcaster = ();

while (<>) {
	next if not /(.+) -> (.+)/;

	my $targets = [split ', ', $2];
	my $mod = $1;
	if ($mod =~ /broadcaster/) {
		$broadcaster = $targets;
	}
	elsif ($mod =~ /%(.+)/) {
		$flips{$1} = {
			'state' => 0,
			'next' => $targets,
		}
	} elsif ($mod =~ /&(.+)/) {
		$conj{$1} = {
			'next' => $targets,
		};
	}
}

for my $key (keys %conj) {
	my @flipsrc = grep { any { $_ eq $key } @{$flips{$_}->{'next'}} } keys %flips;
	my @conjsrc = grep { any { $_ eq $key } @{$conj{$_}->{'next'}} } keys %conj;
	$conj{$key}->{'state'} = { map { $_ => 0 } @flipsrc, @conjsrc };
}

# This makes no sense, but the each flipflop connected to the broadcast is the
# start of a conj cycle. Each conj must be high for the output to activate.
my %conj_activations = ();
for my $flipflop (@$broadcaster) {
	my @flipflop_chain = ($flipflop);

	my $conj = first { exists $conj{$_} } @{$flips{$flipflop}->{'next'}};
	die "No conj :(" if not defined($conj);
	$conj_activations{$conj} = 0;
}

my $button_presses = 0;
while (any { not $_ } values %conj_activations )  {
	my @queue = (['button', 'broadcaster', 0]);
	++$button_presses;
	while (@queue) {
		my ($src, $target, $signal) = @{shift @queue};
		if ($target eq 'broadcaster') {
			push @queue, map { [$target, $_, 0] } @{$broadcaster};
		}

		if (exists $flips{$target}) {
			next if $signal;

			my $state = not $flips{$target}->{'state'};
			$flips{$target}->{'state'} = $state;
			push @queue, map { [$target, $_, $state] } @{$flips{$target}->{'next'}};
		}

		if (exists $conj{$target}) {
			$conj{$target}->{'state'}->{$src} = $signal;
			my $to_send = not all { $_ } values %{$conj{$target}->{'state'}};
			push @queue, map { [$target, $_, $to_send] } @{$conj{$target}->{'next'}};

			# Conj activation!
			$conj_activations{$target} = $button_presses if (
				(not $to_send) &&
				(exists $conj_activations{$target}) &&
				(not $conj_activations{$target})
			);
		}
	}
}

sub gcd {
    ($a, $b) = ($b, $a % $b) until $b == 0;
    return $a;
}
say reduce { $a * $b / gcd } values %conj_activations;
