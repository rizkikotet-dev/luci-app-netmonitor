# Description: Network Monitor for LuCI
# Author: RTA
# License: Apache License, Version 2.0

include $(TOPDIR)/rules.mk

LUCI_TITLE:=Network Monitor
LUCI_DESCRIPTION:=Network Monitor for LuCI, netdata and vnstati2
LUCI_DEPENDS:=+netdata +vnstati2
PKG_VERSION:=1.0.0
PKG_RELEASE:=08032025

CONFIG_LUCI_CSSTIDY:=

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature