#pragma once

static_assert(2 == sizeof(short), "Invalid short int!");

namespace dbs {
    namespace i
    {
        struct Base
        {
            short length;

            size_t size() const
            {
                return (length + 1) * 4;
            }

            bool eof() const
            {
                return length < 0;
            }
        };

        struct Rec : Base
        {
            short _01, length2, _02, kind, _03;
        };

        struct alignas(4) Rid : Rec
        {
            short id, _04;
        };

        struct alignas(4) R1 : Rid
        {
            short subType, _05, isText, _06, isAuto, _07, group, _08, orig, _09, rev, _0A;
            dbs::O2 o2;
        };
    }
}
