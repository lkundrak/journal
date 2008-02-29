# $Id$

BLOGPAGE?=awk -f scripts/blogpage.awk templates/page.template
BLOGINDEX?=awk -f scripts/blogpage.awk templates/index.template
GENRSS?=perl scripts/genrss.pl
#WIKI2HTML?=perl scripts/wiki2html.pl
TIDY?=tidy

SOURCES=$(shell ls -t */*.cocot)
BLOGS=$(shell echo ${SOURCES} |sed 's|.cocot|.html|g')

TARGETS=${BLOGS} index.html rss.xml

all: build

###
### Blog entries by themselves
###

.SUFFIXES: .cocot .html
.cocot.html: templates/page.template scripts/blogpage.awk
	${BLOGPAGE} $< >$@
	${TIDY} -qim $@ || rm -f $@

###
### RSS feed
###

rss.xml: ${SOURCES} scripts/genrss.pl
	${GENRSS} ${SOURCES} >$@
	${TIDY} -qim -xml -raw $@ || rm -f $@

###
### Index
###

index.html: ${SOURCES} templates/index.template scripts/blogpage.awk
	${BLOGINDEX} ${SOURCES} >$@
	${TIDY} -qim $@ || rm -f $@

###
### Meta...
###

build: ${TARGETS}

clean:
	rm -f ${TARGETS}

upload: build
	tar cf - ${TARGETS} images/mozchomp.gif |ssh ovecka.be "tar xf - -C public_html/blog"
