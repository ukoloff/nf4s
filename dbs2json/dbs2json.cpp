#include "!stdafx.h"
#include "Dbs.h"


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
            f.svg(cout);
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
