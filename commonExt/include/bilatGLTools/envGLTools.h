/**
 * GLTools project
 * version : 0.0.1
 *
 * Cédric Bilat		cedric.bilat@he-arc.ch
 * Stähli Joaquim	joaquim.stahli@he-arc.ch
 */

#ifndef ENV_GLTOOLS_H
#define ENV_GLTOOLS_API_H

#include "dllHelper.h"

// Now we use the generic helper definitions above to define HELLO_API and HELLO_API_LOCAL.
// HELLO_API is used for the public API symbols. It either DLL imports or DLL exports (or does nothing for static build)
// HELLO_API_LOCAL is used for non-api symbols.

#ifdef CBI_GLTOOLS_USE_DLL // defined if API is compiled as a DLL
  #ifdef CBI_GLTOOLS_DLL_EXPORT // defined if we are building the API DLL (instead of using it)
    #define CBI_GLTOOLS HELPER_DLL_EXPORT
  #else
    #define CBI_GLTOOLS HELPER_DLL_IMPORT
  #endif
  #define CBI_GLTOOLS_LOCAL HELPER_DLL_LOCAL
#else // GL_TOOLS_USE_DLL is not defined: this means API is a static lib.
  #define CBI_GLTOOLS
  #define CBI_GLTOOLS_LOCAL
#endif


#endif /* ENV_GLTOOLS_API_H */
