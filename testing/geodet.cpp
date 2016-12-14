#include "!stdafx.h"
#include "iDbs.h"

const std::string geodet()
{
    std::string res = "testing/geodet";
    for(size_t i = 0; i < 4; i++, res = "../" + res)
    {
        if(dbs::i::is_folder(res))
            return res + "/";
    }
    throw std::runtime_error("GEODET not found!");
}
