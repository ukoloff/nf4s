#include "stdafx.h"
#include "Dbs.h"

using namespace dbs;

TEST_CASE("JSON string encode")
{
    REQUIRE(Part::quote("qwe") == R"("qwe")");
    const string dst = R"("as\"df\\zx")";
    REQUIRE(Part::quote("as\"df\\zx") == dst);
    REQUIRE(Part::quote("-\r-\n-") == R"("-\r-\n-")");
}
