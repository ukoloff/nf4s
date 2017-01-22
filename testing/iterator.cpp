#include "!stdafx.h"
#include "Dbs.h"

using namespace dbs;

TEST_CASE("Click iterator")
{
    File Z;
    Z.read(geodet() + "rounded3x4.dbs");

    SECTION("Check counts")
    {
      REQUIRE(Z.parts.size() == 1);
      REQUIRE(Z.parts[0].paths.size() == 1);
    }

    auto path = Z.parts[0].paths[0];

    SECTION("Get size")
    {
      size_t n = 0;
      for(auto i = path.spans(); i.get(); n++);
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

    SECTION("Check perimeter")
    {
        CHECK(Z.parts[0].paths[0].perimeter() == Approx(6 + 2 * M_PI));
        CHECK(Z.parts[0].perimeter() == Approx(6 + 2 * M_PI));
    }

    SECTION("Check area")
    {
        CHECK(Z.parts[0].paths[0].area() == Approx(8 + M_PI));
        CHECK(Z.parts[0].area() == Approx(8 + M_PI));
    }

    SECTION("Check non-closed area")
    {
        dbs::Part & p = Z.parts[0];
        p.paths[0].nodes[0].x = 1.5;
        CHECK(p.paths[0].area() == 0);
        CHECK(p.area() == 0);
    }
}

TEST_CASE("Test radius")
{
    File Z;
    Z.read(geodet() + "ring.dbs");

    REQUIRE(Z.parts.size() == 1);
    auto part = Z.parts[0];
    REQUIRE(part.paths.size() == 2);

    size_t n = 2;
    for(auto & path: part.paths)
    {
        for(auto spans = path.spans(); auto span = spans.get(); )
        {
            CHECK(abs(span->center()) == Approx(0));
            CHECK(span->radius() == Approx((double)n));
        }
        n--;
    }
}

TEST_CASE("Test isRect()")
{
    File A;
    A.read(geodet() + "ring.dbs");
    CHECK(0 == A.isRect());

    File B;
    B.read(geodet() + "rounded3x4.dbs");
    CHECK(0 == B.isRect());

    File R;
    R.read(geodet() + "rectangle.dbs");
    CHECK(1 == R.isRect());
}

TEST_CASE("Test isCircle()")
{
    File A;
    A.read(geodet() + "rounded3x4.dbs");
    CHECK(0 == A.isCircle());

    File B;
    B.read(geodet() + "rectangle.dbs");
    CHECK(0 == B.isCircle());

    File C;
    C.read(geodet() + "ring.dbs");
    CHECK(0 == C.isCircle());
    CHECK(1 == C.parts.size());
    auto part = C.parts[0];
    CHECK(2 == part.paths.size());
    int i = 0;
    for(auto& path : part.paths)
        CHECK((i++ ? -1 : +1) == path.isCircle());
}
