cmake_minimum_required(VERSION 3.8)

project(nf4s)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED on)
set(CMAKE_EXPORT_COMPILE_COMMANDS on)

if(MSVC)
    add_compile_options(/W3 /WX)
else()
    add_compile_options(-Wall -Wextra -Werror --pedantic)
endif()

add_subdirectory(dbs)
add_subdirectory(dbs2json)
add_subdirectory(testing)
