#include "!stdafx.h"
#include "Dbs.h"

TEST_CASE("Test Rect operations")
{
    dbs::Rect r;
    CHECK(!r);
    dbs::P p = {1, 2};
    r += p;
    CHECK(!!r);
    CHECK(r.min == p);
    CHECK(r.max == p);
    dbs::P q = {3, 0};
    auto sum =  r + q;
    CHECK(r.min == p);
    CHECK(r.max == p);
    CHECK(sum.min.x == 1);
    CHECK(sum.min.y == 0);
    CHECK(sum.max.x == 3);
    CHECK(sum.max.y == 2);

    CHECK(sum == sum + dbs::Rect());
    CHECK(sum == sum + dbs::Rect(p));
    CHECK(sum == sum + dbs::Rect(q));
    CHECK(sum == sum + r);

    r += 0.1F;
    CHECK(r.min.x == Approx(0.9));
    CHECK(r.min.y == Approx(1.9));
    CHECK(r.max.x == Approx(1.1));
    CHECK(r.max.y == Approx(2.1));

    auto z = r + sum;
    CHECK(z.min.x == r.min.x);
    CHECK(z.min.y == sum.min.y);
    CHECK(sum.max == sum.max);
}
