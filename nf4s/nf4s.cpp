// nf4s.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"

#include <iostream>

using namespace std;

void readDbs(string name);

int main()
{
    cout << "Hello, world!" << endl;
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
