#pragma once

using namespace std;

namespace dbs
{
  class Error : runtime_error
  {
  public:
      Error(const string& message) : runtime_error(message) {}
  };

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
