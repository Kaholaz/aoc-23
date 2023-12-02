use List::Util qw(sum);
use v5.34;
use strict;
use warnings;

my $num_regexp = qr/([0-9]|one|two|three|four|five|six|seven|eight|nine)/;
my %numbers = (
	'one' => 1,
	'two' => 2,
	'three' => 3,
	'four' => 4,
	'five' => 5,
	'six' => 6,
	'seven' => 7,
	'eight' => 8,
	'nine' => 9,
);

my @result = ();
while (<>) {
	next if ($_ eq "\n");

	$_ =~ $num_regexp;
	my $first = $numbers{$1} // $1;
	$_ =~ /.*$num_regexp/;
	my $last = $numbers{$1} // $1;

	push @result, $first . $last;
}

say sum(@result);
