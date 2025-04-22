cmake_minimum_required(VERSION 3.40)

project(f22_efm LANGUAGES C CXX)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

file(GLOB_RECURSE f22_sources "${CMAKE_CURRENT_SOURCE_DIR}/source/*.cpp")

add_library(f22 SHARED ${f22_sources})
target_include_directories(f22 PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_compile_definitions(f22 PRIVATE _USE_MATH_DEFINES NOMINMAX)

set_target_properties(f22 PROPERTIES 
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin/$<0:>" 
    DEBUG_POSTFIX "" 
    RELWITHDEBINFO_POSTFIX "" 
    RELEASE_POSTFIX "" 
    OUTPUT_NAME "f22" 
    MSVC_RUNTIME_LIBRARY "MultiThreadedDLL"
)