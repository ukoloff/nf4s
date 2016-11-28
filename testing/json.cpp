#include "stdafx.h"
#include "Dbs.h"

using namespace dbs;

TEST_CASE("JSON string encode")
{
    REQUIRE(Part::quote("qwe") == R"("qwe")");
    REQUIRE(Part::quote(R"(as"df\zx)") == R"("as\"df\\zx")");
    REQUIRE(Part::quote("-\r-\n-") == R"("-\r-\n-")");
}
