TOPDIR=./../../
BUILD_SRC_DIR=./../
CUR_DIR:= .
include $(TOPDIR)/makefile/common.mk
LIB=libwebserver.so	
exclude_dirs= include
INCPATH=-I$(BUILD_SRC_DIR)/include/
        
LIBPATH=$(TOPDIR)/www/lib

CFLAGS+= -fPIC 
CPPFLAGS+= -fPIC 
include $(TOPDIR)/makefile/Makefile.www