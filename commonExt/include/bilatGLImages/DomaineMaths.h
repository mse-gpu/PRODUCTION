#ifndef DOMAINES_H
#define DOMAINES_H

#include "envGLImage.h"
#include "DomaineEcrans.h"
#include <string>

using std::string;

/**
 * (x0,y0) upper left corner of a dx x dy square.
 */
class CBI_GLIMAGE DomaineMaths
    {
    public:

	DomaineMaths();

	DomaineMaths(float x0, float y0, float dx, float dy);

	DomaineMaths(const DomaineMaths &domaineSource);

	virtual ~DomaineMaths();

	DomaineMaths extractDomaineFromSelection(const DomaineEcrans &domaineSelection, int dxFrame, int dyFrame);

	string toString();

	float x0;
	float y0;
	float dx;
	float dy;
    };

#endif
