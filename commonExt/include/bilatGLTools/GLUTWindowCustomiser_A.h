

#ifndef GLUTWINDOWCUSTOMISERA_H
#define GLUTWINDOWCUSTOMISERA_H

#define DEFAULT_GLUT_DISPLAY_MODE GLUT_DOUBLE|GLUT_DEPTH|GLUT_RGBA

#include "envGLTools.h"

#include "GLConfig.h"

#include "FPSCounters.h"

#include <string>
using std::string;

/**
 * Etat d'une GLUTWindowCustomiser_A
 * A un instant t, elle ne peux avoir qu'un seul état, soit CREATED,RUNNING ou DESTROYED.
 * L'état NOT_CREATED est utiliser à la construction de l'objet et fait office d'état "NULL" ou sans état
 */
enum  GLUT_WINDOW_CUSTOMISER_STATE {NOT_CREATED,CREATED,RUNNING,DESTROYED};

/**
 * But :
 * 	Permet de customiser une fenêtre GLUT.
 *
 * Note :
 *
 * 	Seul les méthodes init et display sont obligatoire.
 *
 * Attention :
 *
 * 	la fonction idleFun est appelé de manière frénétique ! A utiliser a vos risque et périle.
 */
class CBI_GLTOOLS GLUTWindowCustomiser_A
    {
    public:
	GLUTWindowCustomiser_A(string title, int width, int height, int pxFrame = 0, int pyFrame = 0, int glutDisplayMode = DEFAULT_GLUT_DISPLAY_MODE);
	virtual ~GLUTWindowCustomiser_A();

	virtual void init(void)=0;
	virtual void display(void)=0;
	virtual void release(void);
	virtual void reshape(int w, int h);
	virtual void mouseMoved(int x, int y);
	virtual void mousePressed(int button, int state, int x, int y);
	virtual void keyPressed(unsigned char key, int x, int y);
	virtual void specialKeyPressed(int key, int x, int y);
	/**
	 * Fonction appelé a chaque fois que glut n'a rien à faire dans la mainLoop.
	 * CaD s'il n'y a pas d'évenents utilisateur (souris,clavier,joystick,repaint,etc...)
	 */
	virtual void idleFunc();

	/**
	 * call display()
	 */
	void displayWrapper();
	void repaint();

	int getFrameWidth(void) const;
	int getFrameHeight(void) const;
	int getFramePositionX(void) const;
	int getFramePositionY(void) const;
	int getGLUTDisplayMode(void) const;
	string getTitle(void) const;

	bool isRunning() const;
	bool isCreated() const;
	bool isDestroyed() const;
	bool isDisplaying() const;

	/**
	 * Don't Use !
	 * Only used by GLUTWindowManagers !
	 */
	void setState(GLUT_WINDOW_CUSTOMISER_STATE state);


    private:
	string title;
	int lastFPS;
	int glutDisplayMode;
	int pxFrame;
	int pyFrame;
	int width;
	int height;
	bool displaying;
	FPSCounters fpsCounter;
	GLUT_WINDOW_CUSTOMISER_STATE state;
    };

#endif /* GLUTWINDOWCUSTOMISERA_H */
