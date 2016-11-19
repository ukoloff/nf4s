#include <fstream>

#include "Dbs.h"

void readDbs(string name)
{
    ifstream dbs;
    dbs.exceptions(ifstream::failbit | ifstream::eofbit | ifstream::badbit);
    dbs.open(name);
}

double DbsTransform::det(void) const
{
    return cosXX * sinYX - cosYX * sinXX;
}


DbsPoint operator*(const DbsTransform& t, const DbsPoint& p)
{
    class DbsPoint z;
    z.x = t.cosXX * p.x + t.cosYX * p.y + t.deltaX;
    z.y = t.sinXX * p.x + t.sinYX * p.y + t.deltaY;
    z.t = t.det() < 0 ? -p.t : p.t;
    return z;
}
