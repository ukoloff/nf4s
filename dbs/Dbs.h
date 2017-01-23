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

      const bool operator == (const P & p) const { return to_c() == p.to_c(); }
  };

  /// Rectangle: 2 points or empty
  struct Rect
  {
      P min, max;

      Rect() { min.x = NAN; }
      Rect(const P & p) : min(p), max(p) {}

      Rect& operator += (float);
      Rect& operator -= (float f) { return *this += -f; }
      Rect& operator += (const P &);
      Rect& operator += (const Rect &);
      Rect operator + (float) const;
      Rect operator - (float f) const { return *this + -f; }
      Rect operator + (const P &) const;
      Rect operator + (const Rect &) const;

      explicit operator bool() const { return !isnan(min.x); }
      const bool operator == (const Rect &) const;
  };

  /// Point inside DBS file
  struct Node: P
  {
      float bulge; ///< Measure of curvature, tan of 1/4 of arc angle; positive for CCW arcs

      void json(ostream &, bool = false) const;
      void yaml(ostream & out) const { json(out, true); }
      void dxf(ostream &) const;
      void algomate(ostream &) const;

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

      const float radius() const;
      const Complex center() const;
      const Complex zenith() const;
      const Complex nadir() const;

      const Complex operator [](float) const;
      const Complex at(float) const;
      const Complex linear(float f) const
        { return linear(Complex(f)); }
      const Complex linear(Complex) const;

      bool isArc() const { return bulge != 0; }  ///< Check whether span is arc (not a line)
      double perimeter() const;
      double area() const;
      const Rect bounds() const;

      double bulgeOf(const Complex&) const;
      double bulgeOf(const P& p) const { return bulgeOf(p.to_c()); }
      double indexOf(const Complex&) const;
      double indexOf(const P& p) const { return indexOf(p.to_c()); }
      double bulgeLeft(float pos) const { return bulgeRight(-pos); }
      double bulgeRight(float pos) const;

      void svg(ostream &, bool first = false) const;

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

      void json(ostream &, bool pretty = false) const;    ///< See File::json
      void yaml(ostream &) const;
      void dxf(ostream &) const;
      void svg(ostream &) const;
      void algomate(ostream &) const;

      iSpan spans() const;

      bool isClosed() const;
      void reverse();

      int isRect() const;
      int isCircle() const;

      double perimeter() const;
      double area() const;
      const Rect bounds() const;
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

      void json(ostream &, bool pretty = false) const;    ///< See File::json
      void yaml(ostream &) const;
      void dxf(ostream &)const ;
      void svg(ostream &) const;
      void algomate(ostream &) const;

      static const string quote(const string&);

      int isRect() const;
      int isCircle() const;

      double perimeter() const;
      double area() const;
      const Rect bounds() const;
  };

  /// DBS file itself
  struct File
  {
      vector <Part> parts;

      void read(std::string name);

      void json(ostream &, bool pretty = false) const;
      void yaml(ostream&) const;
      void dxf(ostream &) const;
      void svg(ostream &) const;
      void algomate(ostream &) const;

      const Rect bounds() const;
      int isRect() const;
      int isCircle() const;
  };
}
