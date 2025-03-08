# Description: Network Monitor for LuCI
# Author: RizkiKotet
# License: Apache License, Version 2.0

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-netmonitor
PKG_VERSION:=1.0.0
PKG_RELEASE:=08032025

PKG_MAINTAINER:=RizkiKotet <rizkidhc31@gmail.com>
PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE

LUCI_TITLE:=LuCI Network Monitor App
LUCI_DESCRIPTION:=Network monitoring application for LuCI
LUCI_DEPENDS:=+luci-base +netdata +vnstati2 +coreutils +coreutils-stat
LUCI_PKGARCH:=all

define Package/$(PKG_NAME)/conffiles
/etc/config/netmonitor
endef

include $(TOPDIR)/feeds/luci/luci.mk


# Install the init script
define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/root/etc/init.d/netmonitor $(1)/etc/init.d/netmonitor
	
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/root/etc/uci-defaults/90_netmonitor $(1)/etc/uci-defaults/90_netmonitor
	
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/root/usr/bin/netmonitor $(1)/usr/bin/netmonitor
	
	$(INSTALL_DIR) $(1)/www/netmonitor
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/htdocs/netmonitor/index.html $(1)/www/netmonitor/index.html
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/htdocs/netmonitor/vnstati_script.sh $(1)/www/netmonitor/vnstati_script.sh
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./htdocs $(PKG_BUILD_DIR)/
	$(CP) ./luasrc $(PKG_BUILD_DIR)/
	$(CP) ./root $(PKG_BUILD_DIR)/
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	( . /etc/uci-defaults/90_netmonitor ) && rm -f /etc/uci-defaults/90_netmonitor
	chmod +x /etc/init.d/netmonitor
	chmod +x /usr/bin/netmonitor
	chmod +x /www/netmonitor/vnstati_script.sh
	/etc/init.d/netmonitor enable
	/etc/init.d/netmonitor start
fi
exit 0
endef

define Package/$(PKG_NAME)/prerm
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	/etc/init.d/netmonitor stop
	/etc/init.d/netmonitor disable
fi
exit 0
endef

# call BuildPackage - OpenWrt buildroot signature
$(eval $(call BuildPackage,$(PKG_NAME)))