<<<<<<< HEAD
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
=======
cmake_minimum_required(VERSION 3.28)
project(ForgottenServer C CXX)

# Força C++11
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Mensagens silenciosas para evitar warnings de depuração cotire
set(COTIRE_VERBOSE OFF)

# Ativa cotire se necessário
include(cmake/cotire.cmake)

# Busca dependências
find_package(Boost 1.53 REQUIRED COMPONENTS system)
find_package(GMP REQUIRED)
find_package(PugiXML REQUIRED)
find_package(Lua 5.2 REQUIRED)

# MySQL / MariaDB
set(MYSQL_INCLUDE_DIR /usr/include/mysql)
set(MYSQL_LIBRARY /usr/lib/x86_64-linux-gnu/libmysqlclient.so)

# Threads
find_package(Threads REQUIRED)

# Define diretórios de include
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${Boost_INCLUDE_DIRS}
    ${GMP_INCLUDE_DIR}
    ${PUGIXML_INCLUDE_DIR}
    ${LUA_INCLUDE_DIR}
    ${MYSQL_INCLUDE_DIR}
)

# Lista todos os arquivos fonte
file(GLOB_RECURSE TFS_SRC
    "src/*.cpp"
    "src/*.h"
)

# Cria o executável
add_executable(tfs ${TFS_SRC})

# Aplica cotire
cotire(tfs)

# Linka bibliotecas
target_link_libraries(tfs
    ${Boost_LIBRARIES}
    ${GMP_LIBRARIES}
    ${PUGIXML_LIBRARIES}
    ${LUA_LIBRARIES}
    ${MYSQL_LIBRARY}
    Threads::Threads
)
>>>>>>> a3a415b4f7fe1fd8d70368416863eecdce61221d
