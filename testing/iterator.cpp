#include "stdafx.h"
#include "Dbs.h"

using namespace dbs;

TEST_CASE("Click iterator")
{
    File Z;
    Z.read("../testing/geodet/rounded3x4.dbs");
    REQUIRE(Z.parts.size() == 1);
    REQUIRE(Z.parts[0].paths.size() == 1);
    iSpan i(Z.parts[0].paths[0]);
    size_t n = 0;
    while(auto span = i.get())
        n++;
    REQUIRE(n == 8);
}
