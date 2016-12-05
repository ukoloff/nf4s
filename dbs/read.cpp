#include "!stdafx.h"
#include "iDbs.h"

/** \mainpage DBS Library
<a href="https://github.com/ukoloff/nf4s" target="_blank">Source repo</a>.
 */

/** \brief Read DBS file
 *
 * \param name string
 * \return void
 *
 */
void dbs::File::read(string name)
{
    ifstream src;
    src.exceptions(ifstream::failbit | ifstream::eofbit | ifstream::badbit);
    src.open(name, src.binary);
    dbs::i::Loader z(*this);
    z.load(src);
}

/** \brief Read stream up to specified position
 *
 * \param sz size_t
 * \return void
 *
 */
void dbs::i::Loader::read2(size_t sz)
{
    size_t prev = buffer.size();
    if (sz < prev)
        prev = 0, buffer.erase();
    buffer.resize(sz);
    raw = (char*)buffer.data();
    src->read(raw + prev, sz - prev);
}

/** \brief Seek stream to specified position
 *
 * \param sz size_t
 * \return void
 *
 */
void dbs::i::Loader::skip2(size_t sz)
{
    src->ignore(sz - buffer.size());
}

/** \brief Load DBS file from stream
 *
 * \param source ifstream&
 * \return void
 *
 */
void dbs::i::Loader::load(ifstream& source)
{
    src = &source;
    while(true)
    {
        read2(sizeof(rec->length));
        if (rec->eof())
            break;
        size_t sz = rec->size();
        if (sz < sizeof(*rec))
            throw dbs::Error("Record too short!");
        read2(sizeof(*rec));
        if(rec->length2 != rec->length)
            throw dbs::Error("Record length mismatch!");
        dispatch();
        if(!dispatcher)
        {
            skip2(sz);
            continue;
        }
        read2(sz);
        (this->*dispatcher)();
    }
    // combine dst.parts from paths + refs
    for(auto const& z: iRefs)
    {
        Part* part;
        if (!iParts.count(z.first))
        {
            ostringstream partid;
            partid << "#" << z.first;
            Part prt;
            prt.name = partid.str();
            iParts[z.first] = dst.parts.size();
            dst.parts.push_back(prt);
        }
        part = &dst.parts[iParts[z.first]];
        for (auto& id : refs[z.second])
        {
            if (!iPaths.count(id))
                throw dbs::Error("PathID not found!");
            part->paths.push_back(paths[iPaths[id]]);
        }
    }
}

/** \brief Find record parser for record type
 *
 * \return void
 *
 */
void dbs::i::Loader::dispatch()
{
    switch (rec->kind)
    {
    case 1:
        dispatcher = &Loader::parse1;
        break;
    case 8:
        dispatcher = &Loader::parse8;
        break;
    case 26:
        dispatcher = &Loader::parse26;
        break;
    default:
        dispatcher = 0;
    }
}

/** \brief Parse record 1 (geometry)
 *
 * \return void
 *
 */
void dbs::i::Loader::parse1()
{
    Path path;
    auto node = r1->nodes();
    for (size_t i = 0; i < r1->count(); i++, node++)
        path.nodes.push_back(r1->o2 * *node);
    if (r1->rev)
        path.reverse();
    iPaths[r1->id] = paths.size();
    paths.push_back(path);
}

/** \brief Parse record 8 (list of paths)
 *
 * \return void
 *
 */
void dbs::i::Loader::parse8()
{
    vector<short> ref;
    auto ids = r8->ids();
    for (size_t i = 0; i < r8->count(); i++, ids++)
        ref.push_back(ids->id);
    iRefs[r8->id] = refs.size();
    refs.push_back(ref);
}

/** \brief Parse record 26 (part name)
 *
 * \return void
 *
 */
void dbs::i::Loader::parse26()
{
    Part part;
    part.name = r26->name();
    iParts[r26->id] = dst.parts.size();
    dst.parts.push_back(part);
}
