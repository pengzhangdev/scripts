LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	main.c \
	test.c

LOCAL_MODULE_TAGS := eng

LOCAL_C_INCLUDES:= \
	include \

LOCAL_MODULE := test

#include $(BUILD_SHARED_LIBRARY)
include $(BUILD_EXECUTABLE)


