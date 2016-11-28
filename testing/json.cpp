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

TEST_CASE("Load DBS")
{
    File Z;
    Z.read("../testing/geodet/ring.dbs");
    ostringstream j;
    Z.json(j);
    REQUIRE(j.str() == R"([{"partid":"RING","paths":[[[0,2,-1],[0,-2,-1],[0,2,0]],[[0,1,1],[0,-1,1],[0,1,-0]]]}])");
}
