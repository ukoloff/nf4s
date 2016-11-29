#include "stdafx.h"
#include "Dbs.h"

/** \brief Calculates determinant of transform
 *
 * \return double
 *
 */
double dbs::O2::det() const
{
    return x.x * y.y - x.y * y.x;
}

/** \brief Find new position of point after applying transform
 *
 * \param p const dbs::P&
 * \return dbs::P
 *
 */
dbs::P dbs::O2::operator*(const dbs::P& p) const
{
    dbs::P z;
    z.x = x.x * p.x + y.x * p.y + delta.x;
    z.y = x.y * p.x + y.y * p.y + delta.y;
    return z;
}

/** \brief Apply transform to Node
 *
 * \param node const dbs::Node&
 * \return dbs::Node
 *
 */
dbs::Node dbs::O2::operator*(const dbs::Node & node) const
{
    dbs::Node z;
    z.to_p() = (*this) * node.to_p();
    z.bulge = det() > 0 ? node.bulge : -node.bulge;
    return z;
}
