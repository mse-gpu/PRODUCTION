# Version 	: 0.0.1
# Date		: 26.01.2012
# Author 	: Cedric.Bilat@he-arc.ch
#
# Contrainte
#
#	Dans les définitions de variables ci-dessous, ne laisser jamais d'espace à la fin!!!
#

##############
#   public   #
##############

#########
# GCC #
#########

#separateur est espace,sans extension .a, sans prefixe lib
EXCLUDE_LIBRARY_FILES:=
ADD_LIBRARY_FILES:=

#Compilation: (minimal vide)
#-fopenmp : pas necessaire!
CXXFLAGS:= -W -Wall 
CXXFLAGS+= -mtune=core2
CXXFLAGS+= -O3 -frerun-loop-opt -fgcse -fomit-frame-pointer

#Linkage: (minimal vide)
#pour mkl
CXXLDFLAGS = -lmkl_core -lmkl_intel_lp64 -lmkl_intel_thread -liomp5

#" " pas necessaire pour CXXLDFLAGS et CXXFLAGS, post-added!
#flag seront surcharger par la suite

##############
#   pivate   #
##############

COMPILATEUR:=nvidia
OS:=Linux

#chargement de la makeFile principale
-include dataProject.mk
-include ../PRODUCTION/MANAGER/makefile/private/makeFileCudaLinux.mk
 
##############
#   END      #
##############