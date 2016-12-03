#include "!stdafx.h"

const std::string geodet()
{
    std::string res = "testing/geodet";
    for(size_t i = 0; i < 4; i++, res = "../" + res)
    {
        struct stat st;
        if(stat(res.c_str(), &st))
            continue;
        if(st.st_mode | S_IFDIR)
            return res + "/";
    }
    throw std::runtime_error("GEODET not found!");
}
