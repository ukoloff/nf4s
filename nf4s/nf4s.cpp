// nf4s.cpp : Defines the entry point for the console application.
//

#include <iostream>

#include "stdafx.h"
#include "Dbs.h"

int main()
{
    cout << "Hello, world!" << endl;
    cout << sizeof DbsPoint << endl;
    try {
        readDbs("C:\\geodet\\ring.DBS");
    }
    catch(exception &e){
        cerr << "Exception: " << e.what() << endl;
    }
    catch(...) {
        cerr << "Unknown exception!" << endl;
    }
    return 0;
}
