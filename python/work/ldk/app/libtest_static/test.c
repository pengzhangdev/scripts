#include <stdio.h>

//extern int DBG_DRV_Printf( const char *format, ...);
#define DBG_DRV_Printf printf

int CaPrint() {
    int i = 0;
    i = DBG_DRV_Printf("helleo world jeff\n");
    if(i == 1) {
        DBG_DRV_Printf("helleo world jeff right\n");
    }
    return 0;
}

