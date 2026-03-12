cmake_minimum_required(VERSION 3.16)
project(publish_vector)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(zenohc REQUIRED)
find_package(zenohcxx REQUIRED)

add_executable(publish_vector src/publish_vector.cpp)

target_link_libraries(publish_vector PRIVATE zenohcxx::zenohc)
