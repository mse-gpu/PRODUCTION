# Version 	: 0.0.1
# Date		: 26.01.2012
# Author 	: Cedric.Bilat@he-arc.ch
#
# Contrainte
#
#	Dans les d�finitions de variables ci-dessous, ne laisser jamais d'espace � la fin!!!
#

#########
#public #
#########

#Option de compilation 
#Elles seront ensuite surcharg�es automatiquement (par exemple en fonction du type de la target)
#Version minimale : Ne rien metter laisser vierge!
#CXXFLAGS:= -W -Wall 
CXXFLAGS+= -mtune=core2 
CXXFLAGS+= -O3 -frerun-loop-opt -fgcse -fomit-frame-pointer
CXXFLAGS+= -fopenmp

#Option de compilation Static Lib 
ARFLAGS:=
 
#Option de linkage
#Elles seront ensuite surcharg�es automatiquement (par exemple en fonction du type de la target)
#Version minimale : Ne rien metter laisser vierge!
LDFLAGS:=

#Injection de variable dans le code (same as #define XXX YYY)
CODE_DEFINE_VARIABLES:=

#separateur est espace,sans extension .lib, sans prefixe lib
#GL_LIBS:=opengl32 glu32 kernel32 user32 gdi32

#ADD_LIBRARY_FILES:=$(GL_LIBS)

EXCLUDE_LIBRARY_FILES:=

#########
#Private#
#########

COMPILATEUR:=mingw
OS:=Linux
USER=${USERNAME}

ROOT_MAKEFILE_PRIVATE:=../PRODUCTION/MANAGER/makefile/private
-include dataProject.mk
-include $(ROOT_MAKEFILE_PRIVATE)/fileSet.mk
-include $(ROOT_MAKEFILE_PRIVATE)/flags_MinGW.mk
-include $(ROOT_MAKEFILE_PRIVATE)/makeFileCPP.mk
 
#########
#  End  #
#########