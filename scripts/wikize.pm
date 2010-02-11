# Preprocess input for wikifying

use PurpleWiki::Config;
use PurpleWiki::Parser::WikiText;
use PurpleWiki::View::wikihtml;

%params = (
	config	=> new PurpleWiki::Config ('.'),
	freelink => 1,
);

sub dochunk
{
	my $text = shift;

	my $parser = PurpleWiki::Parser::WikiText->new;
	my $tree = $parser->parse($text, %config);

	my $view = new PurpleWiki::View::wikihtml;
	return $view->view ($tree);
}

sub wikize
{
	my $body = '';
	my $html, $text;

	foreach ('<!-- /html -->', @_, '<!-- html -->') {
		if (/<!-- html -->/) {
			$body .= dochunk ($text);
			$html = 1;
			next;
		}

		if (/<!-- \/html -->/) {
			$text = '';
			$html = 0;
			next;
		}

		if ($html) {
			$body .= $_;
		} else {
			s/<!-- .*? -->//g;
			$text .= $_;
		}
	}

	return $body;
}

0.99999;
