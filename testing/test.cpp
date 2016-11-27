#include "gtest/gtest.h"
#include "Dbs.h"

TEST(dummy, equal)
{
    ASSERT_EQ(6*7, 42);
}

TEST(dummy, just)
{
    ASSERT_NE(2*2, 108);
}
