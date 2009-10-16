# -*- Makefile -*- for stripped down SQLite 3 static lib.

ifneq ($(findstring $(MAKEFLAGS),s),s)
ifndef V
        QUIET_CC       = @echo '   ' CC $@;
        QUIET_AR       = @echo '   ' AR $@;
        QUIET_INSTALL  = @echo '   ' INSTALL $<;
        export V
endif
endif

LIBSQL = libsqlite3.a
AR    ?= ar
CC    ?= gcc
RANLIB = ranlib
RM    ?= rm -f

prefix ?= /usr/local
libdir := $(prefix)/lib
includedir := $(prefix)/include

# Omit SQLite features we don't need.
CFLAGS ?= -O2
CFLAGS +=-DSQLITE_OMIT_AUTHORIZATION \
		 -DSQLITE_OMIT_AUTOVACUUM \
		 -DSQLITE_OMIT_COMPLETE \
		 -DSQLITE_OMIT_BLOB_LITERAL \
		 -DSQLITE_OMIT_COMPOUND_SELECT \
		 -DSQLITE_OMIT_CONFLICT_CLAUSE \
		 -DSQLITE_OMIT_DATETIME_FUNCS \
		 -DSQLITE_OMIT_EXPLAIN \
	     -DSQLITE_OMIT_INTEGRITY_CHECK \
		 -DSQLITE_OMIT_PAGER_PRAGMAS \
		 -DSQLITE_OMIT_PROGRESS_CALLBACK \
		 -DSQLITE_OMIT_SCHEMA_PRAGMAS \
		 -DSQLITE_OMIT_SCHEMA_VERSION_PRAGMAS \
		 -DSQLITE_OMIT_TCL_VARIABLE \
	     -DSQLITE_OMIT_LOAD_EXTENSION \
		 -DSQLITE_PREFER_PROXY_LOCKING=0 \
		 -DSQLITE_THREADSAFE=0 \
		 -w

.PHONY: install

all: $(LIBSQL)

$(includedir)/%.h: %.h
	-@if [ ! -d $(includedir)  ]; then mkdir -p $(includedir); fi
	$(QUIET_INSTALL)cp $< $@
	@chmod 0644 $@

$(libdir)/%.a: %.a
	-@if [ ! -d $(libdir)  ]; then mkdir -p $(libdir); fi
	$(QUIET_INSTALL)cp $< $@
	@chmod 0755 $@

install: $(includedir)/sqlite3.h $(libdir)/libsqlite3.a

clean:
	$(RM) *.o *.a

distclean: clean

$(LIBSQL): sqlite3.o
	$(QUIET_AR)$(AR) rcu $@ $^
	@$(RANLIB) $@

%.o: %.c
	$(QUIET_CC)$(CC) $(CFLAGS) -o $@ -c $<
