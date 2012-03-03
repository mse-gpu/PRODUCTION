#ifndef SHADERLOADERS_H
#define SHADERLOADERS_H

#include "GLConfig.h"
#include "envGLTools.h"

#include "ShaderPrograms.h"


class CBI_GLTOOLS ShaderLoaders
    {
    public:

	ShaderLoaders();
	virtual ~ShaderLoaders();

	static Shaders* loadVertexShader(string fileName);

	static Shaders* loadFragmentShader(string fileName);

	static ShaderCodes* loadShaderSourceCode(string fileName);

	static ShaderPrograms* loadShaderProgram(string fileNameVertexShader, string fileNameFragmentShader);

    private:
	static Shaders* loadShader(GLenum type, string fileName);
    };

#endif /* SHADERLOADERS_H */
