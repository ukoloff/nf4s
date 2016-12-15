#include "!stdafx.h"
#include "iDbs.h"

bool dbs::i::Kol::next()
{
    std::string line;
    std::regex ws("\\s*");
    std::regex kol("\\s*(.*\\S)\\s+(\\d+)\\s+([01])\\s*");
    while(std::getline(src, line))
    {
        if (std::regex_match(line, ws))
            continue;
        std::smatch match;
        if (!std::regex_match(line, match, kol))
            throw dbs::Error("Invalid KOL file!");
        list = "0" == match[3];
        std::string cnt = match[2];
        count = std::atoi(cnt.c_str());
        dbs = match[1];
        return true;
    }
    return false;
}
