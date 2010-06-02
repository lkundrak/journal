BEGIN {
	cmd = "git log "ARGV[2];
	while (cmd |getline) {
		if (gsub ("^Date: *", "")) {
			gsub ("+.*", "");
			if (!last) last = $0
			first = $0;
		}
	}

	if (!ARGV[2]) {
		print "No input files" |"cat 1>&2";
		exit 1;
	}

	while (getline <ARGV[2]) {
		print $0 >/dev/stderr
		if (gsub ("<!-- rss:title -->.*<!-- /rss:title -->", "&")) {
			gsub (".*<!-- rss:title -->", "");
			gsub ("<!-- /rss:title -->.*", "");
			title = $0;
		}
	}
}

# Block replacements

/@BODY@/ {
	system ("perl scripts/wiki2html.pl <"ARGV[2]);
	file=ARGV[2];
	ARGV[2]="";
	next;
}

/@HEADLINES@/ {
	for (i = 2; ARGV[i]; i++) {
		print "<hr>";

		# Last modification date
		system ("scripts/creationdate.sh '<i>%c</i>' "ARGV[i]);

		# Caption and text
		system ("awk '/<!-- break -->/ {exit} {print $0}' "ARGV[i]\
			"| perl scripts/wiki2html.pl");

		# "Read more" link
		link = ARGV[i];
		gsub (".cocot", ".html", link);
		gsub (".*", "<a href=\"&\">Read more...</a>", link);
		print "<div><i>"link"</i></div>";
		ARGV[i]="";
	}
	next;
}

/@LATEST@/ {
	print "<hr>";

	# Last modification date
	system ("scripts/creationdate.sh '<i>%c</i>' "ARGV[2]);

	# Caption and text
	system ("awk '/<!-- break -->/ {exit} {print $0}' "ARGV[2]\
		"| perl scripts/wiki2html.pl");

	# "Read more" link
	link = ARGV[2];
	gsub (".cocot", ".html", link);
	if (system ("grep -q '<!-- break -->' "ARGV[2])) {
		gsub (".*", "<a href=\"&\">Read more...</a>", link);
	} else {
		gsub (".*", "<a href=\"&\">Link to the article alone</a>", link);
	}
	print "<div><i>"link"</i></div>";
	file=ARGV[2];
	ARGV[2] = "";

	next;
}

/@OLDER@/ {
	print "<h2>Older shit</h2>";

	print "<ul>";
	for (i = 3; ARGV[i]; i++) {
		print "<li>";

		link = ARGV[i];
		gsub (".cocot", ".html", link);
		printf ("<a href=\"%s\">", link);
		system ("sed -n 's/.*<!-- rss:title -->\\(.*\\)<!-- \\/rss:title -->.*/\\1<\\/a>/p' "ARGV[i]);

		# Last modification date
		system ("scripts/creationdate.sh '<i>(%D)</i>' "ARGV[i]);

		ARGV[i] = ""
		print "</li>";
	}
	print "</ul>";
	next;
}

/@LIKE@/ {
	link = ARGV[2];
	if (!link) link = file;
	gsub (".cocot", ".html", link);
	printf ("<iframe src='http://www.facebook.com/widgets/like.php?href=" \
		"http://v3.sk/~lkundrak/blog/%s' " \
		"scrolling='no' frameborder='0' " \
		"style='border:none; margin-top: 1em; width:450px; height:80px'>" \
		"</iframe>", link);
	next;
}

{
	# Inline replacements

	gsub ("@FIRST@", first);
	gsub ("@LAST@", last);
	gsub ("@TITLE@", title);

	print $0;
}
