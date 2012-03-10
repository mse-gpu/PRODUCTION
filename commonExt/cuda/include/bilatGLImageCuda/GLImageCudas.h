#ifndef GLIMAGE_CUDAS_H
#define GLIMAGE_CUDAS_H

#include "envGLImageCudas.h"
#include "GLUTWindowCustomiser_A.h"
#include "ImageCudas.h"
#include "TitleDrawers.h"

/**
 * Data plus stocker in Central Memory
 */
class CBI_GLIMAGE_CUDA GLImageCudas: public GLUTWindowCustomiser_A
    {
    public:

	/**
	 *   (dx,dy)		:  Size of the image
	 *   (pxFrame,pyFrame) 	:  The position of the upper left corner of the frame in screen space.
	 *   deviceId		:  Device ID of the GPU used, on cuda server deviceId in [0,5]
	 */
	GLImageCudas(int m, int n, int deviceId = 0, int pxFrame = 0, int pyFrame = 0);

	virtual ~GLImageCudas();

	/**
	 * update call useKernelCuda
	 * update don't call repaint !
	 */
	void updateView();

	/**
	 * Image Size
	 */
	int getDx() const;
	int getDy() const;
	int getM() const;
	int getN() const;
	int getW() const;
	int getH() const;

	int getDxFrame() const;
	int getDyFrame() const;

	void setTitleTop(string title, float r = 0.5, float g = 0.2, float b = 0.1);
	void setTitleBottom(string title, float r = 0.5, float g = 0.2, float b = 0.1);
	void setTitleMiddle(string title, float r = 0.5, float g = 0.2, float b = 0.1);

	void removeTitleTop();
	void removeTitleBottom();
	void removeTitleMiddle();

	GLuint getPBO();

    protected:

	/**
	 * w et h fixe, ne change pas au cours du temps !
	 */
	virtual void performKernel(uchar4* ptrDevPixels,int w,int h)=0;

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

	void init(void);
	void display(void);
	void reshape(int w, int h);
	void mouseMoved(int x, int y);
	void mousePressed(int button, int state, int x, int y);
	void keyPressed(unsigned char key, int x, int y);
	void specialKeyPressed(int key, int x, int y);

    private:

	void createTexture();
	void deleteTexture();
	void drawCredits();
	void drawTitles();

    private:
	//Inputs
	int m;
	int n;
	int dxFrame;
	int dyFrame;

	//Tools
	unsigned int textureID;
	GLuint pbo;

	TitleDrawers titleDrawer;

	//Cuda interop
	cudaGraphicsResource* cudaRessource;
	int deviceId;
    };

#endif /*GLIMAGE_CUDAS_H*/
