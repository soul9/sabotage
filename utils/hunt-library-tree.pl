#!/usr/bin/env perl
use strict;
use warnings;

my %libs;

sub getlibs {
	my $search = shift;
	my $elf = shift;
#	warn $elf;
	my @res = `readelf -a $elf | grep NEEDED`;
	for my $y(@res) {
		chomp $y;
		if($y =~ /\[(lib[\w._-]+\.so.*)\]/) {
			my $x = $1;
			if(!defined $libs{$x}) {
				$libs{$x} = 1;
				$x = "/lib/" . $x if(! -e $x);
				getlibs($search, $x);
			}
		}
	}
	@res = `readelf -a $elf | grep $search`;
	for(@res) {
		print "$elf : $_";
	}
}

die "syntax: $0 searchterm elf" unless defined $ARGV[1];
getlibs($ARGV[0], $ARGV[1]);
for (keys %libs) {
	print $_, "\n";
}
