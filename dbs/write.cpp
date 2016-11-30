#include "stdafx.h"
#include "iDbs.h"

void dbs::i::Rec::on_write()
{
    _01 = id;
    length2 = length;
}