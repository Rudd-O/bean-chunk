NAME := bean-chunk
PREFIX := /usr/local
BINDIR := $(PREFIX)/bin

ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: install uninstall clean dist rpm srpm vendor

first:
	/bin/true

install:
	cd $(ROOT_DIR) && install -D -m 0755 $(NAME) -T $(DESTDIR)$(BINDIR)/$(NAME)

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/$(NAME)

clean:
	cd $(ROOT_DIR) && find -name '*~' -print0 | xargs -0r rm -fv && rm -fr *.tar.gz *.rpm *.service

dist: clean
	@which rpmspec || { echo 'rpmspec is not available.  Please install the rpm-build package with the command `dnf install rpm-build` to continue, then rerun this step.' ; exit 1 ; }
	cd $(ROOT_DIR) || exit $$? ; excludefrom= ; test -f .gitignore && excludefrom=--exclude-from=.gitignore ; DIR=`rpmspec -q --queryformat '%{name}-%{version}\n' *spec | head -1` && FILENAME="$$DIR.tar.gz" && tar cvzf "$$FILENAME" --exclude="$$FILENAME" --exclude=.git --exclude=.gitignore $$excludefrom --transform="s|^|$$DIR/|" --show-transformed *

srpm: dist
	@which rpmbuild || { echo 'rpmbuild is not available.  Please install the rpm-build package with the command `dnf install rpm-build` to continue, then rerun this step.' ; exit 1 ; }
	cd $(ROOT_DIR) || exit $$? ; rpmbuild --define "_srcrpmdir ." -ts `rpmspec -q --queryformat '%{name}-%{version}.tar.gz\n' *spec | head -1`

rpm: dist
	@which rpmbuild || { echo 'rpmbuild is not available.  Please install the rpm-build package with the command `dnf install rpm-build` to continue, then rerun this step.' ; exit 1 ; }
	cd $(ROOT_DIR) || exit $$? ; rpmbuild --define "_srcrpmdir ." --define "_rpmdir builddir.rpm" -ta `rpmspec -q --queryformat '%{name}-%{version}.tar.gz\n' *spec | head -1`
	cd $(ROOT_DIR) ; mv -f builddir.rpm/*/* . && rm -rf builddir.rpm
