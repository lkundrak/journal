#!/usr/bin/env perl

# $Id$

use strict;
use warnings;

use XML::RSS;

my $base = 'http://ovecka.be/~lkundrak/blog/';
my $rss = new XML::RSS (version => '2.0');

$rss->channel(
	title		=> "lkundrak's Journal",
	link		=> 'http://skosi.org/~lkundrak/',
	language	=> 'en',
	description	=> 'Personal web log of lkundrak',
	copyright	=> 'Copyright (C) 2007 Lubomir Rintel',
#	pubDate		=> 'Thu, 23 Aug 1999 07:00:00 GMT',
#	lastBuildDate	=> 'Thu, 23 Aug 1999 07:00:00 GMT',
	managingEditor	=> 'lkundrak@redhat.com',
	webMaster	=> 'lkundrak@redhat.com',
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

	$rss->add_item (
		title		=> $title,
		permaLink	=> $base.$html,
		description	=> $desc,
	);

	close (BLOG);
}

print $rss->as_string;
