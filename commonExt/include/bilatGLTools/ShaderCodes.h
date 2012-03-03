#ifndef SHADERCODES_H
#define SHADERCODES_H

#include "GLConfig.h"
#include "envGLTools.h"

#include <vector>
#include <string>

using std::string;
using std::vector;

class CBI_GLTOOLS ShaderCodes
    {
    public:
	ShaderCodes(vector<string> tabCodeSource, unsigned int ligneCount);
	virtual ~ShaderCodes();

	void afficherCode(const GLchar** code, unsigned int ligneCount); //Debug

	unsigned int getLigneCount() const;

	const GLchar** getSourceCode() const;

    private:
	unsigned int ligneCount;
	vector<string> tabCodeSource;
    };

#endif /* SHADERCODES_H */
