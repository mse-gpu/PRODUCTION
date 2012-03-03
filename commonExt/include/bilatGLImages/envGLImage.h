/**
 * GLTools project
 * version : 0.0.2
 *
 * Cédric Bilat		cedric.bilat@he-arc.ch
 * Stähli Joaquim	joaquim.stahli@he-arc.ch
 */

//PRIVATE
#ifndef ENV_GLIMAGE_H
#define ENV_GLIMAGE_H

#include "dllHelper.h"

// CBI_GL_IMAGE is used for the public API symbols. It either DLL imports or DLL exports (or does nothing for static build)
// CBI_GL_IMAGE_LOCAL is used for non-api symbols.

#ifdef CBI_GLIMAGE_USE_DLL // defined if API is compiled as a DLL
    #ifdef CBI_GLIMAGE_DLL_EXPORT // defined if we are building the API DLL (instead of using it)
	#define CBI_GLIMAGE HELPER_DLL_EXPORT
    #else
	#define CBI_GLIMAGE HELPER_DLL_IMPORT
    #endif // GLIMAGE_DLL_EXPORT
    #define CBI_GLIMAGE_LOCAL HELPER_DLL_LOCAL
#else // GLIMAGE_USE_DLL is not defined: this means API is a static lib.
    #define CBI_GLIMAGE
    #define CBI_GLIMAGE_LOCAL
#endif

#endif  /* ENV_GLIMAGE_H */
