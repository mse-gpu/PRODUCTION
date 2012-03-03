#ifndef CALIBREURCUDAS_H
#define CALIBREURCUDAS_H

#include "bilatCudaTools.h"

class CalibreurCudas
    {
    public:
	CalibreurCudas(float x1, float x2, float y1, float y2)
	    {
	    this->x1 = x1;
	    this->x2 = x2;
	    this->y1 = y1;
	    this->y2 = y2;
	    pente = (y2 - y1) / (x2 - x1);
	    t = y1 - pente * x1;
	    }

	CalibreurCudas(const CalibreurCudas& source)
	    {
	    x1 = source.x1;
	    x2 = source.x2;
	    y1 = source.y1;
	    y2 = source.y2;
	    pente = source.pente;
	    t = source.t;
	    }

	virtual ~CalibreurCudas()
	    {

	    }

	__device__
	float calibrate(float x) const
	    {
	    return (pente * x) + t;
	    }

    private:
	float pente;
	float t;
	float x1;
	float x2;
	float y1;
	float y2;
    };

#endif
