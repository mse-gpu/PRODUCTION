# Version 	: 0.0.2
# Date		: 02.02.2012
# Author 	: Cedric.Bilat@he-arc.ch
#
# See 		: OptionCompilateur.txt
#			  MakeFileNotice.txt
#
# Hyp		: Application that must be in path

######################
#   Init	    	 #
######################

#SHELL=/bin/bash

machine:=${shell uname -m}
ifeq (${machine},x86_64)
	ARCHI_32_64:=64
else
	ARCHI_32_64:=32
endif

######################
#    Variables       #
######################

ifeq ($(COMPILATEUR),INTEL)
	#Compilateur ,Archiveur (static lib)
    CXX:=icpc
    AR:=xild
else
    #Compilateur ,Archiveur (static lib)
    CXX:=g++
    AR:=ar
endif

#############
# Extension  #
#############

EXTENSION_OBJ:=o#
EXTENSION_LIB:=a#
EXTENSION_DLL:=so#
EXTENSION_EXE:=run#
# Note enstension sans le .

#############
#Compilateur#
#############

SYS_LIBRARY_FILES:=#minimum rien
OPTION_SEPARATOR:=-#
LIB_FLAG_SEPARATOR:=l#attention end with space!
LIB_PATH_SEPARATOR:=L #attention end with space!
HEADER_OPTION:=I #attention end with space!
OUT_FILE_COMPILE:=-o #attention end with space!
OUT_FILE_LINK:=-o #attention end with space!
LINK_TAG:=#rien
LINK_FLAG_DLL:=-shared -fvisibility=hidden #with espace !

LIB_PREFIXE:=lib#

VERSION_CXX:=$(CXX) --version
CXX_HELP:=$(CXX) --help

##########
#ARCHIVEUR#
###########

AR_OUT_FLAG:=-r #with espace important !

#############
# SET FILES	#
#############

#	Input : 
#		SRC_PATH_ALL
#	Output :
#		All files libXXX.a, libXXX.so and XXX.so, without XXX.a !
#	Objectifs :
#		Les .a prefixé par lib (libXXX.a) seront donnee a GCC sous la forme -lXXX)
#		Alors que les YYY.a devront etre donner a GCC sous la forme YYY.a
SRC_A_FILES_STANDART:=$(foreach dir,$(SRC_PATH_ALL),$(wildcard $(dir)/$(LIB_PREFIXE)*.$(EXTENSION_LIB)))
SRC_A_FILES_STANDART+=$(SRC_SO_FILES)

#	Input : 
#		SRC_PATH_ALL
#	Output :
#		All files XXX.a without libXXX.a, libXXX.so and XXX.so !
#	Objectifs :
#		Les .a prefixé par lib (libXXX.a) seront donnee a GCC sous la forme -lXXX
#		Alors que les YYY.a devront etre donner a GCC sous la forme YYY.a avec la path complet (par exemple ../libs/YYY.a)
SRC_A_FILES_NOT_STANDART:=$(foreach dir,$(SRC_PATH_ALL),$(filter-out $(dir)/$(LIB_PREFIXE)%.$(EXTENSION_LIB),$(wildcard $(dir)/*.$(EXTENSION_LIB))))

#################
# PREPARE FLAGS	#
#################

#Ajoute automatiquement gomp si on use OpenMP
ifneq (, $(findstring openmp,$(CXXFLAGS)))#findstring return vide si openmp pas trouver!
		 ADD_LIBRARY_FILES+=gomp
endif

#only fileName (./libs/libXXX.a ./libs/YYY.so -> lixXXX.a YYY.so)
LIB_FLAG:=$(notdir $(SRC_A_FILES_STANDART))

#removing prefix lib (libXXX.a libYYY.a libZZZ.so -> XXX.a YYY.a ZZZ.so)
LIB_FLAG:=$(subst $(LIB_PREFIXE),,$(LIB_FLAG))#remplace lib par rien

#Delete extension .a (XXX.a YYY.a -> XXX YYY)
LIB_FLAG:=$(LIB_FLAG:.$(EXTENSION_LIB)=)

#Delete extension .so (AAA.so BBB.so -> AAA BBB)
LIB_FLAG:=$(LIB_FLAG:.$(EXTENSION_DLL)=)

#ADDING custom LIB and System LIB
LIB_FLAG+=$(ADD_LIBRARY_FILES) $(SYS_LIBRARY_FILES)

# Input :
#	list lib to delete example (AAA ZZZ)
#
#	before : LIB_FLAG (XXX YYY ZZZ)
#	after  : LIB_FLAG (XXX YYY) without ZZZ
LIB_FLAG:=$(filter-out $(EXCLUDE_LIBRARY_FILES),$(LIB_FLAG))

#Adding Lib FLAG separator -l (XXX YYY -> -lXXX -lYYY)
LIB_FLAG:=$(addprefix $(OPTION_SEPARATOR)$(LIB_FLAG_SEPARATOR) ,$(LIB_FLAG))

#Adding Lib path FLAG separator -L (../AAA ./BBB -> -L../AAA _L./BBB)
LIB_PATH_FLAG:=${SRC_PATH_ALL}
LIB_PATH_FLAG:=$(addprefix $(OPTION_SEPARATOR)$(LIB_PATH_SEPARATOR),$(LIB_PATH_FLAG))

#Adding Include FLAG separator -I (../header ../header/api -> -I../header -I../header/api)
HEADER_FLAG:= $(addprefix $(OPTION_SEPARATOR)$(HEADER_OPTION),$(HEADER_PATH_ALL))

#Injection variable in .cpp code (VAR1 VAR2 -> -DVAR1 -DVAR2)
CODE_DEFINE_VARIABLES_D:= $(addprefix  -D,$(CODE_DEFINE_VARIABLES))

#Ajoute automatiquement gomp(gcc) or iomp5(Intel)  si on use OpenMP
ifneq (, $(findstring openmp,$(CXXFLAGS)))#findstring return vide si openmp pas trouver!
	ifeq ($(COMPILATEUR),INTEL)
		ADD_LIBRARY_FILES+=iomp5
	else
        ADD_LIBRARY_FILES+=gomp
	endif
endif


#OUTPUTS#
override LDFLAGS_AUX+= $(SRC_A_FILES_NOT_STANDART)
override CXXFLAGS += $(HEADER_FLAG)
override CXXFLAGS += $(CODE_DEFINE_VARIABLES_D)
override LDFLAGS  += $(LINK_TAG) $(LIB_PATH_FLAG) $(LIB_FLAG) $(LDFLAGS_AUX)

#########
#  End  #
#########