#pragma once

#include <complex>
#include <ostream>
#include <vector>

using namespace std;

namespace dbs
{
  class Error : public runtime_error
  {
  public:
      Error(const string & message) : runtime_error(message) {}
  };

  struct P
  {
      float x, y;

      const complex<float> & to_c() const { return *(complex<float>*)this; }

      const auto operator == (const P & p) const { return to_c() == p.to_c(); }
  };

  struct Node: P
  {
      float bulge;

      void json(ostream &, bool pretty = false);
      void yaml(ostream & out) { json(out); }

      P & to_p() const { return *(P*)this; }
  };

  struct O2
  {
      P x, y, delta;

      double det() const;
      P operator * (const P& p) const;
      Node operator * (const Node& n) const;
  };

  struct Path
  {
      vector <Node> nodes;

      void json(ostream &, bool pretty = false);
      void yaml(ostream &);

      bool closed() const;
  };

  struct Part
  {
      string name;
      vector <Path> paths;

      void json(ostream &, bool pretty = false);
      void yaml(ostream&);

      static const string quote(const string&);
  };

  struct File
  {
      vector <Part> parts;

      void read(std::string name);

      void json(ostream &, bool pretty = false);
      void yaml(ostream&);
  };
}
