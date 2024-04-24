#ifdef TORCH_EXTENSION
#include <torch/torch.h>
#include <torch/extension.h>
#else
#include <torch/torch.h>
#endif


#define STRINGIFY(x) #x
#define MACRO_STRINGIFY(x) STRINGIFY(x)
