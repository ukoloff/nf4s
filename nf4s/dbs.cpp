#include <fstream>

static_assert(2 == sizeof(short), "Invalid short int!");

using namespace std;

void readDbs(string name)
{
    ifstream dbs;
    dbs.exceptions(ifstream::failbit | ifstream::eofbit | ifstream::badbit);
    dbs.open(name);
}
