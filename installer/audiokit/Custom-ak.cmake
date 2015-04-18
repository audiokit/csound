# CUSTOM PROPERTIES TO SET

# GLOBAL

#set(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_VERBOSE_MAKEFILE ON)
set(BUILD_STATIC_LIBRARY ON)
set(BUILD_IMAGE_OPCODES OFF)
set(USE_OPEN_MP OFF)
set(USE_CURL 0)
set(USE_DOUBLE 0)
set(TCL_VERSION 8.5)
##set(BUILD_CSOUND_AC OFF)
set(BUILD_CSOUND_AC_PYTHON_INTERFACE OFF)
set(BUILD_CSOUND_AC_LUA_INTERFACE OFF)

list(APPEND CMAKE_SYSTEM_LIBRARY_PATH "/usr/local/lib")
list(APPEND CMAKE_SYSTEM_INCLUDE_PATH "/usr/local/include")
list(APPEND CMAKE_SYSTEM_INCLUDE_PATH "/usr/include")

#add_definitions(-I/usr/local/include -I/usr/include)

set(CMAKE_C_FLAGS "-I/usr/local/include -I/usr/include")
set(CMAKE_CXX_FLAGS "-I/usr/local/include -I/usr/include")
#list(APPEND CMAKE_REQUIRED_DEFINITIONS "-I/usr/include")
