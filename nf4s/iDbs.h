#pragma once

static_assert(2 == sizeof(short), "Invalid short int!");

namespace dbs {
    namespace i
    {
        // Base record
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

        // Minimal non-trivial record
        struct Rec : Base
        {
            short _01, length2, _02, kind, _03;
        };

        // Record with ID
        struct Rid : Rec
        {
            short id, _04;
        };

        // Record 1: geometry
        struct R1 : Rid
        {
            short subType, _05, isText, _06, isAuto, _07, group, _08, orig, _09, rev, _0A;
            dbs::O2 o2;
            dbs::Node nodes[];
        };

        // Record 8: details' contours
        struct R8 : Rid
        {
            struct{
                short id, _;
            } ids[];
        };

        // Record 26: detail name
        struct R26 : Rid
        {
            char name[8];
        };

        // Record 27: detail area & perimeter
        struct R27 : Rid
        {
            float S, P;
        };
    }
}
