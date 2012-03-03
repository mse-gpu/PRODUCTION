# Version 	: 0.0.1
# Date		: 26.01.2012
# Author 	: Cedric.Bilat@he-arc.ch
#
# Contrainte
#
#	Dans les definitions de variables ci-dessous, ne laisser jamais d'espace a la fin!!!
#

##############
#   public   #
##############

#########
# Visual #
#########

#separateur est espace,sans extension .a, sans prefixe lib
EXCLUDE_LIBRARY_FILES:=
ADD_LIBRARY_FILES:=

#Compilation: (minimal conseillé : /MD)
#/openmp : pas necessaire!
CXXFLAGS:= /MD 
CXXFLAGS+= /DWIN32#only for compiling cppTest

#Linkage: (minimal vide)
CXXLDFLAGS := 

#" " pas necessaire pour CXXLDFLAGS et CXXFLAGS, post-added!
#flag seront surcharger par la suite

##############
#   pivate   #
##############

COMPILATEUR:=nvidia
OS:=Win
USER=${USERNAME}

#chargement de la makeFile principale
-include dataProject.mk
-include ../PRODUCTION/MANAGER/makefile/private/makeFileCudaWin.mk
 
##############
#   END      #
##############
