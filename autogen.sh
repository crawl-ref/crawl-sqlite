#!/bin/sh

aclocal
automake --add-missing
libtoolize --copy --force
autoreconf
