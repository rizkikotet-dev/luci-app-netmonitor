# Description: Network Monitor for LuCI
# Author: RizkiKotet
# License: Apache License, Version 2.0

include $(TOPDIR)/rules.mk

# Include LuCI specific Makefile for access to LuCI build system
include $(TOPDIR)/feeds/luci/luci.mk

LUCI_TITLE:=Network Monitor
LUCI_DESCRIPTION:=Network Monitor for LuCI, netdata and vnstati2
LUCI_DEPENDS:=+netdata +vnstati2
PKG_NAME:=luci-app-netmonitor
PKG_VERSION:=1.0.0
PKG_RELEASE:=08032025

PKG_MAINTAINER:=rizkikotet <rizkidhc31@gmail.com>
PKG_LICENSE:=Apache-2.0

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=Network Monitor for LuCI
  DEPENDS:=$(LUCI_DEPENDS)
  PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
  Network Monitor for LuCI, netdata and vnstati2.
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
	echo "Post Installation Script"
	# Add cron job if it doesn't exist
	(crontab -l | grep -q "/www/netmonitor/vnstati.sh" || (crontab -l; echo "*/5 * * * * /www/netmonitor/vnstati.sh >/dev/null 2>&1") | crontab -) && /etc/init.d/cron restart

	# Enable netdata service if it's not already enabled
	# /etc/init.d/netdata enable
	# /etc/init.d/netdata restart
}
endef

define Package/$(PKG_NAME)/prerm
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
	echo "Pre-removal Script"

	# Stop and disable service if needed
	# /etc/init.d/network-monitor stop
	# /etc/init.d/network-monitor disable
}
endef

define Package/$(PKG_NAME)/postrm
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
	echo "Post-removal Script"
	# Remove cron job
	crontab -l | grep -v "/www/netmonitor/vnstati.sh" | crontab - && /etc/init.d/cron restart
}
endef

$(eval $(call BuildPackage,$(PKG_NAME)))