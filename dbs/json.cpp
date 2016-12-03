#include "!stdafx.h"
#include "iDbs.h"

void dbs::Node::json(ostream & out, bool pretty)
{
    auto space = pretty ? " " : "";
    out << '[' << x << ',' << space << y << ',' << space << bulge << ']';
}

void dbs::Path::json(ostream & out, bool pretty)
{
    bool first = true;
    out << '[';
    for (auto & node : nodes)
    {
        if (!first)
            out << ',';
        if (pretty)
            out << "\n  ";
        first = false;
        node.json(out, pretty);
    }
    out << ']';
}

/** \brief Quote string according to JSON rules
 *
 * \param src const string&
 * \return const string
 *
 */
const string dbs::Part::quote(const string & src)
{
    ostringstream dst;
    dst << '"';
    size_t i = 0;
    for (;;)
    {
        auto j = src.find_first_of("\r\n\"\\", i);
        if (src.npos == j)
            break;
        dst << src.substr(i, j - i) << '\\';
        i = j + 1;
        char c = src[j];
        switch (c)
        {
        case '\r': c = 'r'; break;
        case '\n': c = 'n'; break;
        }
        dst << c;
    }
    dst << src.substr(i, src.npos) << '"';
    return dst.str();
}

void dbs::Part::json(ostream & out, bool pretty)
{
    bool first = true;
    auto eol = pretty ? "\n  " : "";
    auto space = pretty ? " " : "";
    out << '{' << eol << "\"partid\":" << space << quote(name).c_str() << "," << eol << "\"paths\":" << space << '[';
    for (auto & path : paths)
    {
        if (!first)
            out << ',';
        out << eol;
        first = false;
        path.json(out, pretty);
    }
    if (pretty)
        out << '\n';
    out << "]}";
}

/** \brief Outputs geometry as JSON
 *
 * \param out ostream&
 * \param pretty bool
 * \return void
 *
 * When pretty = false outputs compact (one line) JSON.
 *
 * Otherwise - multiline (formatted) JSON.
 */
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
    if (pretty)
        out << '\n';
}
