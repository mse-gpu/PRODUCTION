#ifndef GLIMAGECUDASELECTIONS_H
#define GLIMAGECUDASELECTIONS_H

#include "GLImageCudas.h"

#include "DomaineEcrans.h"


class CBI_GLIMAGE_CUDA GLImageCudaSelections : public GLImageCudas
    {
    public:
	GLImageCudaSelections(int w,int h,int deviceId=0, int pxFrame = 0, int pyFrame = 0);
	virtual ~GLImageCudaSelections();



    protected :

	/**
	 * then selection is performed with the mouse,
	 * domaine in frame coordinate
	 **/
	virtual void selectionPerformed(const DomaineEcrans& domaineEcran,int dxFrame,int dyFrame);

	DomaineEcrans getCurrentDomaineSelection() const;

    private:

	void display();
	void mouseMoved(int x, int y);
	void mousePressed(int button, int state, int x, int y);
	void drawSelection();

    private:
	DomaineEcrans domaineSelection;
	bool isSelectionEnable;
	float ratio; //ration de la taille de la selection proportionnel à l'image
    };

#endif /* GLIMAGECUDASELECTIONS_H_ */
