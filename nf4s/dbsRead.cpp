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
    src.read(raw + prev, sz - prev);
}

void dbs::i::Loader::load(ifstream &)
{
    while(true)
    {
        read2(sizeof(dbs::i::Base));
        if (rec->eof())
            break;
        size_t sz = base->size();
        if (sz < sizeof(dbs::i::Rec))
            throw dbs::Error("Record too short!");
        read2(sizeof(dbs::i::Rec));
        if(rec->length2 != rec->length)
            throw dbs::Error("Record length mismatch!");
        parser pr;
        switch(rec->kind)
        {
        case 1:
            pr = parse1;
            break;
        case 8:
            pr = parse8;
            break;
        case 26:
            pr = parse26;
            break;
        default:
            src.seekg(sz - sizeof(*rec), ios_base::cur);
            continue;
        }
        read2(sz);
        (*pr)(*rec);
    }
}

static void parse1(dbs::i::Rec&)
{
}

static void parse8(dbs::i::Rec&)
{
}

static void parse26(dbs::i::Rec&)
{
}
