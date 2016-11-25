// nf4s.cpp : Defines the entry point for the console application.
//

#include <iostream>

#include "stdafx.h"
#include "Dbs.h"

int main()
{
    try {
        dbs::File f;
        f.read("C:\\geodet\\ring.DBS");
        f.yaml(cout);
        // throw new dbs::Error("Oops");
    }
    catch(exception &e){
        cerr << "Exception: " << e.what() << endl;
    }
    catch(...) {
        cerr << "Unknown exception!" << endl;
    }
    return 0;
}
