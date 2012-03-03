# Version 	: 0.0.1
# Date		: 26.01.2012
# Author 	: Cedric.Bilat@he-arc.ch
#
# See 		: OptionCompilateur.txt
#			  MakeFileNotice.txt
#
# Hyp		: Application that must be in path
#				sh
#
#			: Environement Variables must be set
#
#				JAVA_HEADER_JNI : folder of JNI header, for exemple ('%JAVA_HOME%/include' '%JAVA_HOME%/include/win32'
#	

#############
#	Path	#
#############

SRC_ROOT:=src
RESOURCES_PATH:=$(SRC_ROOT)/resources
TARGET_OBJ_PATH:=${TARGET_PATH}/obj
TARGET_BIN_PATH:=${TARGET_PATH}/bin

SRC_PATH:=$(shell find $(SRC_ROOT) -type d)
	
ifdef SRC_AUX
	SRC_PATH_AUX:=$(shell find $(SRC_AUX) -type d)
else
	SRC_PATH_AUX:=
endif

SRC_PATH_ALL:=$(SRC_PATH) $(SRC_PATH_AUX) 

ifeq  (${OS},Win)
	#PATH des Headers
	# Inputs :
	#		"Program" "File"
	# Outputs :
	#		"Program Files"
	JAVA_HEADER_JNI := $(subst  Program Files,Program Files,$(JAVA_HEADER_JNI)) #correction de "Program" "Files" en "Program Files"
else
	#rien
endif

HEADER_PATH_ALL:=$(SRC_PATH_ALL) $(JAVA_HEADER_JNI)

#############
# SET FILES	#
#############

#all
SRC_CPP_FILES:=$(foreach dir,$(SRC_PATH_ALL),$(wildcard $(dir)/*.cpp)) 
SRC_C_FILES:=$(foreach dir,$(SRC_PATH_ALL),$(wildcard $(dir)/*.c)) 
SRC_HEADER_FILES:=$(foreach dir,$(SRC_PATH_ALL),$(wildcard $(dir)/*.h)) 

#visual,intel
SRC_LIB_FILES:=$(foreach dir,$(SRC_PATH_ALL),$(wildcard $(dir)/*.lib))
SRC_DLL_FILES:=$(foreach dir,$(SRC_PATH_ALL),$(wildcard $(dir)/*.dll))

#gcc,mingw
SRC_SO_FILES:=$(foreach dir,$(SRC_PATH_ALL),$(wildcard $(dir)/*.so))
SRC_A_FILES:=$(foreach dir,$(SRC_PATH_ALL),$(wildcard $(dir)/*.a))

#nvcc
SRC_CU_FILES  := $(foreach dir,$(SRC_PATH_ALL),$(wildcard $(dir)/*.cu)) 

#########
#  End  #
#########