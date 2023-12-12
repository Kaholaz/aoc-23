use warnings;
use strict;
use v5.34;
use List::Util qw(all zip);

sub find_solutions {
	my ($line, $counts) = @_;

	my @gears = $line =~ m"#+"g;
	if (not $line =~ /\?/) {
		return 0 if (scalar @gears != scalar @$counts);
		return all { length $_->[0] == $_->[1] } zip \@gears, $counts;
	}

	my $extra_gear = $line =~ s/\?/#/r; # First '?' is actually '#'.
	my $less_gear = $line =~ s/\?/\./r; # First '?' is actually '.'.
	return
		find_solutions($extra_gear, $counts) +
		find_solutions($less_gear, $counts);
}

my $solutions = 0;
while (<>) {
	my ($gears, $counts) = split " ";
	next if (not $counts);

	say "$./1000";
	my @counts = /\d+/g;
	$solutions += find_solutions $gears, \@counts;
}
say $solutions;

