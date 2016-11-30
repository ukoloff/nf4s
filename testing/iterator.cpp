#include "stdafx.h"
#include "Dbs.h"

using namespace dbs;

TEST_CASE("Click iterator")
{
    File Z;
    Z.read("../testing/geodet/rounded3x4.dbs");

    SECTION("Check counts")
    {
      REQUIRE(Z.parts.size() == 1);
      REQUIRE(Z.parts[0].paths.size() == 1);
    }

    auto path = Z.parts[0].paths[0];

    SECTION("Get size")
    {
      size_t n = 0;
      for(auto i = path.spans(); auto span = i.get(); n++);
      REQUIRE(n == 8);
      REQUIRE(n + 1 == Z.parts[0].paths[0].nodes.size());
    }

    SECTION("Test ordering")
    {
      size_t n = 0;
      for(auto i = path.spans(); auto span = i.get(); )
      {
          REQUIRE(span->a == Z.parts[0].paths[0].nodes[n].to_p());
          REQUIRE(span->b == Z.parts[0].paths[0].nodes[++n].to_p());
          REQUIRE(span->bulge == Approx(n & 1 ? 0 : 1 - sqrt(2)));
      }
    }
}
