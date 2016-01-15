LOCAL_PATH:= $(call my-dir)

# libempty.so
include $(CLEAR_VARS)
LOCAL_SRC_FILES := \
	empty.c

LOCAL_MODULE_TAGS := eng
LOCAL_MODULE := libempty

include $(BUILD_SHARED_LIBRARY)
