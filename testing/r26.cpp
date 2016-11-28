#include "stdafx.h"
#include "iDbs.h"

using namespace dbs::i;

TEST_CASE("Reverting PARTID")
{
    string s = "1234";
    R26::swap(s);
    REQUIRE(s == "2143");
}
