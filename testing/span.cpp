#include "!stdafx.h"
#include "Dbs.h"

TEST_CASE("Check uniformity") {
  const int N = 100;
  const int B = 28;
  dbs::Span span = {{0, 0}, 1, {0, 1}};
  for (int i = 0; i <= B; i++) {
    span.bulge = (float)i;
    float min, max;
    dbs::Complex p, prev;
    for (int j = 0; j <= N; j++, prev = p) {
      p = span.at(j / (float)N);
      if (!j) continue;
      float d = abs(p - prev);
      if (1 == j || min > d) min = d;
      if (1 == j || max < d) max = d;
    }
    max = ((max / min) - 1) * 100;
    // printf("%.1f: %.2f%%\t", span.bulge, max);
    CHECK(max >= 0);
    CHECK(max < 25);
  }
  printf("\n");
}

TEST_CASE("Calc perimeters") {
  dbs::Span A = {{0, 0}, 0, {0, 1}};
  CHECK(A.perimeter() == 1);
  A.a.y = 2;
  CHECK(A.perimeter() == 1);
  A.a.x = 1;
  CHECK(A.perimeter() == Approx(sqrt(2)));
  A.bulge = (float)sqrt(2) - 1;
  CHECK(A.perimeter() == Approx(M_PI / 2));
  A.bulge = -A.bulge;
  CHECK(A.perimeter() == Approx(M_PI / 2));
  A.bulge = 1;
  CHECK(A.perimeter() == Approx(M_PI / sqrt(2)));
  A.bulge = -1;
  CHECK(A.perimeter() == Approx(M_PI / sqrt(2)));
}

TEST_CASE("Calc areas") {
  dbs::Span A = {{0, 0}, 0, {0, 1}};
  CHECK(A.area() == 0);
  A.b.x = 1;
  CHECK(A.area() == 0);
  A.a.y = 1;
  CHECK(A.area() == 1. / 2);

  dbs::Span B = {{10, 0}, 1, {11, 0}};
  CHECK(B.area() == Approx(-M_PI / 8));
  B.bulge = 1 - (float)sqrt(2);
  CHECK(B.area() == Approx(M_PI / 8 - 1. / 4));
}
