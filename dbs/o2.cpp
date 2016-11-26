#include "Dbs.h"

double dbs::O2::det(void) const
{
    return x.x * y.y - x.y * y.x;
}

dbs::P dbs::O2::operator*(const dbs::P& p) const
{
    dbs::P z;
    z.x = x.x * p.x + y.x * p.y + delta.x;
    z.y = x.y * p.x + y.y * p.y + delta.y;
    return z;
}

dbs::Node dbs::O2::operator*(const dbs::Node& node) const
{
    dbs::Node z;
    dbs::P* p = &z;
    *p = (*this) * *(dbs::P*)&node;
    z.bulge = det() > 0 ? node.bulge : -node.bulge;
    return z;
}
