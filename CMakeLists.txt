cmake_minimum_required(VERSION 3.8 FATAL_ERROR)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/modules")


#list(APPEND CMAKE_PREFIX_PATH "/home/mohammad/anaconda3/lib/python3.11/site-packages/torch")

include(PyProject)
project(${PyProject_NAME}
        LANGUAGES C CXX CUDA
        VERSION ${PyProject_VERSION})

message(STATUS "Project: ${PROJECT_NAME}@v${PROJECT_VERSION}")


# if CUDA is optional: enable_language(CUDA)

set(CMAKE_CXX_STANDARD 17 CACHE STRING "C++ version selection")
set(CMAKE_CXX_STANDARD_REQUIRED ON)
add_compile_options(-O3 -fPIC)



include(PyTorch)
find_package(Torch REQUIRED)
message(STATUS "Torch_VERSION = ${Torch_VERSION}")

set(Torch_Min_Version "1.8")
if(Torch_VERSION VERSION_LESS Torch_Min_Version)
    message(FATAL_ERROR "${PROJECT_NAME} only supports PyTorch >= ${Torch_Min_Version}")
endif()

set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} ${TORCH_CXX_FLAGS})
link_libraries(${TORCH_LIBRARIES})
include_directories( ${TORCH_INCLUDE_DIRS})

# tweak torch dependencies, see https://github.com/pytorch/pytorch/issues/33928
#get_target_property(TORCH_INTERFACE_LIB torch INTERFACE_LINK_LIBRARIES)
#string(REPLACE "/usr/local/cuda" ${CUDA_TOOLKIT_ROOT_DIR} TORCH_INTERFACE_LIB "${TORCH_INTERFACE_LIB}")
#set_target_properties(torch PROPERTIES INTERFACE_LINK_LIBRARIES ${TORCH_INTERFACE_LIB})

file(GLOB SOURCES ${PROJECT_SOURCE_DIR}/src/*.cpp)
# add library

#set_property(TARGET lltm_ext PROPERTY CXX_STANDARD 17)
#


add_library(lltm SHARED
        ${SOURCES}
)
target_include_directories(lltm
        PUBLIC
        ${PROJECT_SOURCE_DIR}/include
        PRIVATE
        ${PROJECT_SOURCE_DIR}/src)


if(DEFINED SKBUILD)
#find_package(PythonExtensions REQUIRED)
find_package(Python REQUIRED COMPONENTS Interpreter Development.Module)

python_add_library(${TORCH_EXTENSION} MODULE ${PROJECT_SOURCE_DIR}/src/binding/bind.cpp WITH_SOABI)
target_sources(${TORCH_EXTENSION} PRIVATE ${SOURCES})
set_property(TARGET ${TORCH_EXTENSION} PROPERTY INTERFACE_LINK_LIBRARIES ${TORCH_INTERFACE_LIB})
target_link_libraries(${TORCH_EXTENSION} PRIVATE ${TORCH_LIBRARIES} Python::Module)

#python_extension_module(lltm_ext)
target_compile_definitions(${TORCH_EXTENSION} PRIVATE
        TORCH_EXTENSION=${TORCH_EXTENSION}
        VERSION_INFO=${PROJECT_VERSION})

target_include_directories(${TORCH_EXTENSION}
        PUBLIC
        ${PROJECT_SOURCE_DIR}/include
        PRIVATE
        ${PROJECT_SOURCE_DIR}/src)


#install(TARGETS lltm_ext DESTINATION src/lltm)
install(TARGETS ${TORCH_EXTENSION}
        CONFIGURATIONS Release
        LIBRARY DESTINATION ${SKBUILD_PROJECT_NAME})
RETURN()
endif()



add_executable(example ${PROJECT_SOURCE_DIR}/examples/main.cpp)

target_link_libraries(example PRIVATE lltm)



