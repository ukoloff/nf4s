#include "stdafx.h"
#include "iDbs.h"

/** \brief Get ready for writing to disk
 *
 * \return void
 *
 * Set some internal fields to be written correctly.
 */
void dbs::i::Rec::on_write()
{
    _01 = id;
    length2 = length;
}
