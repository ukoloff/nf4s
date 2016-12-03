#include "!stdafx.h"
#include "iDbs.h"

/** \brief Trim whitespaces from the end of string
 *
 * \param s string&
 * \return void
 *
 */
void dbs::i::R26::rtrim(string& s)
{
    s.erase(s.find_last_not_of(" \n\r\t") + 1);
}

/** \brief Swap chars in pairs
 *
 * \param s string&
 * \return void
 *
 * Record 26 has PARTID in unusual character order: 21436587
 *
 * This method performs such a permutation.
 */
void dbs::i::R26::swap(string& s)
{
    size_t n = s.length() / 2;
    for (size_t i = 0; i < n; i++)
        std::swap(s[2 * i], s[2 * i + 1]);
}

/** \brief Set (assign) name (PARTID)
 *
 * \param s string
 * \return void
 *
 */
void dbs::i::R26::name(string s)
{
    s.erase(sizeof(partid), string::npos);
    rtrim(s);
    s.resize(sizeof(partid), ' ');
    swap(s);
    memcpy(partid, s.c_str(), sizeof(partid));
}

/** \brief Retrieve PARTID
 *
 * \return string
 *
 */
string dbs::i::R26::name() const
{
    string res;
    res.resize(sizeof(partid));
    memcpy((char*)res.c_str(), partid, sizeof(partid));
    swap(res);
    rtrim(res);
    return res;
}
