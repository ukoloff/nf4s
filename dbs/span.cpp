#include "!stdafx.h"
#include "Dbs.h"

using namespace dbs;

/** \brief Get arc's radius
 *
 * \return const float
 *
 * Returns the radius of the circle the arc belongs to.
 *
 * If span is linear (not arc) returns infinity.
 */
const float dbs::Span::radius() const
{
    return abs(to_c()) * abs(1 / bulge + bulge) /4 ;
}

/** \brief Find point on arc
 *
 * \param pos float
 * \return const Complex
 *
 * Maps -1 to begin of arc, 0 to middle of arc and +1 to its end.
 *
 * For big bulge values, resulting points will be distributed
 * to the ends of arc.
 *
 * More uniform distribution is provided with dbs::Span::at method.
 *
 */
const Complex dbs::Span::operator[](float pos) const
{
    return linear(Complex(pos, -bulge) / Complex(1, -pos*bulge));
}

/** \brief Return center of the arc
 *
 * \return const Complex
 *
 * Return center of the circle, the arc is part of.
 *
 * If span is linear (not arc) returns infinity.
 */
const Complex dbs::Span::center() const
{
    return linear(Complex(0, (1 / bulge - bulge) / 2));
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
    auto q = (sqrt(9 + 8 * bulge * bulge) + 1) / 4;
    return (*this)[pos / (q - (q-1) * pos * pos)];
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

double dbs::Span::perimeter() const
{
  double res = abs(to_c());
  if(isArc())
    res *= (atan(bulge) / bulge) * (1 + square(bulge));
  return res;
}

double dbs::Span::area() const
{
  double res = (b.x * a.y - b.y * a.x) / 2;
  if(isArc())
    res -= (atan(bulge) * square(1 + square(bulge)) - (1 - square(bulge)) * bulge) / square(bulge) / 8 *
      square(abs(to_c()));
  return res;
}

void dbs::Span::svg(ostream & out, bool first) const
{
    if(first)
        out << "M " << a.x << " " << a.y << "\n";
    if(!isArc())
    {
        if (a.x == b.x)
            out << "V " << b.y;
        else if (a.y == b.y)
            out << "H " << b.x;
        else
            out << "L " << b.x << " " << b.y;
        return;
    }
    size_t n = abs(bulge) >= 1;
    dbs::P ends[2];
    ends[0] = b;
    if (n)
        ends[1].to_c() = zenith();
    int nn = 0;
    auto r = radius();
    do 
        out << (nn++ ? " " : "") << "A "
        << r << " " << r        // rx ry
        << " 0 0 "              // x-axis-rotation large-arc-flag
        << (bulge > 0) << " "   // sweep-flag
        << ends[n].x << " " << ends[n].y;
    while (n--);
}
