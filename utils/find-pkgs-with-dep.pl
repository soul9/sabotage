#!/usr/bin/env perl
use strict;
use warnings;

sub has_dep {
	my ($pkgf, $search) = @_;
	my @pkg = `cat $pkgf`;
	my $in_deps = 0;
	for(@pkg) {
		chomp;
		if(/^\[deps\]/) {
			$in_deps = 1;
		} elsif (/^\[/) {
			$in_deps = 0;
		} elsif($in_deps) {
			return 1 if($_ eq $search);
		}
	}
	return 0;
}

my $pkgdir = $ENV{"R"} or die("environment vars not set. be sure to source config.");
my $pkg_searched = $ARGV[0] or die ("need package to search for as argv1");

$pkgdir .= "/src/pkg/";
my @files = glob($pkgdir . "*");
for(@files) {
	my $pkg = $_;
	print $_ , "\n"	if(has_dep($pkg, $pkg_searched));
}

