#include "bilatCudaTools.h"

#ifndef CUDA_TOOLS_H
#define CUDA_TOOLS_H


/**
 * i in [0, n-1]
 * j in [0, m-1]
 */
__device__ int indice1D(int i, int j, int n, int m)
    {
    return (j+ m * i)*4;
    }


/*
 * Convertir une couleur HSB en RGB !
 * H,S,B in [0,1]
 * R,G,B in [0,255]
 */
__device__ void HSB_TO_RVB(float H, float S, float V, unsigned char &R, unsigned char &G, unsigned char &B)
    {
    //float H = profondeur / 255.0;
    //float S = 1;
    //float V = 1;
    if (S == 0) //HSV from 0 to 1
	{
	R = V * 255;
	G = V * 255;
	B = V * 255;
	}
    else
	{
	float var_h = H * 6;
	if (var_h == 6)
	    {
	    var_h = 0;
	    } //H must be < 1

	unsigned char var_i = (unsigned char) var_h; //Or ... var_i = floor( var_h )
	float var_1 = V * (1 - S);
	float var_2 = V * (1 - S * (var_h - var_i));
	float var_3 = V * (1 - S * (1 - (var_h - var_i)));

	float var_r, var_g, var_b;
	if (var_i == 0)
	    {
	    var_r = V;
	    var_g = var_3;
	    var_b = var_1;
	    }
	else if (var_i == 1)
	    {
	    var_r = var_2;
	    var_g = V;
	    var_b = var_1;
	    }
	else if (var_i == 2)
	    {
	    var_r = var_1;
	    var_g = V;
	    var_b = var_3;
	    }
	else if (var_i == 3)
	    {
	    var_r = var_1;
	    var_g = var_2;
	    var_b = V;
	    }
	else if (var_i == 4)
	    {
	    var_r = var_3;
	    var_g = var_1;
	    var_b = V;
	    }
	else
	    {
	    var_r = V;
	    var_g = var_1;
	    var_b = var_2;
	    }

	//RGB results from 0 to 255
	R = (unsigned char) (var_r * 255);
	G = (unsigned char) (var_g * 255);
	B = (unsigned char) (var_b * 255);
	}
    }


#endif
