V1_COMPAT=1
# If RACK_DIR is not defined when calling the Makefile, defaults to use the Rack-SDK submodule
RACK_DIR ?= Rack-SDK

include $(RACK_DIR)/arch.mk

ifeq ($(ARCH), lin)
    CXXFLAGS += -DLINK_PLATFORM_LINUX=1
endif

ifeq ($(ARCH), mac)
    CXXFLAGS += -DLINK_PLATFORM_MACOSX=1
endif

ifeq ($(ARCH), win)
    CXXFLAGS += -DLINK_PLATFORM_WINDOWS=1
	LDFLAGS += -lwsock32 -lws2_32 -liphlpapi
endif

FLAGS += -Imodules/LinkKit/include
LDFLAGS += -lLinkKit -framework UIKit -framework Foundation -framework CoreGraphics

ifdef CATALYST
	LDFLAGS += -Lmodules/LinkKit/LinkKit.xcframework/ios-arm64_x86_64-maccatalyst
else
	LDFLAGS += -Lmodules/LinkKit/LinkKit.xcframework/ios-arm64_armv7
endif

SOURCES += $(wildcard src/*.cpp)

# Add files to the ZIP package when running `make dist`
# The compiled plugin is automatically added.
DISTRIBUTABLES += $(wildcard LICENSE*) res

# Include the VCV Rack plugin Makefile framework
include $(RACK_DIR)/plugin.mk
