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
}

void dbs::i::Loader::parse8()
{
}

void dbs::i::Loader::parse26()
{
}