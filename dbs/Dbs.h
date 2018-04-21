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

      Complex & to_c() const { return *(Complex*)this; } ///< Cast to complex number

      bool operator == (const P & p) const { return to_c() == p.to_c(); }
  };

  /// Point inside DBS file
  struct Node: P
  {
      float bulge; ///< Measure of curvature, tan of 1/4 of arc angle; positive for CCW arcs

      void json(ostream &, bool = false);
      void yaml(ostream & out) { json(out, true); }
      void dxf(ostream &);
      void algomate(ostream &);

      P & to_p() const { return *(P*)this; }    ///< Cast to point
      Complex & to_c() const { return to_p().to_c(); }  ///< Cast to complex number
  };

  /// Point-to-Point (line or arc)
  struct Span
  {
      P a;          ///< Start of arc/line
      float bulge;  ///< the same as Node::bulge
      P b;          ///< End of arc/line

      const Complex to_c() const { return b.to_c() - a.to_c(); }    ///< Vector from start to end

      float radius() const;
      Complex center() const;
      Complex zenith() const;
      Complex nadir() const;

      Complex operator [](float) const;
      Complex at(float) const;
      Complex linear(float f) const
        { return linear(Complex(f)); }
      Complex linear(Complex) const;

      bool ark() const { return bulge != 0; }  ///< Check whether span is ark (not a line)
      double perimeter() const;
      double area() const;

      double bulgeOf(const Complex&) const;
      double bulgeOf(const P& p) const { return bulgeOf(p.to_c()); }
      double indexOf(const Complex&) const;
      double indexOf(const P& p) const { return indexOf(p.to_c()); }
      double bulgeLeft(float pos) const { return bulgeRight(-pos); }
      double bulgeRight(float pos) const;

      static double square(double x) { return x * x; }
  };

  /// Gemetry transformation (rotate + mirror + shift)
  struct O2
  {
      P x, y, delta;

      double det() const;
      P operator * (const P&) const;
      Node operator * (const Node&) const;
  };

  struct iSpan;

  /// Polyline
  struct Path
  {
      vector <Node> nodes;

      void json(ostream &, bool pretty = false);    ///< See File::json
      void yaml(ostream &);
      void dxf(ostream &);
      void algomate(ostream &);

      iSpan spans() const;

      bool closed() const;
      void reverse();

      int isRect() const;
      int isCircle() const;

      double perimeter() const;
      double area() const;
  };

  /// Iterator over Spans
  struct iSpan
  {
      const Path & path;
      size_t next;

      iSpan(const Path & p) : path(p) { next = 0; }

      Span * get();
  };

  /// Part (collection of paths)
  struct Part
  {
      string name;
      vector <Path> paths;

      void json(ostream &, bool pretty = false);    ///< See File::json
      void yaml(ostream &);
      void dxf(ostream &);
      void algomate(ostream &);

      static const string quote(const string&);

      int isRect() const;
      int isCircle() const;

      double perimeter() const;
      double area() const;
  };

  /// DBS file itself
  struct File
  {
      vector <Part> parts;

      void read(std::string name);

      void json(ostream &, bool pretty = false);
      void yaml(ostream&);
      void dxf(ostream &);
      void algomate(ostream &);

      int isRect() const;
      int isCircle() const;
  };
}
