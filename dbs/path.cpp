#include "Dbs.h"

bool dbs::Path::closed() const
{
    return nodes.size() > 1 && nodes[0].to_p() == nodes[nodes.size() - 1].to_p();
}

void dbs::Path::reverse()
{
    if (nodes.size() < 2)
        return;
    for (int i = 0, j = nodes.size() - 1; i < j; i++, j--)
        std::swap(nodes[i].to_p(), nodes[j].to_p());
    for (int i = 0, j = nodes.size() - 2; i < j; i++, j--)
        std::swap(nodes[i].bulge, nodes[j].bulge);
    for (auto & node : nodes)
        node.bulge = -node.bulge;
}
