# Description: Network Monitor for LuCI
# Author: RizkiKotet
# License: Apache License, Version 2.0

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-netmonitor
PKG_VERSION:=1.0.1
PKG_RELEASE:=08032025

PKG_MAINTAINER:=RizkiKotet <rizkidhc31@gmail.com>
PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE

LUCI_TITLE:=LuCI Network Monitor App
LUCI_DESCRIPTION:=Network monitoring application for LuCI
LUCI_DEPENDS:=+luci-base +netdata +vnstati2 +coreutils +coreutils-stat
LUCI_PKGARCH:=all

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
$(eval $(call BuildPackage,$(PKG_NAME)))