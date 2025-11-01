cmake_minimum_required(VERSION 3.15)
project(Lloegrys)

# Set policy for Boost finding to avoid deprecation warnings
if(POLICY CMP0167)
    cmake_policy(SET CMP0167 OLD)
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

option(USE_LLD "Prefer LLVM lld linker when available" OFF)
option(USE_LUAJIT "Use LuaJIT instead of standard Lua" OFF)

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

# Lua (compatível com 5.2, 5.3 ou LuaJIT)
if(USE_LUAJIT)
    find_package(PkgConfig QUIET)
    if(PkgConfig_FOUND)
        pkg_check_modules(LUAJIT QUIET luajit)
    endif()

    if(LUAJIT_FOUND)
        set(LUA_INCLUDE_DIR "${LUAJIT_INCLUDE_DIRS}")
        set(LUA_LIBRARY "${LUAJIT_LIBRARIES}")
    endif()

    if(NOT LUA_INCLUDE_DIR)
        find_path(LUA_INCLUDE_DIR
            NAMES luajit.h lua.hpp
            PATHS /usr/include /usr/local/include
            PATH_SUFFIXES luajit-2.1 include/luajit-2.1
        )
    endif()

    if(NOT LUA_LIBRARY)
        find_library(LUA_LIBRARY
            NAMES luajit-5.1 luajit
            PATHS /usr/lib /usr/local/lib /usr/lib/x86_64-linux-gnu
        )
    endif()

    if(NOT LUA_INCLUDE_DIR OR NOT LUA_LIBRARY)
        message(FATAL_ERROR "LuaJIT not found. Install libluajit-5.1-dev")
    endif()

    message(STATUS "Using LuaJIT: ${LUA_LIBRARY}")
else()
    find_path(LUA_INCLUDE_DIR
        NAMES lua.hpp lua.h
        PATHS /usr/include /usr/local/include
        PATH_SUFFIXES lua5.4 lua5.3 lua5.2 lua
    )
    find_library(LUA_LIBRARY
        NAMES lua5.4 lua5.3 lua5.2 lua
        PATHS /usr/lib /usr/local/lib /usr/lib/x86_64-linux-gnu
    )
    if(NOT LUA_INCLUDE_DIR OR NOT LUA_LIBRARY)
        message(FATAL_ERROR "Lua not found. Install liblua5.2-dev or liblua5.3-dev")
    endif()
    message(STATUS "Using standard Lua: ${LUA_LIBRARY}")
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

# Crypto++
find_path(CRYPTOPP_INCLUDE_DIR cryptopp/cryptlib.h /usr/include /usr/local/include)
find_library(CRYPTOPP_LIBRARY NAMES cryptopp crypto++)
if(NOT CRYPTOPP_INCLUDE_DIR OR NOT CRYPTOPP_LIBRARY)
    message(FATAL_ERROR "Crypto++ not found. Install libcrypto++-dev")
endif()

# fmt
find_path(FMT_INCLUDE_DIR fmt/format.h /usr/include /usr/local/include)
find_library(FMT_LIBRARY NAMES fmt)
if(NOT FMT_INCLUDE_DIR OR NOT FMT_LIBRARY)
    message(FATAL_ERROR "fmt not found. Install libfmt-dev")
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
    ${CRYPTOPP_INCLUDE_DIR}
    ${FMT_INCLUDE_DIR}
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
    ${CRYPTOPP_LIBRARY}
    ${FMT_LIBRARY}
    pthread
)

# ------------------------------------
# Flags de compilação
# ------------------------------------
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_compile_options(lloegrys PRIVATE -Wall -Wextra -pthread)
    # Optimization level is controlled by CMAKE_BUILD_TYPE:
    # Debug: -Og (or no optimization) + -g
    # Release: -O3 + -DNDEBUG
    # RelWithDebInfo: -O2 + -g
    list(APPEND _lloegrys_extra_link_options "-Wl,--no-keep-memory")
endif()

if(_lloegrys_extra_link_options)
    list(REMOVE_DUPLICATES _lloegrys_extra_link_options)
    target_link_options(lloegrys PRIVATE ${_lloegrys_extra_link_options})
endif()

message(STATUS "✅ Configuração concluída com MariaDB")
