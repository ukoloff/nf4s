#include "Dbs.h"

dbs::Span * dbs::iSpan::get()
{
    if (next >= path.nodes.size())
        return 0;
    return (dbs::Span*)&path.nodes[next++];
}

const float dbs::Span::radius() const
{
    return abs(to_c())*(1 + bulge*bulge) / 4 / bulge;
}

const complex<float> dbs::Span::operator[](float pos) const
{
    return to_c()*complex<float>(pos, bulge) / complex<float>(1, pos*bulge) / complex<float>(2) + a.to_c();
}
