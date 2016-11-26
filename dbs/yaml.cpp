#include "iDbs.h"

void dbs::Path::yaml(ostream & out)
{
    out << "  -\t\t# " << nodes.size() << " nodes\n";
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
    out << "  paths:\t# " << paths.size() << "\n";
    for (auto & p : paths)
        p.yaml(out);
}

void dbs::File::yaml(ostream & out)
{
    out << "-\n";
    for (auto & p : parts)
        p.yaml(out);
}
