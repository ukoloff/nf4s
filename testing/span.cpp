#include "!stdafx.h"
#include "Dbs.h"

TEST_CASE("Check uniformity")
{
    const int N = 100;
    const int B = 28;
    dbs::Span span = {{0, 0}, 1, {0, 1}};
    for(int i = 0; i <= B; i++)
    {
        span.bulge = (float)i;
        float min, max;
        dbs::Complex p, prev;
        for(int j = 0; j <= N; j++, prev = p)
        {
            p = span.at(j / (float)N);
            if(!j) continue;
            float d = abs(p - prev);
            if(1 == j || min > d) min = d;
            if(1 == j || max < d) max = d;
        }
        max = ((max / min) - 1) * 100;
        cout << span.bulge << ": " << max << "%\t";
        REQUIRE(max < 25);
    }
    cout << '\n';
}

TEST_CASE("Calc perimeters")
{
    dbs::Span A = {{0, 0}, 0, {0, 1}};
    CHECK(A.perimeter() == 1);
    A.a.y = 2;
    CHECK(A.perimeter() == 1);
    A.a.x = 1;
    CHECK(A.perimeter() == Approx(sqrt(2)));
    A.bulge = sqrt(2) - 1;
    CHECK(A.perimeter() == Approx(M_PI / 2));
    A.bulge = -A.bulge;
    CHECK(A.perimeter() == Approx(M_PI / 2));
    A.bulge = 1;
    CHECK(A.perimeter() == Approx(M_PI / sqrt(2)));
    A.bulge = -1;
    CHECK(A.perimeter() == Approx(M_PI / sqrt(2)));
}
