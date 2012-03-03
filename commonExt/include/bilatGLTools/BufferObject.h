#ifndef BUFFEROBJECT_H
#define BUFFEROBJECT_H

#include "GLConfig.h"
#include "envGLTools.h"

/**
 * Create Buffer in a valide OpenGL context
 *
 * When can I instancied a BufferObject ?
 *
 * 	Using API :
 * 		in GLUTWindowCustomiser_A.init() ! (ps reshape,display are other possiblities)
 * 	Using GLUT :
 *  		after glutCreateWindow(...)
 */
class CBI_GLTOOLS BufferObject
    {

    public:
	BufferObject(GLenum target,unsigned int sizeOctet,void* bufferData,GLenum bufferUsage);
	BufferObject();
	virtual ~BufferObject();

	void bindBuffer();
	void unBindBuffer();
	void updateBufferData(unsigned int sizeOctet,void* bufferData);

	void* map(GLenum access);
	bool unMap(void);

	unsigned int getBufferID() const;

    protected :
	GLuint bufferID; //Identifiant OpenGL
	GLenum target;

    };

#endif /* BUFFEROBJECT_H*/
