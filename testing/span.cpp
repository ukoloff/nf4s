#include "stdafx.h"
#include "Dbs.h"

TEST_CASE("Check uniformity")
{
    const int N = 100;
    const int B = 28;
    dbs::Span span = {{0, 0}, 1, {0, 1}};
    for(int i = 0; i <= B; i++)
    {
        span.bulge = i;
        float min, max;
        dbs::Complex p, prev;
        for(int j = 0; j <= N; j++, prev = p)
        {
            p = span.at(j / (float)N);
            if(!j) continue;
            float d = abs(p - prev);
            if(1 == j || min > d) min = d;
            if(1 == j || max < d) max = d;
        }
        cout << span.bulge << ": " << ((max / min) - 1) * 100 << "%\t";
    }
    cout << '\n';
}
