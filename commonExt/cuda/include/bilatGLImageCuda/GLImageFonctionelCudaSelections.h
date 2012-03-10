#ifndef GLIMAGE_FONCTIONEL_CUDA_SELECTIONS_H
#define GLIMAGE_FONCTIONEL_CUDA_SELECTIONS_H

#include "GLImageCudaSelections.h"
#include "DomaineMaths.h"
#include "DomaineEcrans.h"

#include <stack>
using std::stack;

#define KEY_HEAD_DOMAINE_HISTORY GLUT_KEY_HOME
#define KEY_RESTORE_DOMAINE 8 //code ascii for Backspace
class CBI_GLIMAGE_CUDA GLImageFonctionelCudaSelections: public GLImageCudaSelections
    {
    public:
	GLImageFonctionelCudaSelections(int w, int h, DomaineMaths domaineMath,int deviceId = 0, int pxFrame = 0, int pyFrame = 0);
	virtual ~GLImageFonctionelCudaSelections();

	void restoreFromDomaineHistory(); //Last Domaine push in History

	void headOfDomaineHistory(); //First Domaine of History

	DomaineMaths getCurrentDomaine(); //Domaine currently used

	void setCurrentDomaine(DomaineMaths domaineNew);

    protected:

	/**
	 * w et h fixe, ne change pas au cours du temps !
	 */
	virtual void performKernel(uchar4* ptrDevPixels, int w, int h, const DomaineMaths& domaineNew)=0;

	/**
	 * Call each time the domaine change
	 * 	1) Domaines : new domaine of the image
	 */
	virtual void onDomaineChangePerformed(const DomaineMaths& domaineNew);

	/**
	 * then selection is performed with the mouse, 3 arguments :
	 *	1) selected domaine in frame coordinate
	 *	2) dx is the screen width in pixLa clel
	 *	3) dy is the screen height in pixel
	 **/
	void selectionPerformed(const DomaineEcrans& domaineEcran, int dx, int dy);

    private:
	void performKernel(uchar4* ptrDevPixels, int w, int h);
	void keyPressed(unsigned char key, int x, int y);
	void specialKeyPressed(int key, int x, int y);
    private:

	stack<DomaineMaths> stackHistoryDomaine;
    };

#endif /* GLIMAGE_FONCTIONEL_CUDA_SELECTIONS_H */
