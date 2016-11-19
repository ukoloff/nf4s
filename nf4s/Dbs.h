#pragma once

using namespace std;

static_assert(2 == sizeof(short), "Invalid short int!");

void readDbs(string name);

// typedef class DbsPoint DbsPoint;
// typedef class DbsTransform DbsTransform;

class DbsPoint;
class DbsTransform;

class DbsPoint
{
public:
    double x;
    double y;
    double t;
};

class DbsTransform
{
public:
    double cosXX, sinXX, cosYX, sinYX;
    double deltaX, deltaY;

//    DbsPoint operator *(DbsPoint& pt);
    double det(void);
};

DbsPoint operator*(DbsTransform& t, DbsPoint& p);
