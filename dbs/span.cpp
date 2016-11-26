#include "Dbs.h"

dbs::Span * dbs::iSpan::get()
{
    if (next >= path.nodes.size())
        return 0;
    return (dbs::Span*)&path.nodes[next++];
}