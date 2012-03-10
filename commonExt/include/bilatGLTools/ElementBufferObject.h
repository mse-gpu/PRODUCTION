#ifndef ELEMENTBUFFEROBJECT_H
#define ELEMENTBUFFEROBJECT_H

#include "BufferObject.h"

class CBI_GLTOOLS ElementBufferObject : public BufferObject
    {
    public:
	ElementBufferObject(unsigned int sizeOctet,void* bufferIndice,GLenum bufferUsage);
	ElementBufferObject();
	virtual ~ElementBufferObject();
    };

#endif /* ELEMENTBUFFEROBJECT_H */
