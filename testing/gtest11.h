// Fix error with Google Testing and C++11 (@MinGW?)
#ifdef __STRICT_ANSI__
#undef __STRICT_ANSI__
#endif

#include "gtest/gtest.h"
