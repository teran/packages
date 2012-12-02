#!/usr/bin/make -f

install:
	install -d	$(DESTDIR)/etc/init.d
	install -m755	$(CURDIR)/utorrent-server.init.d	$(DESTDIR)/etc/init.d/utorrent-server
	install -d	$(DESTDIR)/etc/utorrent-server
	install -m644	$(CURDIR)/utserver.conf			$(DESTDIR)/etc/utorrent-server/utorrent-server.conf
	install -d	$(DESTDIR)/usr/sbin
	install -m755	$(CURDIR)/utserver $(DESTDIR)/usr/sbin/utserver
	install -d	$(DESTDIR)/var/lib/utorrent-server/webui
	install -m755	$(CURDIR)/webui.zip			$(DESTDIR)/var/lib/utorrent-server/webui/webui.zip
	install -d	$(DESTDIR)/var/log/utorrent-server
