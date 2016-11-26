#include "iDbs.h"

void dbs::Node::dxf(ostream & out)
{
    out << "  0\nVERTEX\n 10\n" << x << "\n 20\n" << y;
    if (bulge != 0)
        out << "\n 42\n" << -bulge;
    out << "\n  8\n0\n";
}

void dbs::Path::dxf(ostream & out)
{
    out << "  0\nPOLYLINE\n 10\n0.0\n 20\n0.0\n 30\n0.0\n  8\n0\n 66\n1\n";
    size_t last = nodes.size();
    if (closed())
    {
        out << " 70\n1\n";
        last--;
    }
    for (int i = 0; i < last; i++)
        nodes[i].dxf(out);
    out << "  0\nSEQEND\n";
}

void dbs::Part::dxf(ostream & out)
{
    for (auto & path : paths)
        path.dxf(out);
}

void dbs::File::dxf(ostream & out)
{
    out << "  0\nSECTION\n  2\nENTITIES\n";
    for (auto & part : parts)
        part.dxf(out);
    out << "  0\nENDSEC\n  0\nEOF\n";
}
