#include "Dbs.h"

bool dbs::Path::closed() const
{
    return nodes.size() > 1 && nodes[0].to_p() == nodes[nodes.size() - 1].to_p();
}
