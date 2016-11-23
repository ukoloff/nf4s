#include <iostream>
#include <fstream>

#include "Dbs.h"
#include "iDbs.h"

typedef void (*parser)(dbs::i::Rec&);
static void parse1(dbs::i::Rec&);
static void parse8(dbs::i::Rec&);
static void parse26(dbs::i::Rec&);

void dbs::File::read(string name)
{
    ifstream src;
    string buf;
    //src.exceptions(ifstream::failbit | ifstream::eofbit | ifstream::badbit);
    src.open(name, src.binary);
    while(true)
    {
        buf.resize(sizeof(dbs::i::Base));
        dbs::i::Base* base = (dbs::i::Base*)buf.data();
        src.read((char*)base, sizeof(dbs::i::Base));
        if (base->eof())
            break;
        size_t sz = base->size();
        if (sz < sizeof(dbs::i::Rec))
            throw dbs::Error("Record too short!");
        buf.resize(sizeof(dbs::i::Rec));
        dbs::i::Rec* rec = (dbs::i::Rec*)buf.data();
        src.read((char*)((dbs::i::Base*)rec + 1), sizeof(dbs::i::Rec) - sizeof(dbs::i::Base));
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
        buf.resize(sz);
        rec = (dbs::i::Rec*)buf.data();
        src.read((char*)(rec + 1), sz - sizeof(*rec));
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
