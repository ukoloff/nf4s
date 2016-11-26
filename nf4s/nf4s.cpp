// nf4s.cpp : Defines the entry point for the console application.
//

#include <iostream>

#include "../dbs/Dbs.h"

int main(int argc, char *argv[])
{
    if(2 != argc)
    {
        cerr << "Usage: " << argv[0] << " filename.dbs\n";
        return 1;
    }
    try 
    {
        dbs::File f;
        f.read(argv[1]);
        f.yaml(cout);
        // throw new dbs::Error("Oops");
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
