#include "!stdafx.h"
#include "Dbs.h"

static void SVG(const dbs::File &);

int main(int argc, char *argv[])
{
    if(2 != argc && 3!= argc)
    {
        cerr << "Usage: " << argv[0] << " [json|JSON|yaml|svg|dxf] filename.dbs\n";
        return 1;
    }
    try
    {
        dbs::File f;
        f.read(argv[argc-1]);
        switch(argc == 2 ? 'j' : *argv[1])
        {
        case 'J':
            f.json(cout, true);
            break;
        case 'y':
            f.yaml(cout);
            break;
        case 'd':
            f.dxf(cout);
            break;
        case 's':
            SVG(f);
            break;
        default:
            f.json(cout);
        }
    }
    catch(exception &e)
    {
        cerr << "Exception: " << e.what() << endl;
    }
    catch(...)
    {
        cerr << "Unknown exception!" << endl;
    }
    return 0;
}

static const std::string Preamble = R"HTML(
<html>
<head>
<style>
body {
  margin: 0;
}
svg {
  x-border: 1px dotted red;
  box-sizing: border-box;
}
path {
  fill: lime;
  stroke: red;
  stroke-width: 1;
  fill-rule: nonzero;
  stroke-linejoin: round;
}
</style>
</head>
<body>
<svg height="100%" width="100%" viewBox=")HTML";

static const std::string Middle = R"HTML("><g transform = "scale(1, 1)">
)HTML";

static const std::string Postamble = R"HTML(
</g>
</svg>
</body>
</html>
)HTML";

static void SVG(const dbs::File & dbs)
{
    cout << Preamble;
    auto b = dbs.bounds();
    auto sz = b.max.to_c() - b.min.to_c();
    cout << b.min.x << " " << b.min.y << " " << sz.real() << " " << sz.imag();
    cout << Middle;
    dbs.svg(cout);
    cout << Postamble;
}
