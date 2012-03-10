
#ifndef CPP_TEST_PLUS_H
#define CPP_TEST_PLUS_H

#include "cpptest.h"
#include <string>

using std::string;

bool runTestConsole(string titre, Test::Suite& test);
bool runTestHtml(string titre, Test::Suite& test);

#endif

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

