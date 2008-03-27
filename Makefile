# $Id$

BLOGPAGE?=awk -f scripts/blogpage.awk templates/page.template
BLOGINDEX?=awk -f scripts/blogpage.awk templates/index.template
GENRSS?=perl scripts/genrss.pl
#WIKI2HTML?=perl scripts/wiki2html.pl
TIDY?=tidy -raw

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

JUNK+=images/*-tn.*

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

entries/opengrok-on-rhel5.html: ${BLOG3}

###
### Gallery blog
###

RS=convert -resize 570
BLOG4+=images/xyz-gallery-tn.png

images/xyz-gallery-tn.png: images/xyz-gallery.jpeg
	${RS} $< $<-tn
	${SHADOW} $<-tn $@

entries/galleries.html: ${BLOG4}

###
### Opengrok2
###

BLOG5+=images/fedora-opengrok-1-tn.png
BLOG5+=images/fedora-opengrok-2-tn.png
BLOG5+=images/fedora-opengrok-3-tn.png
BLOG5+=images/fedora-opengrok-4-tn.png
BLOG5+=images/fedora-opengrok-5-tn.png

images/fedora-opengrok-1-tn.png: images/fedora-opengrok-1.xwd
	${RS} $< $<-tn
	${SHADOW} $<-tn $@

images/fedora-opengrok-2-tn.png: images/fedora-opengrok-2.xwd
	${RS} $< $<-tn
	${SHADOW} $<-tn $@

images/fedora-opengrok-3-tn.png: images/fedora-opengrok-3.xwd
	${RS} $< $<-tn
	${SHADOW} $<-tn $@

images/fedora-opengrok-4-tn.png: images/fedora-opengrok-4.xwd
	${RS} $< $<-tn
	${SHADOW} $<-tn $@

images/fedora-opengrok-5-tn.png: images/fedora-opengrok-5.xwd
	${RS} $< $<-tn
	${SHADOW} $<-tn $@

entries/fedora-opengrok.html: ${BLOG5}

###
### Meta...
###

build: ${TARGETS}

clean:
	rm -f ${TARGETS} ${JUNK} ?

upload: build
	tar cf - ${TARGETS} images/mozchomp.gif |ssh ovecka.be "tar xf - -C public_html/blog"
