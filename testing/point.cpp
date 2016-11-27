#include "gtest11.h"
#include "Dbs.h"

using namespace dbs;

TEST(point, to_c)
{
    P p = {1, 2};
    ASSERT_EQ(p.to_c(), Complex(1, 2));
}
