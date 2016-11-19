#pragma once

using namespace std;

static_assert(2 == sizeof(short), "Invalid short int!");

void readDbs(string name);

class DbsPoint
{
    double x;
    double y;
    double t;
};
