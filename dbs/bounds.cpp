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

const Rect Span::bounds() const
{
    Rect bounds(a);
    bounds += b;

    Complex s[2];
    Complex c[2];
    s[0] = to_c();
    s[1] = -s[0];
    c[0] = Complex(1, bulge);
    c[1] = c[0] * c[0];
    c[0] = conj(c[1]);
    for(size_t i = 0; i < 2; i++)
        c[i] *= s[i];
    float * ps = (float*)&s;
    float * pc = (float*)&c;
    int out = 0;
    for(size_t i = 0; i < 2; i++)
        for(int j = 1; j <= 2; j <<= 1, ps++, pc++)
            if(*pc > 0 && *ps <= 0)
              out |= j << 2;    // Adjust .max
            else if(*pc < 0 && *ps >= 0)
              out |= j;         // Adjust .min
    if(!out) return bounds;
    float r = radius();
    c[0] = c[1] = center();
    ps = (float*)&bounds;
    pc = (float*)&c;
    for(size_t i = 0; out; out >>= 1, ps++, pc++, i++)
    {
        if(2 == i) r = -r;
        if(out & 1) *ps = *pc - r;
    }
    return bounds;
}

const Rect Path::bounds() const
{
    Rect r;
    for(auto all = spans(); auto span = all.get(); r += span->bounds());
    return r;
}

const Rect Part::bounds() const
{
    Rect r;
    for(auto & path: paths) r+= path.bounds();
    return r;
}

const Rect File::bounds() const
{
    Rect r;
    for(auto & part: parts) r+= part.bounds();
    return r;
}
