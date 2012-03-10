
#ifndef GLUTTEXTRENDERERS_H
#define GLUTTEXTRENDERERS_H

#include "envGLTools.h"
#include "GLConfig.h"
#include <string>
using std::string;

class CBI_GLTOOLS  GLUTTextRenderers
    {
    public:
	GLUTTextRenderers();
	virtual ~GLUTTextRenderers();

	static void renderBitmapString(float x,float y,float z,const char *string,void* font=GLUT_BITMAP_TIMES_ROMAN_10);

	static void renderBitmapString(float x,float y,float z,string texte,void* font=GLUT_BITMAP_TIMES_ROMAN_10);

	/**
	 * all value are relative to viewport, ie not in pixels !
	 */
	static void renderBitmapStringCentered(float x, float y, float hfont, float wfont, string title, void* font);
    };

#endif /* GLUTTEXTRENDERERS_H_ */
