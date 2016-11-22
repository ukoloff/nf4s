#include <fstream>

#include "Dbs.h"
#include "iDbs.h"

void dbs::File::read(string name)
{
    ifstream src;
    string buf;
    src.exceptions(ifstream::failbit | ifstream::eofbit | ifstream::badbit);
    src.open(name);
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
        src.read((char*)(rec + 1), sizeof(dbs::i::Rec) - sizeof(dbs::i::Base));
        if(rec->length2 != rec->length)
            throw dbs::Error("Record length mismatch!");
    }
}
