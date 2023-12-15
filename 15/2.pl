use warnings;
use strict;
use v5.34;
use List::Util qw(reduce sum first);

my @input =  grep { $_ } map { chomp; split ',' } <>;

sub hash {
	$_ = shift if @_;
	my @letters = split '';
	return reduce { (($a + $b) * 17) % 256 } 0, map { ord $_ } @letters;
}

my @boxes = map { [] } (1..256);

for (@input) {
	/(.+)(=|-)(\d?)/;
	my $box_index = hash $1;
	my $box = $boxes[$box_index];

	my $cur_index = first { $box->[$_]->[0] eq $1 } (0..(scalar @$box) - 1);
	if (defined $cur_index) {
		splice @$box, $cur_index, 1;
	} else {
		$cur_index = @$box;
	}

	if ($2 eq '=') {
		splice @$box, $cur_index, 0, [$1, $3];
	}
}

my $result = 0;
for (1..256) {
	my $box = $boxes[$_ - 1];
	next if not @$box;

	my $slot = 0;
	$result += $_ * sum map { ++$slot * $_->[1] } @$box;
}

say $result;
