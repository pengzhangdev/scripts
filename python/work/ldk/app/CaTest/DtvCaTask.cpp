#define LOG_TAG "DtvCaTask"
#define DEBUG_LEVEL 1
#include "DtvCaTask.h"
#include <stdio.h>
#include <stdarg.h>
#include <gaia/base/gloger.h>

using namespace gaia::base;

int DBG_DRV_Printf( const char *format, ...) {
    char buf[4096];
    va_list va;
    int len;
    va_start(va,format);
    (void)vsprintf(buf,format,va);
    va_end(va);
    len=strlen(buf);

    GLOG(LOG_TAG, LOGDBG, "%s\n", buf);
	return 1;
}
