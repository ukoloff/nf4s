cmake_minimum_required(VERSION 3.8)

project(dbs)

file(GLOB SRCS *.cpp)
add_library(${PROJECT_NAME} ${SRCS})
target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
