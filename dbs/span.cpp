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

/** \brief Find point on the arc with more uniform distribution (compared to [])
 *
 * \param pos float
 * \return const Complex
 *
 * Maps -1 to arc's begin, 0 to middle of arc, +1 to ark's end.
 *
 * Other points from [-1, +1] are mapped to arc's points.
 *
 * Resulting distribution is as much uniform as possible,
 * whereas []'s points tend to concentrate near arc's ends
 * (for big bulge values).
 */
const Complex dbs::Span::at(float pos) const
{
    auto q = sqrt(1 + bulge * bulge);
    return (*this)[pos / (q - (q-1) * abs(bulge))];
}

/** \brief Get real coordinates of point around arc
 *
 * \param pos
 *  Complex Source point in abstract space
 * \return const Complex
 *  Destination points in arc's space
 *
 * Maps -1 to Arc's begin, +1 to Arc's end,
 * otherwise perform linear transformation.
 */
const Complex dbs::Span::linear(Complex pos) const
{
  return (to_c() * pos + a.to_c() + b.to_c()) / (float)2;
}

/** \brief Return middle point on the arc (most prominent)
 *
 * \return const Complex
 *
 */
const Complex dbs::Span::zenith() const
{
    return linear(Complex(0, -bulge));
}

/** \brief Return the middle of alternative arc
 *
 * \return const Complex
 *
 * This points is not on the arc, it is far in space on another side...
 */
const Complex dbs::Span::nadir() const
{
    return linear(Complex(0, 1 / bulge));
}

