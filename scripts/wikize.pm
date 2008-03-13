# Preprocess input for wikifying
# $Id$

sub wikize
{
	my $text = join ("", @_);
	$text =~ s/<!-- \S+ -->//g;

	# PurpleWiki stuff

	use PurpleWiki::Config;
	use PurpleWiki::Parser::WikiText;
	use PurpleWiki::View::wikihtml;

	%params = (
		config	=> new PurpleWiki::Config ('.'),
		freelink => 1,
	);


	my $parser = PurpleWiki::Parser::WikiText->new;
	my $tree = $parser->parse($text, %config);

	#print $tree->view ('xhtml', %params);

	my $view = new PurpleWiki::View::wikihtml;
	return $view->view ($tree);
}

0.99999;
