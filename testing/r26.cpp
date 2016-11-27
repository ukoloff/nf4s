#include "gtest11.h"
#include "iDbs.h"

using namespace dbs::i;

TEST(r26, partid)
{
    string s = "1234";
    R26::swap(s);
    EXPECT_EQ(s, "2143");
}

