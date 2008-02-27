BEGIN {
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


/@TITLE@/ {
	gsub ("@TITLE@", title);
}

/@BODY@/ {
	system ("perl scripts/wiki2html.pl <"ARGV[2]);
	ARGV[2]="";
	next;
}

/@HEADLINES@/ {
	for (i = 2; ARGV[i]; i++) {
		print "<hr>";
		system ("awk '/<!-- break -->/ {exit} {print $0}' "ARGV[i]\
			"| perl scripts/wiki2html.pl");
		link = ARGV[i];
		gsub (".cocot", ".html", link);
		gsub (".*", "<a href=\"&\">Read more...</a>", link);
		print "<div><i>"link"</i></div>";
		ARGV[i]="";
	}
	next;
}

{
	print $0;
}
