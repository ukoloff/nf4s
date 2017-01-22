#include "!stdafx.h"
#include "Dbs.h"

using namespace dbs;

const bool Rect::operator == (const Rect & r) const
{
    if(!*this) return !r;
    return min == r.min && max == r.max;
}

Rect& Rect::operator += (float delta)
{
    if(!*this) return *this;
    min.x -= delta;
    min.y -= delta;
    max.x += delta;
    max.y += delta;
    if(min.x > max.x || min.y > max.y)
        min.x = NAN;
    return *this;
}

Rect& Rect::operator += (const P & p)
{
    if(!*this)
    {
        min = max = p;
        return *this;
    }
    if(min.x > p.x) min.x = p.x;
    if(min.y > p.y) min.y = p.y;
    if(max.x < p.x) max.x = p.x;
    if(max.y < p.y) max.y = p.y;
    return *this;
}
Rect& Rect::operator += (const Rect & r)
{
    if(!r) return *this;
    *this += r.min;
    return *this += r.max;
}

Rect Rect::operator + (float delta) const
{
    Rect r(*this);
    return r += delta;
}

Rect Rect::operator + (const P & p) const
{
    Rect r(*this);
    return r += p;
}
Rect Rect::operator + (const Rect & r) const
{
    Rect res(*this);
    return res += r;
}
