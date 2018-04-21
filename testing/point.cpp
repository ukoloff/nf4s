#include "!stdafx.h"
#include "Dbs.h"

using namespace dbs;

TEST_CASE("dbs::P is Complex too") {
  P p = {1, 2};
  REQUIRE(p.to_c() == Complex(1, 2));
}
