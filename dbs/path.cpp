#include "!stdafx.h"
#include "Dbs.h"

/** \brief
 *
 * \return dbs::iSpan
 *
 * Initialize and return span iterator
 */
dbs::iSpan dbs::Path::spans() const
{
    dbs::iSpan res(*this);
    return res;
}

/** \brief Is Path closed?
 *
 * \return bool
 *
 * Returns true if last point of Path is exactly equal to the first one.
 */
bool dbs::Path::closed() const
{
    return nodes.size() > 1 && nodes[0].to_p() == nodes[nodes.size() - 1].to_p();
}

/** \brief Reverts the Path
 *
 * \return void
 *
 * Reorders Nodes in Path (in place) so it goes in opposite direction.
 */
void dbs::Path::reverse()
{
    if (nodes.size() < 2)
        return;
    for (size_t i = 0, j = nodes.size() - 1; i < j; i++, j--)
        std::swap(nodes[i].to_p(), nodes[j].to_p());
    for (size_t i = 0, j = nodes.size() - 2; i < j; i++, j--)
        std::swap(nodes[i].bulge, nodes[j].bulge);
    for (auto & node : nodes)
        node.bulge = -node.bulge;
}

double dbs::Path::perimeter() const
{
  double res = 0;
  for(auto i = spans(); auto span = i.get(); )
    res += span->perimeter();
  return res;
}

double dbs::Path::area() const
{
  if(!closed())
    return 0;
  double res = 0;
  for(auto i = spans(); auto span = i.get(); )
    res += span->area();
  return res;
}

double dbs::Part::perimeter() const
{
  double res = 0;
  for(auto & path : paths)
    res += path.perimeter();
  return res;
}

double dbs::Part::area() const
{
  double res = 0;
  for(auto & path : paths)
    res += path.area();
  return res;
}

