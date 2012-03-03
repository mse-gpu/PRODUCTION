#ifndef GLIMAGES_H
#define GLIMAGES_H

#include "envGLImage.h"
#include "GLUTWindowCustomiser_A.h"
#include "ImageMOOs.h"
#include "TitleDrawers.h"

#include <string>
using std::string;

class CBI_GLIMAGE GLImages: public GLUTWindowCustomiser_A
    {
    public:

	/**
	 * (pxFrame,pyFrame) is the position of the upper left corner of the frame in screen space.
	 */
	GLImages(ImageMOOs* ptrImageMOO, int pxFrame = 0, int pyFrame = 0);

	virtual ~GLImages();

	/**
	 * Update view from model
	 */
	void updateView();

	ImageMOOs* getPtrImageMOO();

	/**
	 * width of the current frame
	 */
	int getDxFrame();

	/**
	 * height of the current frame
	 */
	int getDyFrame();

	void setTitleTop(string title, float r = 0.5, float g = 0.2, float b = 0.1);
	void setTitleBottom(string title, float r = 0.5, float g = 0.2, float b = 0.1);
	void setTitleMiddle(string title, float r = 0.5, float g = 0.2, float b = 0.1);

	void removeTitleTop();
	void removeTitleBottom();
	void removeTitleMiddle();

    protected:
	/**
	 * CallBack usable by Users !
	 */
	virtual void initPerformed();
	virtual void displayPerformed();
	virtual void reshapePerformed(int w, int h);
	virtual void mouseMovedPerformed(int x, int y);
	virtual void mousePressedPerformed(int button, int state, int x, int y);
	virtual void keyPressedPerformed(unsigned char key, int x, int y);
	virtual void specialKeyPressedPerformed(int key, int x, int y);
	/**
	 * Fonction appelé a chaque fois que glut n'a rien à faire dans la mainLoop.
	 * CàD s'il n'y a pas d'évenents utilisateur (souris,clavier,joystick,repaint,etc...)
	 */
	virtual void idleFunc();

	/**
	 * CallBack use only by developpers !!
	 */
	virtual void init(void);
	virtual void display(void);
	virtual void reshape(int w, int h);
	virtual void mouseMoved(int x, int y);
	virtual void mousePressed(int button, int state, int x, int y);
	virtual void keyPressed(unsigned char key, int x, int y);
	virtual void specialKeyPressed(int key, int x, int y);


    private:

	void createTexture();

	void deleteTexture();

	void drawCredits();

	void drawTitles();

    private:
	//Inputs
	ImageMOOs* ptrImageMOO;

	//Tools
	unsigned int textureID;
	unsigned int pboIDs[1];
	int glutID;
	int dxFrame;
	int dyFrame;
	TitleDrawers titleDrawer;

    };

#endif
