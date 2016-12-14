#include "!stdafx.h"
#include "iDbs.h"

bool dbs::i::Kol::next()
{
    const char * ws = " \t\r\n";
    std::string line;
    while(std::getline(src, line))
    {
        auto i = line.find_last_not_of(ws);
        if (string::npos == i)
            continue;
        line.resize(i + 1);
        i = line.find_last_of(ws);
        if (string::npos == i)
            continue;
        list = "0" == line.substr(i + 1);
        line.resize(i);
        i = line.find_last_not_of(ws);
        if (string::npos == i)
            continue;
        line.resize(i + 1);
        i = line.find_last_of(ws);
        if (string::npos == i)
            continue;
        try{
            count = std::stoi(line.substr(i));
        }
        catch(...)
        {
            continue;
        }
        line.resize(i);
        i = line.find_last_not_of(ws);
        if (string::npos == i)
            continue;
        line.resize(i + 1);
        dbs = line;
        return true;
    }
    return false;
}
