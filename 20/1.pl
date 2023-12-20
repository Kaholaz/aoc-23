use warnings;
use strict;
use v5.34;
use List::Util qw(reduce any all);

my %flips = ();
my %conj = ();
my $broadcaster = ();

while (<>) {
	next if not /(.+) -> (.+)/;

	my $targets = [split ', ', $2];
	my $mod = $1;
	if ($mod =~ /broadcaster/) {
		$broadcaster = $targets;
	} elsif ($mod =~ /%(.+)/) {
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

my $low = 0;
my $high = 0;
for (1..1000) {
	my @queue = (['button', 'broadcaster', 0]);
	while (@queue) {
		my ($src, $target, $signal) = @{shift @queue};
		$signal ? ++$high : ++$low;

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
		}
	}
}

say $low * $high;
