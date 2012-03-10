#ifndef IMAGECUDAS_H
#define IMAGECUDAS_H

//#include "GLImageCudas.h" //include ImageCudas
#include "envGLImageCudas.h"
#include "GLConfig.h"
#include "cuda.h"
#include "cuda_gl_interop.h" //link between GL and Cuda


CBI_GLIMAGE_CUDA void initCudaForGLInterop(int deviceId=0);

CBI_GLIMAGE_CUDA cudaGraphicsResource*  linkWithCuda(GLuint pboID);


/*
 * Get Pixels from device to use with Cuda !
 */
CBI_GLIMAGE_CUDA void mapDevicePixels(cudaGraphicsResource* cudaRessource,uchar4** devPixels, size_t* size);

/**
 * Tell to cuda that we finish with pixels
 */
CBI_GLIMAGE_CUDA void unMapDevicePixels(cudaGraphicsResource *cudaRessource);

CBI_GLIMAGE_CUDA void resetDevicePixel(cudaGraphicsResource* cudaRessource);


#endif /* IMAGECUDAS_H */
