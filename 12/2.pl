use warnings;
use strict;
use v5.34;

sub find_solutions {
	my ($line, $counts) = @_;

	my @counts = @$counts;
	if (not @counts) {
		return not $line =~ m/#/;
	}

	my $solutions = 0;
	my $count = shift @counts;

	# Assume the first character is '#' and be greedy.
	if ($line =~ m/^[?#]{$count}(?:\.|\?|$)/) {
		$solutions += cached_find_solutions(
			$line =~ s/^[?#]{$count}\??\.*//r,
			\@counts
		);
	}

	# Assume the first character is '.'
	if ($line =~ s/^\?\.*//) {
		$solutions += cached_find_solutions($line, $counts);
	}

	return $solutions;
}

my %cache = ();
sub cached_find_solutions {
	my ($line, $counts) = @_;

	$line =~ s/^\.+//;
	my $format = sprintf "$line %s", join ',', @$counts;
	if (exists $cache{$format}) {
		return $cache{$format};
	}

	my $result = find_solutions $line, $counts;
	$cache{$format} = $result;
	return $result;
}

my $solutions = 0;
while (<>) {
	my ($gears, $counts) = split " ";
	next if (not $counts);

	say "$./1000";
	my @counts = /\d+/g;
	@counts = (@counts,@counts,@counts,@counts,@counts);
	$solutions += cached_find_solutions(
		"$gears?$gears?$gears?$gears?$gears", \@counts);
}
say $solutions;

