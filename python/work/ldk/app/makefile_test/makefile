SYSTEM_ROOT := $(PWD)
SYSTEM_TOOLCHAIN_ROOT := $(SYSTEM_ROOT)/../cos-sdk/cos-sdk_20130416-142010_linux-x86/

SYSTEM_CC := $(SYSTEM_TOOLCHAIN_ROOT)/toolchains/gcc/linux-x86/arm/arm-linux-androideabi-4.6/bin/arm-linux-androideabi-gcc
SYSTEM_CXX := $(SYSTEM_TOOLCHAIN_ROOT)/toolchains/gcc/linux-x86/arm/arm-linux-androideabi-4.6/bin/arm-linux-androideabi-g++
SYSTEM_AR := $(SYSTEM_TOOLCHAIN_ROOT)/toolchains/gcc/linux-x86/arm/arm-linux-androideabi-4.6/bin/arm-linux-androideabi-ar

SYSTEM_CFLAGS := \
	-fno-exceptions \
	-Wno-multichar \
	-msoft-float \
	-fpic \
	-ffunction-sections \
	-fdata-sections \
	-funwind-tables \
	-fstack-protector \
	-Wa,--noexecstack \
	-Werror=format-security \
	-fno-short-enums \
	-march=armv5te \
	-mtune=xscale \
	-D__ARM_ARCH_5__ \
	-D__ARM_ARCH_5T__ \
	-D__ARM_ARCH_5E__ \
	-D__ARM_ARCH_5TE__ \
	-include $(SYSTEM_TOOLCHAIN_ROOT)/include/system/core/include/arch/linux-arm/AndroidConfig.h \
	-mthumb-interwork \
	-DANDROID \
	-fmessage-length=0 \
	-W -Wall -Wno-unused \
	-Winit-self \
	-Wpointer-arith \
	-DHOST_BUILD=0 \
	-DTARGET_BUILD=1 \
	-Werror=return-type \
	-Werror=non-virtual-dtor \
	-Werror=address \
	-Werror=sequence-point \
	-DNDEBUG -g -Wstrict-aliasing=2 \
	-fgcse-after-reload \
	-frerun-cse-after-loop \
	-frename-registers -DNDEBUG \
	-UDEBUG -mthumb -Os \
	-fomit-frame-pointer \
	-fno-strict-aliasing -fPIC -MD -DQCOM -DGAIA

SYSTEM_CPPFLAGS := $(SYSTEM_CFLAGS)
SYSTEM_ARFLAGS := crsP
SYSTEM_LDDIR := -L$(SYSTEM_TOOLCHAIN_ROOT)/lib
SYSTEM_INCLUDES := \
	$(SYSTEM_TOOLCHAIN_ROOT)/include \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/gaia \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/memleak \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/common/frameworks/base/native/include \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/common/hardware/libhardware/include \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/common/external/skia/include \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/common/external/skia/include/core \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/common/external/icu4c/common \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/common/external/icu4c/i18n \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/common/external/openssl/include \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/common/external/stlport/stlport \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/common/external/gtest/include \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/common/external/gmock/include \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/common/external/opengl/include \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/common/external/json/include \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/common/external/libxml2/include \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/bionic \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/sdk/privilege/include \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/bionic/libc/arch-arm/include \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/bionic/libc/include \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/bionic/libstdc++/include \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/bionic/libc/kernel/common \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/bionic/libc/kernel/arch-arm \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/bionic/libm/include/arm \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/bionic/libthread_db/include \
	$(SYSTEM_TOOLCHAIN_ROOT)/include/system/core/include/arch/linux-arm/ \

INCLUDES:= $(foreach var, $(SYSTEM_INCLUDES), -I$(var))

