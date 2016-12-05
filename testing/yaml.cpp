#include "!stdafx.h"

TEST_CASE("Parse YAML")
{
    YAML::Node primes = YAML::Load("[2, 3, 5, 7, 11]");
    for (auto it : primes)
        std::cout << it.as<int>() << " ";
    std::cout << "\n";
}
