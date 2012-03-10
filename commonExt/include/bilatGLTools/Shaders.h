/*
 * ShaderCodes.h
 *
 *  Created on: 8 déc. 2011
 *      Author: stahlij
 */
#ifndef SHADERS_H
#define SHADERS_H

#include "GLConfig.h"
#include "envGLTools.h"
#include "ShaderCodes.h"

/**
 * Use ShaderLoader to crate a Shader
 * But shaderType is GL_VERTEX_SHADER or GL_FRAGMENT_SHADER
 */
class CBI_GLTOOLS Shaders
    {
    public:
	Shaders(GLenum shaderType,ShaderCodes* sourceCode);
	virtual ~Shaders();

	void init();
	void release();
	GLuint getShaderID() const;
    private :
	GLenum shaderType;
	ShaderCodes* shaderCode;
	GLuint shaderID;
    };

#endif /* SHADERS_H */
