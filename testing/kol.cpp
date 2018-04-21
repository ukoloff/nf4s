#include "!stdafx.h"
#include "iDbs.h"

TEST_CASE("Reading KOL") {
  istringstream src("a   10 0\nb c 1 1  \nx 5  1");
  dbs::i::Kol kol(src);
  CHECK(kol.next());
  CHECK(kol.dbs == "a");
  CHECK(kol.count == 10);
  CHECK(kol.list);
  CHECK(kol.next());
  CHECK(kol.dbs == "b c");
  CHECK(kol.count == 1);
  CHECK(!kol.list);
  CHECK(kol.next());
  CHECK(kol.dbs == "x");
  CHECK(kol.count == 5);
  CHECK(!kol.list);
  CHECK(!kol.next());
}
