LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := \
	test.c \

LOCAL_CFLAGS += -fPIC
LOCAL_MODULE_TAGS := eng

LOCAL_C_INCLUDES:= \
	include \

LOCAL_MODULE := libtest

include $(BUILD_SHARED_LIBRARY)
#include $(BUILD_EXECUTABLE)
