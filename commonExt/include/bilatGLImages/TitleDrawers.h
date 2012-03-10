#ifndef TITLEDRAWERS_H
#define TITLEDRAWERS_H

#include "envGLImage.h"

#include <string>
using std::string;

class CBI_GLIMAGE TitleDrawers
    {
    public:
	TitleDrawers();
	virtual ~TitleDrawers();

	void setTitleTop(string title,float r=0.5,float g=0.2,float b= 0.1);
	void setTitleBottom(string title,float r=0.5,float g=0.2,float b= 0.1);
	void setTitleMiddle(string title,float r=0.5,float g=0.2,float b= 0.1);

	void removeTitleTop();
	void removeTitleBottom();
	void removeTitleMiddle();

	void reshape(int w,int h);

	void drawTitles();
	void drawCredits();

    private :
	string titleTop;
	string titleMiddle;
	string titleBottom;

	float colorTitleTop[3];
	float colorTitleMiddle[3];
	float  colorTitleBottom[3];

	int frameWidth;
	int frameHeight;
    };


#endif /* TITLEDRAWERS_H_ */
