AC_INIT(RNAz, 2.1.1, wash@mit.edu, RNAz)
AM_INIT_AUTOMAKE

AC_PROG_CC


if test "$GCC" = yes; then
  AC_DEFINE(UNUSED, __attribute__ ((unused)), avoid warning about unused variables)
else
  AC_DEFINE(UNUSED,, only for gcc)
fi
      
AC_SUBST(VERSION)
ISODATE=`date +%Y-%m-%d`
AC_SUBST(ISODATE)


AC_HEADER_STDC
AC_PROG_CC_C99
AC_CHECK_HEADERS(malloc.h strings.h unistd.h)
AC_C_CONST
AC_TYPE_SIZE_T
AC_INLINE

AC_CHECK_FUNCS(strdup strstr strchr erand48)

AC_PROG_CXX

AC_PROG_RANLIB

AC_PROG_INSTALL

AC_CONFIG_HEADERS(config.h) 

# this is libsvm stuff
AC_SUBST([LIBSVM_VERSION],[3.23])

AC_OUTPUT([Makefile librna/Makefile rnaz/Makefile  perl/Makefile models/Makefile examples/Makefile man/Makefile])


