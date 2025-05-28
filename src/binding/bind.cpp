#include "lltm.h"

#include <pybind11/pybind11.h>
#include <torch/extension.h>
#include <pybind11/stl.h>

#define STRINGIFY(x) #x
#define MACRO_STRINGIFY(x) STRINGIFY(x)


PYBIND11_MODULE(TORCH_EXTENSION, m) {
    m.def("forward", &lltm_forward, "LLTM forward");
    m.def("backward", &lltm_backward, "LLTM backward");
    m.def("add", &lltm_add, "LLTM add");
#ifdef VERSION_INFO
    m.attr("__version__") = MACRO_STRINGIFY(VERSION_INFO);
#else
    m.attr("__version__") = "dev";
#endif
}









