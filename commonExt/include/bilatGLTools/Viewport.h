#ifndef VIEWPORT_H
#define VIEWPORT_H

#include "envGLTools.h"

class CBI_GLTOOLS Viewport
    {
    public:
	Viewport(int x,int y,int w,int h);
	virtual ~Viewport();

	float getRatio() const;

	int getX(void) const;
	int getY(void) const;
	int getW(void) const;
	int getH(void) const;

	void setX(int x);
	void setY(int y);
	void setW(int w);
	void setH(int h);
	void set(int x,int y,int w,int h);


    private:
	int x;
	int y;
	int w;
	int h;

    };

#endif /* VIEWPORT_H */
