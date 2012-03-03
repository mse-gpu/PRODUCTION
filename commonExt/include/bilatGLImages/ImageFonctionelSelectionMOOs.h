#ifndef IMAGE_FONCTIONEL_SELECTION_MOOS_H
#define IMAGE_FONCTIONEL_SELECTION_MOOS_H

#include "ImageMOOs.h"
#include "DomaineMaths.h"

#include <stack>
using std::stack;

/**
 * ImageMOO with a Mathematical Domaine. This domaine can be modified.
 * An history of modification is maintained for undo.
 */
class CBI_GLIMAGE ImageFonctionelSelectionMOOs: public ImageMOOs
    {
    public:

	ImageFonctionelSelectionMOOs(unsigned int m, unsigned int n, DomaineMaths domaine);

	ImageFonctionelSelectionMOOs(unsigned int m, unsigned int n, unsigned char* tabPixel, DomaineMaths domaine);

	ImageFonctionelSelectionMOOs(const ImageFonctionelSelectionMOOs &imageSource);

	virtual ~ImageFonctionelSelectionMOOs();

	void restoreFromDomaineHistory(); //Last Domaine push in History

	void headOfDomaineHistory(); //First Domaine of History

	DomaineMaths getCurrentDomaine(); //Domaine currently used

	void setCurrentDomaine(DomaineMaths domaineNew);
    protected:

	/**
	 * New mathematical domaine for this image.
	 * Previous domaine will be put in history and current domaine is domaineNew
	 */
	virtual void onDomaineChangePerformed(const DomaineMaths& domaineNew);
    private:

	stack<DomaineMaths> stackHistoryDomaine;
    };

#endif /* IMAGE_FONCTIONEL_SELECTION_MOOS_H */
