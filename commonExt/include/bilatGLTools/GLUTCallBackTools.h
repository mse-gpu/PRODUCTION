#ifndef GLUCALLBACKTOOLS_H
#define GLUCALLBACKTOOLS_H

#include "GLUTWindowManagers.h"
#include "envGLTools.h"
#include <map>
using std::map;

/*
 * But :
 *
 * 	Cette class permet d'affecter ses Callback a GLUT.
 *
 *	Exemple :
 *
 *		 glutDisplay(displayGLUTWrapper);
 *		 glutXXX(xxxGLUTWrapper);
 * Problème :
 *
 * 	Les méthodes callback de glut doivent obligatoirement être statique. On travail en objet.
 *
 * Solution :
 *
 * 	Pour pouvoir "utiliser" les callback glut avec le monde objet, les callback statique appeleront les méthodes publiques des objets GLUTWindowCustomiser
 * 	à l'aide d'une map faisant correspondre l'IdGLUT de la frame à l'objet (GLUTWindowCustomiser) correspondant.
 */
class CBI_GLTOOLS  GLUTCallBackTools
    {
    public:
	virtual ~GLUTCallBackTools();

	static void affectAllCallBack(map<unsigned int,GLUTWindowCustomiser_A*> mapGLUTWindowCustomiser);

	/**
	 * CallBack pour GLUT
	 * glutXXX(xxx)
	 */
	static void displayGLUTWrapper();
	static void reshapeGLUTWrapper(int w, int h);
	static void mouseMotionGLUTWrapper(int x, int y);
	static void mouseGLUTWrapper(int button, int state, int x, int y);
	static void keyboardGLUTWrapper(unsigned char key, int x, int y);
	static void specialFuncGLUTWrapper(int key, int x, int y);
	static void idleFuncGLUTWrapper();
	//static void postRunWrapper();

    private:
	GLUTCallBackTools();
	static void affectCallBack(unsigned int glutID,GLUTWindowCustomiser_A* glutWindowCustomier);
    };

#endif /* GLUCALLBACKTOOLS_H */
