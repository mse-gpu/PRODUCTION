#ifndef IMAGE_MOOS_H
#define IMAGE_MOOS_H

#define NB_CHAR_PIXEL 4
#define OFFSET_RED 0
#define OFFSET_GREEN 1
#define OFFSET_BLUE 2
#define OFFSET_ALPHA 3

#include "envGLImage.h"

/**
 * ImageMOOs consists of an array of pixels, (unsigned char* tabPixel).
 * Each pixel is a sequence of 4 unsigned char whose values are in [0,255]
 * This sequence is determined as follows :
 * 	pixel[0]=RED
 * 	pixel[1]=GREEN
 * 	pixel[2]=BLUE
 * 	pixel[3]=ALPHA
 */
class CBI_GLIMAGE ImageMOOs
    {
    public:

	ImageMOOs(unsigned int m, unsigned int n);

	ImageMOOs(unsigned int m, unsigned int n, unsigned char* ptrTabPixel);

	ImageMOOs(const ImageMOOs &imageSource);

	virtual ~ImageMOOs();

	/**
	 * Converti une paire d'indice (i,j) en un indice k
	 * k étant l'indice d'une matrice(m,n) linéarisé
	 * indice1D [1, m*n]
	 */
	unsigned int indice1D(unsigned int i, unsigned int j); //indice 1D


	void setUniformeRGBA(unsigned int rgba);
	/**
	 * i [1,n]
	 * j [1,m]
	 */
	void setIntRGBA(unsigned int i, unsigned int j, unsigned int rgba); //setIntRGBA

	/**
	 * i [1,n]
	 * j [1,m]
	 * red,green,blue,alpah in [0,255]
	 */
	void setRGBA(unsigned int i, unsigned int j, unsigned char red, unsigned char green, unsigned char blue, unsigned char alpha = 255);

	/**
	 * i [1,n]
	 * j [1,m]
	 * red01,green01,blue01,alpha01 in [0,1]
	 */
	void setFloatRGBA(unsigned int i, unsigned int j, float red01, float green01, float blue01, float alpha01 = 1);

	/**
	 * i [1,n]
	 * j [1,m]
	 * hue01,s01,b01 in [0,1]
	 */
	void setHSB(unsigned int i, unsigned int j, float hue01, float s01, float b01);

	/**
	 * i [1,n]
	 * j [1,m]
	 * hue01 in [0,1]
	 */
	void setHue(unsigned int i, unsigned int j, float hue01);

	/**
	 * Inputs :
	 * 	i [1,n]
	 * 	j [1,m]
	 * Outputs :
	 * 	intRGBA coded in 32 bits, 0xAABBGGRR
	 */
	unsigned int extractIntRGBA(unsigned int i, unsigned int j);

	/**
	 * Inputs :
	 * 	i [1,n]
	 * 	j [1,m]
	 * Outputs :
	 * 	red in [0,255]
	 */
	unsigned char extractRed(unsigned int i, unsigned int j);

	/**
	 * Inputs :
	 * 	i [1,n]
	 * 	j [1,m]
	 * Outputs :
	 * 	green in [0,255]
	 */
	unsigned char extractGreen(unsigned int i, unsigned int j);

	/**
	 * Inputs :
	 * 	i [1,n]
	 * 	j [1,m]
	 * Outputs :
	 * 	blue in [0,255]
	 */
	unsigned char extractBlue(unsigned int i, unsigned int j);

	/**
	 * Inputs :
	 * 	i [1,n]
	 * 	j [1,m]
	 * Outputs :
	 * 	alpha in [0,255]
	 */
	unsigned char extractAlpha(unsigned int i, unsigned int j);

	/**
	 * Inputs :
	 * 	i [1,n]
	 * 	j [1,m]
	 * Outputs :
	 * 	pixelColor, RGBA
	 */
	unsigned char* getRGBA(unsigned int i, unsigned int j);

	unsigned int getM() const;
	unsigned int getN() const;
	unsigned int getDx() const;
	unsigned int getDy() const;

	unsigned int getW() const;
	unsigned int getH() const;

	int getSizeOctet() const;

	unsigned char* getPtrTabPixels();

	/**
	 * idem que getRGBA(i,j);
	 */
	unsigned char* operator()(unsigned int i, unsigned int j);

    private:

	//Inputs
	unsigned int m;
	unsigned int n;
	unsigned char* ptrTabPixels;

	//Tools
	bool isTabPixelToDestroy; //true avec le constructeur CImags(int, int ,int* ) false avec CImags(int, int )
    };

#endif
