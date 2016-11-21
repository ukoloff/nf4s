#pragma once

static_assert(2 == sizeof(short), "Invalid short int!");

using namespace std;

namespace dbs
{
  struct P
  {
      float x, y;
  };

  struct Node: P
  {
      float bulge;
      void dump();
  };

  struct O2
  {
      P x, y, delta;

      double det() const;
      P operator * (const P& p) const;
      Node operator * (const Node& n) const;
  };

  struct File
  {
    static void read(std::string name);
  };
}
