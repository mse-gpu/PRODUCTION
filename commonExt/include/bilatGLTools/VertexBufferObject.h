#ifndef VERTEXBUFFEROBJECT_H
#define VERTEXBUFFEROBJECT_H

#include "BufferObject.h"

class CBI_GLTOOLS VertexBufferObject : public BufferObject
    {
    public:
	VertexBufferObject(unsigned int sizeOctet,void* bufferVertex,GLenum bufferUsage);
	VertexBufferObject();
	virtual ~VertexBufferObject();
    };

#endif /* VERTEXBUFFEROBJECT_H*/
