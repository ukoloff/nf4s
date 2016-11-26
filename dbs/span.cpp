#include "Dbs.h"

using namespace dbs;

Span * dbs::iSpan::get()
{
    if (next >= path.nodes.size())
        return 0;
    return (dbs::Span*)&path.nodes[next++];
}

const float dbs::Span::radius() const
{
    return abs(to_c())*(1 + bulge*bulge) / 4 / abs(bulge);
}

const Complex dbs::Span::operator[](float pos) const
{
    return to_c() * Complex(pos, bulge) / Complex(1, pos*bulge) / Complex(2) + a.to_c();
}
