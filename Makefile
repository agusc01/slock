# dslock - simple screen locker
# See LICENSE file for copyright and license details.

include config.mk

SRC = dslock.c ${COMPATSRC}
OBJ = ${SRC:.c=.o}

all: dslock

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk arg.h util.h

config.h:
	cp config.def.h $@

dslock: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f dslock ${OBJ} dslock-${VERSION}.tar.gz

dist: clean
	mkdir -p dslock-${VERSION}
	cp -R LICENSE Makefile README dslock.1 config.mk \
		${SRC} config.def.h arg.h util.h dslock-${VERSION}
	tar -cf dslock-${VERSION}.tar dslock-${VERSION}
	gzip dslock-${VERSION}.tar
	rm -rf dslock-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f dslock ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/dslock
	chmod u+s ${DESTDIR}${PREFIX}/bin/dslock
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" <dslock.1 >${DESTDIR}${MANPREFIX}/man1/dslock.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/dslock.1

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/dslock
	rm -f ${DESTDIR}${MANPREFIX}/man1/dslock.1

.PHONY: all clean dist install uninstall
