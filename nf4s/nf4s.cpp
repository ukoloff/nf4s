// nf4s.cpp : Defines the entry point for the console application.
//

#include <iostream>

#include "stdafx.h"
#include "Dbs.h"

int main()
{
    cout << "Hello, world!" << endl;
    cout << sizeof dbs::P << endl;
    cout << sizeof dbs::Node << endl;

    dbs::Node n;
    n.x = 1; n.y = 2; n.bulge = 3;
    dbs::O2 o2 = { {1,2},{3,4},{5,6} };
    dbs::Node res = o2*n;
    res.dump();

    try {
        dbs::File::read("C:\\geodet\\ring.DBS");
    }
    catch(exception &e){
        cerr << "Exception: " << e.what() << endl;
    }
    catch(...) {
        cerr << "Unknown exception!" << endl;
    }
    return 0;
}
