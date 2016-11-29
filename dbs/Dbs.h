#pragma once

#include <complex>
#include <ostream>
#include <vector>
#include <stdexcept>

using namespace std;

namespace dbs
{
  /// Our errors
  class Error : public runtime_error
  {
  public:
      Error(const string & message) : runtime_error(message) {}
  };

  typedef complex<float> Complex;

  /// 2D Point
  struct P
  {
      float x, y;

      Complex & to_c() const { return *(Complex*)this; }

      const bool operator == (const P & p) const { return to_c() == p.to_c(); }
  };

  /// Point inside DBS file
  struct Node: P
  {
      float bulge; ///< Measure of curvature, tan of 1/4 of arc angle; positive for CCW arcs

      void json(ostream &, bool = false);
      void yaml(ostream & out) { json(out, true); }
      void dxf(ostream &);

      P & to_p() const { return *(P*)this; }
      Complex & to_c() const { return to_p().to_c(); }
  };

  /// Point-to-Point (line or arc)
  struct Span
  {
      P a;
      float bulge;
      P b;

      const Complex to_c() const { return b.to_c() - a.to_c(); }

      const float radius() const;
      const Complex center() const;
      const Complex zenith() const;
      const Complex nadir() const;

      const Complex operator [](float) const;  // Get point on the arc
      const Complex at(float) const;           // Like [] but more uniform
      const Complex linear(float f) const      // Point on line
        { return linear(Complex(f)); }
      const Complex linear(Complex) const;     // Trsnsform to local coordinates
  };

  /// Gemetry transformation (rotate + mirror + shift)
  struct O2
  {
      P x, y, delta;

      double det() const;
      P operator * (const P&) const;
      Node operator * (const Node&) const;
  };

  /// Polyline
  struct Path
  {
      vector <Node> nodes;

      void json(ostream &, bool pretty = false);
      void yaml(ostream &);
      void dxf(ostream &);

      bool closed() const;
      void reverse();
  };

  /// Iterator over Spans
  struct iSpan
  {
      const Path & path;
      size_t next;

      iSpan(const Path & p) : path(p) { next = 0; }

      Span * get();
  };


  /// Part
  struct Part
  {
      string name;
      vector <Path> paths;

      void json(ostream &, bool pretty = false);
      void yaml(ostream &);
      void dxf(ostream &);

      static const string quote(const string&);
  };

  /// DBS file itself
  struct File
  {
      vector <Part> parts;

      void read(std::string name);

      void json(ostream &, bool pretty = false);
      void yaml(ostream&);
      void dxf(ostream &);
  };
}
