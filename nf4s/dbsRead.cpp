#include <fstream>

#include "Dbs.h"
#include "iDbs.h"

void dbs::File::read(string name)
{
    ifstream src;
    src.exceptions(ifstream::failbit | ifstream::eofbit | ifstream::badbit);
    src.open(name, src.binary);
    dbs::i::Loader z(*this);
    z.load(src);
}

void dbs::i::Loader::read2(size_t sz)
{
    size_t prev = buffer.size();
    if (sz < prev)
        prev = 0, buffer.erase();
    buffer.resize(sz);
    raw = (char*)buffer.data();
    src->read(raw + prev, sz - prev);
}

void dbs::i::Loader::skip2(size_t sz)
{
    src->ignore(sz - buffer.size());
}

void dbs::i::Loader::load(ifstream& source)
{
    src = &source;
    while(true)
    {
        read2(sizeof(dbs::i::Base));
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
}

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

void dbs::i::Loader::parse1()
{
    Path path;
    size_t count = (r1->size() - sizeof(*r1)) / sizeof(r1->nodes[0]);
    for (size_t i = 0; i < count; i++)
        path.nodes.push_back(r1->o2 * r1->nodes[i]);
    iPaths[r1->id] = paths.size();
    paths.push_back(path);
}

void dbs::i::Loader::parse8()
{
    vector<short> ref;
    size_t count = (r8->size() - sizeof(*r8)) / sizeof(r8->ids[0]);
    for (size_t i = 0; i < count; i++)
        ref.push_back(r8->ids[i].id);
    iRefs[r8->id] = refs.size();
    refs.push_back(ref);
}

void dbs::i::Loader::parse26()
{
    Part part;
    part.name = r26->name();
    iParts[r26->id] = dst.parts.size();
    dst.parts.push_back(part);
}

void dbs::i::R26::rtrim(string& s)
{
    s.erase(s.find_last_not_of(" \n\r\t") + 1); 
}

void dbs::i::R26::swap(string& s)
{
    size_t n = s.length() / 2;
    for (size_t i = 0; i < n; i += 2)
        std::swap(s[i], s[i + 1]);
}

void dbs::i::R26::name(string s)
{
    s.erase(sizeof(partid), string::npos);
    rtrim(s);
    s.resize(sizeof(partid), ' ');
    swap(s);
    memcpy(partid, s.c_str(), sizeof(partid));
}

string dbs::i::R26::name() const
{
    string res;
    res.resize(sizeof(partid));
    memcpy((char*)res.c_str(), partid, sizeof(partid));
    swap(res);
    rtrim(res);
    return res;
}
