#pragma once

#include <map>
#include <fstream>

#include "Dbs.h"

static_assert(2 == sizeof(short), "Invalid short int!");

namespace dbs {
    namespace i
    {
        /// Minimal DBS record
        struct Rec
        {
            short length, _01, length2, _02, kind, _03;

            size_t size() const
            {
                return (length + 1) * 4;
            }

            bool eof() const
            {
                return length < 0;
            }
        };

        /// DBS record with ID (in fact, any record)
        struct Rid : Rec
        {
            short id, _04;
        };

        /// Record 2: geometry clone
        struct R2 : Rid
        {
            short subType, _05, isText, _06, isAuto, _07, group, _08, orig, _09, rev, _0A;
            dbs::O2 o2;
        };

        /// Record 1: path geometry
        struct R1 : R2
        {
            dbs::Node nodes[];
        };

        /// Record 8: details' contours
        struct R8 : Rid
        {
            struct{
                short id, _;
            } ids[];
        };

        /// Record 26: detail name
        struct R26 : Rid
        {
            char partid[8];

            string name() const;
            void name(string);

            static void swap(string&);
            static void rtrim(string&);
        };

        /// Record 27: detail area & perimeter (ignored on read)
        struct R27 : Rid
        {
            float S, P;
        };

        /// Read DBS file
        struct Loader {
            ifstream* src;
            dbs::File& dst;
            string buffer;
            union
            {
                char* raw;
                Rec* rec;
                R1* r1;
                R8* r8;
                R26* r26;
            };
            void (Loader::*dispatcher)();

            vector <Path> paths;
            vector <vector<short>> refs;
            map <short, size_t> iPaths, iParts, iRefs;

            Loader(dbs::File& dbs) : dst(dbs) {};
            void load(ifstream&);

            void read2(size_t);
            void skip2(size_t);

            void dispatch();

            void parse1();
            void parse8();
            void parse26();
        };
    }
}
