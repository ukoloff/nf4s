#include "!stdafx.h"
#include "Dbs.h"

TEST_CASE("Find matching bulge & position")
{
  dbs::Span Z = {{0, 1}, 0, {2, 0}};

  for(Z.bulge = -2.0; Z.bulge <= 2.0; Z.bulge += (float)0.1)
    for(float pos = -0.9F; pos < 0.95F; pos += 0.1F)
    {
      CHECK(Approx(Z.bulge) == Z.bulgeOf(Z.at(pos)));
      CHECK(Approx(pos) ==  Z.indexOf(Z[pos]));
      auto a = Z.bulgeLeft(pos);
      auto b = Z.bulgeRight(pos);
      CHECK(Approx(Z.bulge) == (a + b)/(1 - a * b));
      CHECK(abs(Z.bulge) >= abs(a));
      CHECK(abs(Z.bulge) >= abs(b));
      CHECK(abs(pos > 0 ? b : a) < 1);
    }
}
