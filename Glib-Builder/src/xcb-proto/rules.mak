# xcb-proto

XCB-PROTO := xcb-proto
XCB-PROTO_VERSION := 1.7
XCB-PROTO_PKG := $(XCB-PROTO)-$(XCB-PROTO_VERSION).tar.bz2
XCB-PROTO_URL := http://xcb.freedesktop.org/dist/$(XCB-PROTO_PKG)
XCB-PROTO_CFG := 

PKGS += $(XCB-PROTO)
ifeq ($(call need_pkg,"xcb-proto"),)
PKGS_FOUND += $(XCB-PROTO)
endif

DEPS_$(XCB-PROTO) := libpthread-stubs libXau

$(TARBALLS)/$(XCB-PROTO_PKG):
	$(call download,$(XCB-PROTO_URL))

.sum-$(XCB-PROTO): $(XCB-PROTO_PKG)

$(XCB-PROTO): $(XCB-PROTO_PKG) .sum-$(XCB-PROTO)
	$(UNPACK)
	$(MOVE)

.$(XCB-PROTO): $(XCB-PROTO)
#	cd $< && $(RECONF)
#	cd $< && NOCONFIGURE=1 ./autogen.sh
#	cd $< && ./autogen.sh --no-configure
ifndef HAVE_CROSS_COMPILE
	cd $< && $(BUILDVARS) $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(XCB-PROTO_CFG)
else
	cd $< && $(HOSTOOLS) $(HOSTVARS) ./configure $(HOSTCONF) $(XCB-PROTO_CFG)
endif
	cd $< && $(MAKE) install
	touch $@
