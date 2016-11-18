#include <fstream>

using namespace std;

void readDbs(string name)
{
    ifstream dbs;
    dbs.exceptions(ifstream::failbit | ifstream::eofbit | ifstream::badbit);
    dbs.open(name);
}
