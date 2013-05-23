LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

CSOUND_SRC_ROOT := ../../../..
LIBFLUIDSYNTH_SRC_DIR := $(LOCAL_PATH)/../../../../../android/fluidsynth-android/jni/

LOCAL_MODULE   := fluidsynth 
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../../H $(LOCAL_PATH)/../../../.. $(LOCAL_PATH)/../../../ $(LIBFLUIDSYNTH_SRC_DIR)/include $(CSOUND_SRC_ROOT)/Opcodes/fluidOpcodes/
LOCAL_CFLAGS := -O3 -D__BUILDING_LIBCSOUND -DENABLE_NEW_PARSER -DLINUX -DHAVE_DIRENT_H -DHAVE_FCNTL_H -DHAVE_UNISTD_H -DHAVE_STDINT_H -DHAVE_SYS_TIME_H -DHAVE_SYS_TYPES_H -DHAVE_TERMIOS_H 
LOCAL_CPPFLAGS :=$(LOCAL_CFLAGS)
###

LOCAL_SRC_FILES := $(CSOUND_SRC_ROOT)/Opcodes/fluidOpcodes/fluidOpcodes.cpp 

#LOCAL_LDLIBS := 

LOCAL_STATIC_LIBRARIES := fluidsynth-static 

include $(BUILD_SHARED_LIBRARY)

$(call import-module,fluidsynth-android/jni)