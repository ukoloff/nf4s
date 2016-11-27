#include "gtest11.h"
#include "Dbs.h"

using namespace dbs;

TEST(json, quote)
{
    EXPECT_EQ(Part::quote("qwe"), "\"qwe\"");
    EXPECT_EQ(Part::quote("as\"df\\zx"), "\"as\\\"df\\\\zx\"");
    EXPECT_EQ(Part::quote("-\r-\n-"), "\"-\\r-\\n-\"");



}
