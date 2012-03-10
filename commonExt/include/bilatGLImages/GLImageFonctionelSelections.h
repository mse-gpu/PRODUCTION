#ifndef GLIMAGE_FONCTIONEL_SELECTIONS_H
#define GLIMAGE_FONCTIONEL_SELECTIONS_H

#include "GLImageSelections.h"
#include "ImageFonctionelSelectionMOOs.h"

class CBI_GLIMAGE GLImageFonctionelSelections: public GLImageSelections
    {
    public:

	GLImageFonctionelSelections(ImageFonctionelSelectionMOOs *ptrImageFonctionel, int pxFrame = 0, int pyFrame = 0);

	virtual ~GLImageFonctionelSelections();

	ImageFonctionelSelectionMOOs* getPtrImageFonctionelSelectionMOO();

    protected:
	/**
	 * then selection is performed with the mouse, 3 arguments :
	 *	1) selected domaine in frame coordinate
	 *	2) dx is the screen width in pixLa clel
	 *	3) dy is the screen height in pixel
	 **/
	void selectionPerformed(DomaineEcrans& domaine, int dx, int dy);

    private:
	void keyPressed(unsigned char key, int x, int y);
	void specialKeyPressed(int key, int x, int y);

    };

#endif /*GLIMAGE_FONCTIONEL_SELECTIONS_H*/
