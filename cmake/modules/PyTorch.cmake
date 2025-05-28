# Looking for a Python executable
message(STATUS "Looking for a Python executable...")
find_program(Python_EXECUTABLE python python3)

if(Python_EXECUTABLE)
    message(STATUS "Found Python executable: ${Python_EXECUTABLE}")
else()
    message(WARNING "Python executable not found. Cannot proceed with PyTorch check.")
    return()
endif()

# Checking for PyTorch installation
message(STATUS "Checking for PyTorch installation using Python: ${Python_EXECUTABLE}...")

execute_process(
        COMMAND "${Python_EXECUTABLE}" -c "import torch; print(torch.utils.cmake_prefix_path, end='')"
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        RESULT_VARIABLE PYTORCH_STATUS
        OUTPUT_VARIABLE Torch_DIR
        OUTPUT_STRIP_TRAILING_WHITESPACE
)

# Analyze execution result
#if(NOT PYTORCH_STATUS EQUAL "0")
#    message(STATUS "Failed to import 'torch' using ${Python_EXECUTABLE}. Trying alternative methods or configurations...")
#    message(STATUS "Tip: Make sure PyTorch is installed in the environment used by this Python executable.")
#    return()
#endif()
set(Torch_DIR ${Torch_DIR}/Torch)

# Show detected PyTorch path
message(STATUS "PyTorch CMake prefix path: ${Torch_DIR}")

find_package(Torch REQUIRED)
message(STATUS "Torch_VERSION = ${Torch_VERSION}")

set(Torch_Min_Version "1.8")
if(Torch_VERSION VERSION_LESS Torch_Min_Version)
    message(FATAL_ERROR "${PROJECT_NAME} only supports PyTorch >= ${Torch_Min_Version}")
endif()


if(NOT Torch_FOUND)
    message(FATAL_ERROR "Torch not found. Required for creating torch::torch interface target.")
    return()
endif()

if(TARGET torch::torch)
    message(STATUS "torch::torch already exists, skipping redefinition.")
    return()
endif()

# Create the interface library
add_library(torch::torch INTERFACE IMPORTED)

target_include_directories(torch::torch INTERFACE ${TORCH_INCLUDE_DIRS})
target_compile_options(torch::torch INTERFACE ${TORCH_CXX_FLAGS})
set_property(TARGET torch::torch PROPERTY INTERFACE_CXX_STANDARD 17)
set_property(TARGET torch::torch PROPERTY INTERFACE_CXX_STANDARD_REQUIRED ON)
target_link_libraries(torch::torch INTERFACE ${TORCH_LIBRARIES})

message(STATUS "Created: torch::torch")

## Set include directories
#target_include_directories(torch::torch INTERFACE
#        ${TORCH_INCLUDE_DIRS}
#)
#
## Set compiler flags (e.g., ABI settings)
#if(TORCH_CXX_FLAGS)
#    target_compile_options(torch::torch INTERFACE
#            ${TORCH_CXX_FLAGS}
#    )
#endif()
#
## Set C++ standard
#set_property(TARGET torch::torch PROPERTY INTERFACE_CXX_STANDARD 17)
#set_property(TARGET torch::torch PROPERTY INTERFACE_CXX_STANDARD_REQUIRED ON)
#
## Link libraries (both direct and transitive)
#target_link_libraries(torch::torch INTERFACE
#        ${TORCH_LIBRARIES}
#)
#
## Optional: propagate any required link directories
#foreach(LIB ${TORCH_LIBRARIES})
#    get_filename_component(LIB_DIR "${LIB}" DIRECTORY)
#    if(IS_DIRECTORY "${LIB_DIR}")
#        target_link_directories(torch::torch INTERFACE ${LIB_DIR})
#    endif()
#endforeach()
#
#message(STATUS "🎉 Created interface target: torch::torch")
#message(STATUS "   Includes: ${TORCH_INCLUDE_DIRS}")
#message(STATUS "   Libraries: ${TORCH_LIBRARIES}")
#message(STATUS "   CXX Flags: ${TORCH_CXX_FLAGS}")
#
#


# --- Step: Find torch_python library ---
find_library(TORCH_PYTHON_LIBRARY
        NAMES torch_python
        PATHS "${TORCH_INSTALL_PREFIX}/lib"
        NO_DEFAULT_PATH)

if(TORCH_PYTHON_LIBRARY AND EXISTS "${TORCH_PYTHON_LIBRARY}")
    message(STATUS "Found torch_python: ${TORCH_PYTHON_LIBRARY}")

    # Create an IMPORTED STATIC target for torch_python
    if(NOT TARGET torch::python)
        add_library(torch::python UNKNOWN IMPORTED)

        set_target_properties(torch::python PROPERTIES
                IMPORTED_LOCATION "${TORCH_PYTHON_LIBRARY}"
                INTERFACE_INCLUDE_DIRECTORIES "${TORCH_INSTALL_PREFIX}/include/torch/csrc/api/include"
                INTERFACE_LINK_LIBRARIES "torch"
        )

        message(STATUS "Created imported target: torch::python")
    endif()
else()
    message(WARNING "torch_python not found in ${TORCH_INSTALL_PREFIX}/lib")
endif()
