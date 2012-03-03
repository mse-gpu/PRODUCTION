#ifndef BILATCUDATOOLS_H
#define BILATCUDATOOLS_H

#include "builtin_types.h"
#include "cuda_runtime.h"

#include "envGLImageCudas.h"

CBI_GLIMAGE_CUDA void handleError(cudaError_t error, const char *file, int line);

#define HANDLE_ERROR( error ) (handleError( error, __FILE__, __LINE__ ))

#endif /* BILATCUDATOOLS_H*/
