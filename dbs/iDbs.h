#pragma once

#include <map>
#include <fstream>

#include "Dbs.h"

static_assert(2 == sizeof(short), "Invalid short int!");

namespace dbs {
    namespace i
    {
        bool is_folder(const std::string&);

        /// Minimal DBS record
        struct Rec
        {
            short length, _01, length2, _02, kind, _03, id, _04;

            size_t size() const
            {
                return (length + 1) * 4;
            }

            bool eof() const
            {
                return length < 0;
            }

            void on_write();
        };

        /// Record 2: geometry clone
        struct R2 : Rec
        {
            short subType, _05, isText, _06, isAuto, _07, group, _08, orig, _09, rev, _0A;
            dbs::O2 o2;
        };

        /// Record 1: path geometry
        struct R1 : R2
        {
            /** \brief Number of Nodes in path
             *
             * \return const size_t
             *
             */
            size_t count() const { return (size() - sizeof(*this)) / sizeof(*nodes()); }

            /** \brief Pointer to first Node
             *
             * \return dbs::Node *
             *
             */
            dbs::Node * nodes() const { return (dbs::Node*)(this + 1); };
        };

        /// Path ID inside R8
        struct R8id
        {
            short id, _;
        };

        /// Record 8: details' contours
        struct R8 : Rec
        {
            /** \brief Number of path ids in record
             *
             * \return const size_t
             *
             */
            size_t count() const { return (size() - sizeof(*this)) / sizeof(*ids()); }

            /** \brief Pointer to first path id
             *
             * \return R8id *
             *
             */
            R8id *ids() const { return (R8id*)(this + 1); };
        };

        /// Record 26: detail name
        struct R26 : Rec
        {
            char partid[8];

            string name() const;
            void name(string);

            static void swap(string&);
            static void rtrim(string&);
        };

        /// Record 27: detail area & perimeter (ignored on read), measured in decimeters (!)
        struct R27 : Rec
        {
            float S, P;
        };

        /// Record 27: part's notes (i`gnored on read so far)
        struct R28 : Rec
        {
            /** \brief Number of characters in note text
             *
             * \return const size_t
             *
             */
            size_t count() const { return (size() - sizeof(*this)) / sizeof(*notes()); }

            /** \brief Link to notes text
             *
             * \return char *
             *
             * - Seems to be \\0 - padded
             * - Encoding: Windows-1251 (ANSI)
             */
            char *notes() const { return (char*)(this + 1); };
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
                R28* r28;
            };
            void (Loader::*dispatcher()const)();

            vector <Path> paths;
            vector <vector<short>> refs;
            map <short, size_t> iPaths, iParts, iRefs;

            Loader(dbs::File& dbs) : dst(dbs) {};
            void load(ifstream&);

            void read2(size_t);
            void skip2(size_t);

            void parse1();
            void parse8();
            void parse26();
        };

        /// Reader for .KOL job-files
        struct Kol
        {
            istream& src;
            std::string dbs;    //< Path to DBS-file
            size_t  count;      //< Number of copies
            bool    list;       //< Is a list?

            Kol(istream& source) : src(source) {}

            bool next();
        };
    }
}
