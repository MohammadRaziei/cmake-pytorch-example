find_program( Python_EXECUTABLE python python3)
message(STATUS "Checking for PyTorch using ${Python_EXECUTABLE} ...")
execute_process(
        COMMAND "${Python_EXECUTABLE}"
        -c "import torch;print(torch.utils.cmake_prefix_path, end='')"
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        RESULT_VARIABLE PYTORCH_STATUS
        OUTPUT_VARIABLE PYTORCH_PACKAGE_DIR)
if(NOT PYTORCH_STATUS EQUAL "0")
    message(STATUS "Unable to 'import torch' with ${Python_EXECUTABLE} (fallback to explicit config)")
    return()
endif()
message(STATUS "Found PyTorch installation at ${PYTORCH_PACKAGE_DIR}")