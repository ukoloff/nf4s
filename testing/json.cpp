#include "gtest11.h"
#include "Dbs.h"

using namespace dbs;

TEST(json, quote)
{
    EXPECT_EQ(Part::quote("qwe"), R"("qwe")");
    EXPECT_EQ(Part::quote(R"(as"df\zx)"), R"("as\"df\\zx")");
    EXPECT_EQ(Part::quote("-\r-\n-"), R"("-\r-\n-")");
}
