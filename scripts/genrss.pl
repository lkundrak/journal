#!/usr/bin/env perl

# $Id$

use strict;
use warnings;

use XML::RSS;
use scripts::wikize;

my $base = 'http://v3.sk/~lkundrak/blog/';
my $rss = new XML::RSS (version => '2.0');

$rss->channel(
	title		=> "lkundrak's Journal",
	link		=> 'http://skosi.org/~lkundrak/',
	language	=> 'en',
	description	=> 'Personal web log of lkundrak',
	copyright	=> 'Copyright (C) 2007,2008 Lubomir Rintel',
#	pubDate		=> 'Thu, 23 Aug 1999 07:00:00 GMT',
#	lastBuildDate	=> 'Thu, 23 Aug 1999 07:00:00 GMT',
	managingEditor	=> 'lkundrak@v3.sk',
	webMaster	=> 'lkundrak@v3.sk',
);

foreach my $file (@ARGV) {
	open (BLOG, '<'.$file);

	my $html = $file;
	$html =~ s/\.cocot$/.html/;

	my $title;
	my $desc;
	my $indesc = 0;

	foreach (<BLOG>) {
		/<!-- rss:title -->(.*)<!-- \/rss:title -->/ and $title = $1;
		/<!-- \/rss:description -->/ and $indesc--;
		$indesc and $desc .= $_;
		/<!-- rss:description -->/ and $indesc++;
	}

	$desc = wikize ($desc);

	$rss->add_item (
		title		=> $title,
		permaLink	=> $base.$html,
		description	=> $desc,
		pubDate		=> `LANG=C scripts/creationdate.sh '\%a, \%d \%b \%Y \%T \%z' $file`
	);

	close (BLOG);
}

print $rss->as_string;
