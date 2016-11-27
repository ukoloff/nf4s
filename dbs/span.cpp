#include "Dbs.h"

using namespace dbs;

Span * dbs::iSpan::get()
{
    if (next + 1 >= path.nodes.size())
        return 0;
    return (dbs::Span*)&path.nodes[next++];
}

const float dbs::Span::radius() const
{
    return abs(to_c()) * abs(1 / bulge + bulge) /4 ;
}

const Complex dbs::Span::operator[](float pos) const
{
    return linear(Complex(pos, -bulge) / Complex(1, -pos*bulge));
}

const Complex dbs::Span::center() const
{
    return linear(Complex(0, 1 / bulge - bulge));
}

const Complex dbs::Span::at(float pos) const
{
    auto q = sqrt(1 + bulge * bulge);
    return (*this)[pos / (q - (q-1) * abs(bulge))];
}

const Complex dbs::Span::linear(Complex pos) const
{
  return (to_c() * pos + a.to_c() + b.to_c()) / (float)2;
}
