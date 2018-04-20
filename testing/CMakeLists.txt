cmake_minimum_required(VERSION 3.8)

project(testing)

file(GLOB SRCS *.cpp)
add_executable(${PROJECT_NAME} ${SRCS})
target_link_libraries(${PROJECT_NAME} LINK_PUBLIC dbs)
