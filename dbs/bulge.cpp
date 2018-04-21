#include "!stdafx.h"
#include "Dbs.h"

using namespace dbs;

// Calculate tan(arg(sqrt(pt)))
static double tgq(const Complex& pt) {
  return pt.real() < 0 ? (abs(pt) - pt.real()) / pt.imag()
                       : pt.imag() / (abs(pt) + pt.real());
}

/** \brief Find bulge for ark passing thru point
 *
 * \param pt const dbs::Complex&
 * \return double
 *
 */
double dbs::Span::bulgeOf(const dbs::Complex& pt) const {
  return tgq(conj(pt - a.to_c()) * (b.to_c() - pt));
}

/** \brief Find position on the arc for the point
 *
 * \param pt const dbs::Complex&
 * \return double
 *
 * Reverse function for [] operator
 */
double dbs::Span::indexOf(const dbs::Complex& pt) const {
  auto da = abs(a.to_c() - pt);
  auto db = abs(b.to_c() - pt);
  return (da - db) / (da + db);
}

/** \brief Find bulge for right sub-ark
 *
 * \param pos float
 * \return double
 *
 * Break ark at that position (as in [])
 * and find bulge for right sub-ark
 *
 * bulgeRight(pos) = bulgeLeft(-pos)
 */
double dbs::Span::bulgeRight(float pos) const {
  return tgq(Complex(1, bulge) * Complex(1, -bulge * pos));
}
