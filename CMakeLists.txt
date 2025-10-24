cmake_minimum_required(VERSION 3.15)
project(Lloegrys)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

option(USE_LLD "Prefer LLVM lld linker when available" OFF)

set(_lloegrys_extra_link_options "")
if(USE_LLD)
    find_program(LLD_EXECUTABLE NAMES ld.lld lld)
    if(LLD_EXECUTABLE)
        message(STATUS "Using lld linker: ${LLD_EXECUTABLE}")
        if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
            list(APPEND _lloegrys_extra_link_options "-fuse-ld=lld")
        else()
            message(WARNING "lld requested but current compiler does not support -fuse-ld flag")
        endif()
    else()
        message(WARNING "USE_LLD enabled but lld linker was not found on PATH")
    endif()
endif()

# ------------------------------------
# Dependências e includes
# ------------------------------------

# GMP
find_path(GMP_INCLUDE_DIR NAMES gmp.h)
find_library(GMP_LIBRARY NAMES gmp)
if(NOT GMP_INCLUDE_DIR OR NOT GMP_LIBRARY)
    message(FATAL_ERROR "GMP not found. Please install libgmp-dev")
endif()

# Boost
find_package(Boost 1.53 REQUIRED COMPONENTS system)
include_directories(${Boost_INCLUDE_DIRS})

# Lua (compatível com 5.2 ou 5.3)
find_path(LUA_INCLUDE_DIR lua.hpp /usr/include /usr/include/lua5.2 /usr/include/lua5.3)
find_library(LUA_LIBRARY NAMES lua5.2 lua5.3)
if(NOT LUA_INCLUDE_DIR OR NOT LUA_LIBRARY)
    message(FATAL_ERROR "Lua not found. Install liblua5.2-dev or liblua5.3-dev")
endif()

# MariaDB
find_path(MARIADB_INCLUDE_DIR mysql.h /usr/include/mariadb /usr/include/mysql)
find_library(MARIADB_LIBRARY NAMES mariadb)
if(NOT MARIADB_INCLUDE_DIR OR NOT MARIADB_LIBRARY)
    message(FATAL_ERROR "MariaDB client library not found. Install libmariadb-dev")
endif()

# PugiXML
find_path(PUGIXML_INCLUDE_DIR pugixml.hpp /usr/include /usr/local/include)
find_library(PUGIXML_LIBRARY NAMES pugixml)
if(NOT PUGIXML_INCLUDE_DIR OR NOT PUGIXML_LIBRARY)
    message(FATAL_ERROR "PugiXML not found. Install libpugixml-dev")
endif()

# ------------------------------------
# Includes e fontes
# ------------------------------------
include_directories(
    ${GMP_INCLUDE_DIR}
    ${Boost_INCLUDE_DIRS}
    ${LUA_INCLUDE_DIR}
    ${MARIADB_INCLUDE_DIR}
    ${PUGIXML_INCLUDE_DIR}
    ${CMAKE_SOURCE_DIR}/src
)

file(GLOB_RECURSE LLOEGRYS_SOURCES
    ${CMAKE_SOURCE_DIR}/src/*.cpp
    ${CMAKE_SOURCE_DIR}/src/*.h
)

# ------------------------------------
# Executável
# ------------------------------------
add_executable(lloegrys ${LLOEGRYS_SOURCES})

target_link_libraries(lloegrys
    ${GMP_LIBRARY}
    ${Boost_LIBRARIES}
    ${LUA_LIBRARY}
    ${MARIADB_LIBRARY}
    ${PUGIXML_LIBRARY}
    pthread
)

# ------------------------------------
# Flags de compilação
# ------------------------------------
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_compile_options(lloegrys PRIVATE -Wall -Wextra -O2 -pthread)
    list(APPEND _lloegrys_extra_link_options "-Wl,--no-keep-memory")
endif()

if(_lloegrys_extra_link_options)
    list(REMOVE_DUPLICATES _lloegrys_extra_link_options)
    target_link_options(lloegrys PRIVATE ${_lloegrys_extra_link_options})
endif()

message(STATUS "✅ Configuração concluída com MariaDB")
