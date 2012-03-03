#ifndef COLOR_TOOLS_H
#define COLOR_TOOLS_H

#define RED_MASK 	0x000000FF
#define GREEN_MASK 	0x0000FF00
#define BLUE_MASK	0x00FF0000
#define ALPHA_MASK 	0xFF000000;

#include "envGLImage.h"

/*
 * The two methode HSB_TO_RGB and RGB_TO_HSB are from http://www.easyrgb.com/index.php?X=MATH&H=21#text21
 */
class CBI_GLIMAGE ColorTools
    {
    public:

	/**
	 * Conversion HSB => RGB
	 * Inputs :
	 * 	H,S,B in [0,1]
	 * Outputs :
	 * 	R,G,B in [0,255]
	 */
	static void HSB_TO_RGB(const float H, const float S, const float V, unsigned char &R, unsigned char &G, unsigned char &B);

	/**
	 * Conversion RGB => HSB
	 * Inputs :
	 * 	R,G,B in [0,255]
	 * Outpus :
	 * 	H,S,B in [0,1]
	 */
	static void RGB_TO_HSB(const unsigned char R, const unsigned char G, const unsigned char B, float &H, float &S, float &V);

	/**
	 * Conversion (r,g,b,a) => intRGBA
	 * Inputs :
	 * 	r,g,b,a in [0,255]
	 * Outputs :
	 * 	intRGBA codé sur 32 bits, chaque composante (a,r,g,b) étant codée sur 4 bits
	 * 	intRGBA codée :  0xAARRGGBB
	 */
	static int toIntRGBA(unsigned char r, unsigned char g, unsigned char b, unsigned char a = 0);

	/**
	 * see toIntRGBA(unsigned char r,  unsigned char g,  unsigned char b,  unsigned char a = 0)
	 */
	static int toIntRGBA(float r01, float g01, float b01, float a01 = 0);

	/**
	 * Conversion HSB => RGBA + toIntRGBA
	 * Inputs :
	 * 	h01,b01,b01 in [0,1]
	 * Outpus :
	 * 	intRGBA codé sur 32 bits, chaque composante (a,r,g,b) étant codée sur 4 bits
	 * 	intRGBA codée :  0xAARRGGBB
	 */
	static int HSB_TO_IntRGBA(float h01, float s01, float b01, float a01 = 0);

	/**
	 * Inputs :
	 * 	intRGBA codé sur 32 bits, chaque composante (a,r,g,b) étant codée sur 4 bits
	 * 	intRGBA codée :  0xAARRGGBB
	 * Outputs :
	 * 	r,g,b,a in [0,255]
	 */
	static void fromIntRGBA(const int rgb, unsigned char &r, unsigned char &g, unsigned char &b, unsigned char &a);
    };
#endif
