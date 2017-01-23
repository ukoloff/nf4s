#include "!stdafx.h"
#include "Dbs.h"

void dbs::Node::algomate(ostream & out) const
{
    out << "VERTEX:\t" << x << "\t" << y << "\t" << bulge << "\n";
}

void dbs::Path::algomate(ostream & out) const
{
    size_t n = nodes.size();
    if(isClosed()) n--;
    out << "VERTQUANT:\t" << n << "\n";
    for(size_t i = 0; i < n; i++)
        nodes[i].algomate(out);
}

/** \brief Output source for Algomate's Nesting Factory
 *
 * \param out ostream&
 * \return void
 *
 * Text of source file for nesting
 */
void dbs::Part::algomate(ostream & out) const
{
    out << "ITEMNAME:\t" << name.c_str() << "\n";
    for(auto & path: paths)
        path.algomate(out);
}

/** \brief Output source for Algomate's Nesting Factory
 *
 * \param out ostream&
 * \return void
 *
 * In general, dbs::Part::algomate should be used
 *
 * This methods should be used only if parts.size()==1
 */
void dbs::File::algomate(ostream & out) const
{
    for(auto & part: parts)
        part.algomate(out);
}
