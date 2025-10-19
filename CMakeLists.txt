cmake_minimum_required(VERSION 3.15)
project(TFS)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Paths GMP
set(GMP_INCLUDE_DIR /usr/include)
set(GMP_LIBRARIES /usr/lib/x86_64-linux-gnu/libgmp.so)

# Paths Boost
find_package(Boost 1.53 REQUIRED COMPONENTS system)
include_directories(${Boost_INCLUDE_DIRS})

# Paths Lua
find_path(LUA_INCLUDE_DIR lua.hpp /usr/include /usr/include/lua5.2 /usr/include/lua5.3)
find_library(LUA_LIBRARY lua5.2 /usr/lib/x86_64-linux-gnu /usr/lib)
if(NOT LUA_INCLUDE_DIR OR NOT LUA_LIBRARY)
    message(FATAL_ERROR "Lua not found")
endif()

# Paths MariaDB / MySQL
find_path(MYSQL_INCLUDE_DIR mysql.h /usr/include/mysql)
find_library(MYSQL_LIBRARY NAMES mariadb mysqlclient /usr/lib/x86_64-linux-gnu)
if(NOT MYSQL_INCLUDE_DIR OR NOT MYSQL_LIBRARY)
    message(FATAL_ERROR "MariaDB/MySQL client not found")
endif()

# Paths PugiXML
find_path(PUGIXML_INCLUDE_DIR pugixml.hpp /usr/include /usr/local/include)
if(NOT PUGIXML_INCLUDE_DIR)
    message(FATAL_ERROR "PugiXML not found")
endif()

# Include directories
include_directories(
    ${GMP_INCLUDE_DIR}
    ${Boost_INCLUDE_DIRS}
    ${LUA_INCLUDE_DIR}
    ${MYSQL_INCLUDE_DIR}
    ${PUGIXML_INCLUDE_DIR}
    ${CMAKE_SOURCE_DIR}/src
)

# Source files
file(GLOB_RECURSE TFS_SOURCES
    ${CMAKE_SOURCE_DIR}/src/*.cpp
    ${CMAKE_SOURCE_DIR}/src/*.h
)

# Add executable
add_executable(tfs ${TFS_SOURCES})

# Link libraries
target_link_libraries(tfs
    ${GMP_LIBRARIES}
    ${Boost_LIBRARIES}
    ${LUA_LIBRARY}
    ${MYSQL_LIBRARY}
    pthread
)

# Compiler flags
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_compile_options(tfs PRIVATE -Wall -Wextra -O2 -pthread)
endif()
