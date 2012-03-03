#ifndef GLIMAGE_SELECTIONS_H
#define GLIMAGE_SELECTIONS_H

#include "GLImages.h"
#include "DomaineEcrans.h"

class CBI_GLIMAGE GLImageSelections: public GLImages
    {
    public:

	GLImageSelections(ImageMOOs* ptrImageMOO, int pxFrame = 0, int pyFrame = 0);

	virtual ~GLImageSelections();

    protected:

	/**
	 * then selection is performed with the mouse, 3 arguments :
	 *	1) selected domaine in frame coordinate
	 *	2) dx is the screen width in pixLa clel
	 *	3) dy is the screen height in pixel
	 **/
	virtual void selectionPerformed(DomaineEcrans& domaine, int dx, int dy);

	DomaineEcrans getCurrentDomaineSelection() const;

	virtual void display();

    private:
	void mouseMoved(int x, int y);
	void mousePressed(int button, int state, int x, int y);

	void drawSelection();

    private:
	//Inputs
	DomaineEcrans domaineSelection;

	//Tools
	bool isSelectionEnable;
	float ratio; //ration de la taille de la sélection proportionnel à l'image
    };

#endif
