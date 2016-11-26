#include <iostream>
#include <sstream>

#include "Dbs.h"

double dbs::O2::det(void) const
{
    return x.x * y.y - x.y * y.x;
}


dbs::P dbs::O2::operator*(const dbs::P& p) const
{
    dbs::P z;
    z.x = x.x * p.x + y.x * p.y + delta.x;
    z.y = x.y * p.x + y.y * p.y + delta.y;
    return z;
}

dbs::Node dbs::O2::operator*(const dbs::Node& node) const
{
    dbs::Node z;
    dbs::P* p = &z;
    *p = (*this) * *(dbs::P*)&node;
    z.bulge = det() > 0 ? node.bulge : -node.bulge;
    return z;
}

void dbs::Path::yaml(ostream & out)
{
    out << "  -\t\t# " << nodes.size() << " nodes\n";
    for (auto & n : nodes)
    {
        out << "    - ";
        n.yaml(out);
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

const string dbs::Part::quote(const string & src)
{
    ostringstream dst;
    dst << '"';
    size_t i = 0;
    for(;;)
    {
        auto j = src.find_first_of("\r\n\"\\", i);
        if (src.npos == j)
            break;
        dst << src.substr(i, j - i) << '\\';
        i = j + 1;
        char c = src[j];
        switch(c)
        {
        case '\r': c = 'r'; break;
        case '\n': c = 'n'; break;
        }
        dst << c;
    }
    dst << src.substr(i, src.npos) << '"';
    return dst.str();
}

void dbs::Node::json(ostream & out, bool pretty)
{
    auto space = pretty ? " " : "";
    out << '[' << x << ',' << space << y << ',' << space << bulge << ']';
}

void dbs::Node::yaml(ostream & out)
{
    json(out);
    out << '\n';
}

void dbs::Path::json(ostream & out, bool pretty)
{
    bool first = true;
    out << '[';
    for(auto & node : nodes)
    {
        if (!first)
            out << ',';
        if (pretty)
            out << (first ? " " : "\n  ");
        first = false;
        node.json(out, pretty);
    }
    out << ']';
}

void dbs::Part::json(ostream & out, bool pretty)
{
    bool first = true;
    out << '{';
    for(auto & path : paths)
    {
        if (!first)
            out << ',';
        first = false;
        path.json(out, pretty);
    }
    out << '}';
}

void dbs::File::json(ostream & out, bool pretty)
{
    bool first = true;
    out << '[';
    for (auto & part : parts)
    {
        if (!first)
            out << ',';
        first = false;
        part.json(out, pretty);
    }
    out << ']';
}
