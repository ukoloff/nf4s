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

TEST_CASE("Test Span::bounds()")
{
    dbs::Span z = {{0, 1}, 0, {1, 0}};
    auto b = z.bounds();
    CHECK(b.min.to_c() == dbs::Complex(0, 0));
    CHECK(b.max.to_c() == dbs::Complex(1, 1));
    z.bulge = 0.1F;
    CHECK(z.bounds() == b);
    z.bulge = 0.42F;
    auto b2 = z.bounds();
    CHECK(b2.max == b.max);
    CHECK(b2.min.x == b2.min.y);
    CHECK(b2.min.x < 0);
    z.bulge = -0.42F;
    b2 = z.bounds();
    CHECK(b2.min == b.min);
    CHECK(b2.max.x == b2.max.y);
    CHECK(b2.max.x > 1);
    z.bulge = 1;
    b2 = z.bounds();
    CHECK(b2.max == b.max);
    CHECK(b2.min.x == b2.min.y);
    CHECK(b2.min.x == Approx((1 - sqrt(2))/2));
    z.bulge = -1;
    b2 = z.bounds();
    CHECK(b2.min == b.min);
    CHECK(b2.max.x == b2.max.y);
    CHECK(b2.max.x == Approx((1 + sqrt(2))/2));
}
