#include "stdafx.h"
#include "iDbs.h"

void dbs::i::R26::rtrim(string& s)
{
    s.erase(s.find_last_not_of(" \n\r\t") + 1);
}

void dbs::i::R26::swap(string& s)
{
    size_t n = s.length() / 2;
    for (size_t i = 0; i < n; i++)
        std::swap(s[2 * i], s[2 * i + 1]);
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
