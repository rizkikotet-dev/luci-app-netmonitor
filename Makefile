# Description: Network Monitor for LuCI
# Author: RizkiKotet
# License: Apache License, Version 2.0

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-netmonitor
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_MAINTAINER:=rizkikotet <rizkidhc31@gmail.com>
PKG_LICENSE:=Apache-2.0

LUCI_TITLE:=Network Monitor
LUCI_DESCRIPTION:=Network Monitor for LuCI, netdata and vnstat
LUCI_DEPENDS:=+luci-base +netdata +vnstati2
PKG_ARCH:=all

include $(TOPDIR)/feeds/luci/luci.mk

define Package/$(PKG_NAME)/postinst
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
	echo "Installing Network Monitor..."
	# Add cron job if it doesn't exist
	(crontab -l 2>/dev/null | grep -q "/www/netmonitor/vnstati.sh" || \
		(crontab -l 2>/dev/null; echo "*/5 * * * * /www/netmonitor/vnstati.sh >/dev/null 2>&1") | crontab -) && \
		/etc/init.d/cron restart

	# Create directory for images if it doesn't exist
	mkdir -p /www/netmonitor
	chmod 755 /www/netmonitor/vnstati.sh

	# Restart services
	/etc/init.d/netdata enable
	/etc/init.d/netdata restart
	
	# Reload uci defaults
	rm -f /tmp/luci-indexcache
	exit 0
}
endef

define Package/$(PKG_NAME)/prerm
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
	echo "Removing Network Monitor..."
	# Remove cron job
	crontab -l 2>/dev/null | grep -v "/www/netmonitor/vnstati.sh" | crontab -
	/etc/init.d/cron restart
	exit 0
}
endef

include $(INCLUDE_DIR)/package.mk

define Build/Compile
	# No compilation needed
endef

$(eval $(call BuildPackage,$(PKG_NAME)))