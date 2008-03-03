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
### OpenGrok blog
###

SHADOW=montage -background none -geometry +5+5 -shadow
TN=convert -resample 50%
BLOG3+=images/opengrok-shot1.png
BLOG3+=images/opengrok-shot2.png
BLOG3+=images/opengrok-shot1-tn.png
BLOG3+=images/opengrok-shot2-tn.png

JUNK+=$(BLOG3)
JUNK+=images/opengrok-shot1.xwd-tn
JUNK+=images/opengrok-shot2.xwd-tn

images/opengrok-shot1.png: images/opengrok-shot1.xwd
	${SHADOW} $< $@

images/opengrok-shot2.png: images/opengrok-shot2.xwd
	${SHADOW} $< $@

images/opengrok-shot1-tn.png: images/opengrok-shot1.xwd
	${TN} $< $<-tn
	${SHADOW} $<-tn $@

images/opengrok-shot2-tn.png: images/opengrok-shot2.xwd
	${TN} $< $<-tn
	${SHADOW} $<-tn $@

blog3: ${BLOG3}

###
### Meta...
###

build: ${TARGETS}

clean:
	rm -f ${TARGETS} ${JUNK}

upload: build
	tar cf - ${TARGETS} ${BLOG3} images/mozchomp.gif |ssh ovecka.be "tar xf - -C public_html/blog"
