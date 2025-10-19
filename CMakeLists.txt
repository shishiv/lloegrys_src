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
