# $Id: makefile,v 1.1.1.1 2010/10/21 13:05:06 po34demo Exp $

TARGET=index
SOURCES=attachments.apt

$(TARGET):	html

html:
	aptconvert -toc -pi html strict yes ../$(TARGET).html $(SOURCES)

htmlclean:
	rm -rf ../$(TARGET)*.html ../apt_*.gif ../*.css

clean:	htmlclean

distclean:	clean
