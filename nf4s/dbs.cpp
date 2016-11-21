#include <fstream>

#include "Dbs.h"

void dbs::File::read(string name)
{
    ifstream src;
    src.exceptions(ifstream::failbit | ifstream::eofbit | ifstream::badbit);
    src.open(name);
}

double dbs::O2::det(void) const
{
    return x.x * y.y - x.y * y.x;
}


dbs::P dbs::O2::operator*(const dbs::P& p)
{
    dbs::P z;
    z.x = x.x * p.x + y.x * p.y + delta.x;
    z.y = x.y * p.x + y.y * p.y + delta.y;
    return z;
}

dbs::Node dbs::O2::operator*(const dbs::Node& node)
{
    dbs::Node z;
    (dbs::P)z = (*this) * (dbs::P)node;
    z.bulge = det() > 0 ? node.bulge : -node.bulge;
    return z;
}
