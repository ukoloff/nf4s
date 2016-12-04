#include "!stdafx.h"
#include "Dbs.h"

void dbs::Node::algomate(ostream & out)
{
    out << "VERTEX:\t" << x << "\t" << y << "\t" << bulge << "\n";
}

void dbs::Path::algomate(ostream & out)
{
    size_t n = nodes.size();
    if(closed()) n--;
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
void dbs::Part::algomate(ostream & out)
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
void dbs::File::algomate(ostream & out)
{
    for(auto & part: parts)
        part.algomate(out);
}
