#include "iDbs.h"

void dbs::Path::yaml(ostream & out)
{
    out << "  - # " << nodes.size() << " nodes\n";
    for (auto & n : nodes)
    {
        out << "    - ";
        n.yaml(out);
        out << '\n';
    }
}

void dbs::Part::yaml(ostream & out)
{
    out << "  partid: " << quote(name).c_str() << "\n";
    out << "  paths: # " << paths.size() << "\n";
    for (auto & p : paths)
        p.yaml(out);
}

void dbs::File::yaml(ostream & out)
{
    for (auto & p : parts)
    {
        out << "-\n";
        p.yaml(out);
    }
}
