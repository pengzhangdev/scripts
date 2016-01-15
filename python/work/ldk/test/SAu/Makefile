include ../../ldk.mk

CC = $(COS_GCC)
CXX = $(COS_GXX)
AR = $(COS_AR)
CFLAGS = $(COS_CFLAGS)
CPPFLAGS = $(COS_CFLAGS)
SHARED_LDFLAGS = $(COS_SHAREDLIBRARIES_LDFLAGS)
ARFLAGS = $(COS_AR_FLAGS)
EXEC_LDFLAGS = $(COS_EXECUTABLE_LDFLAGS)


# pattern rule for all objects files
%.o: %.c *.h
	$(CC) -c $(CFLAGS) $< -o $@

all: index
index: SAu.o ds/ds.o ds/globals.o ds/shallow.o ds/helped.o ds/deep2.o ds/blind2.o
	$(AR) $(ARFLAGS) SAu.a SAu.o ds/ds.o ds/globals.o ds/shallow.o ds/helped.o ds/deep2.o ds/blind2.o

.PHONY: clean
clean:
	-find ./ -name "*.o" -exec rm -f '{}' \;
	-find ./ -name "*.d" -exec rm -f '{}' \;
	-rm -f SAu.a
