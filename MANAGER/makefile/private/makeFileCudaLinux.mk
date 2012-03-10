# Version 	: 0.0.3
# Date		: 26.01.2012
# Author 	: Cedric.Bilat@he-arc.ch
#
# See 		: OptionCompilateur.txt
#			  MakeFileNotice.txt
#
# Hyp		: Application that must be in path
#				nvcc
#				make
#				g++
#				gcc
#

######################
#    Temp	       #
######################

# ---------
#  java
#----------

#TODO necessaire sous linux ?

#JAVA_HOME=/usr/lib/jvm/java-6-sun-1.6.0.26
#JAVA_INCLUDE_JNI=${JAVA_HOME}/include
#JAVA_INCLUDE_JNI:=${JAVA_INCLUDE_JNI}:${JAVA_HOME}/include/linux

#C_INCLUDE_PATH:=${C_INCLUDE_PATH}:${JAVA_INCLUDE_JNI}
#CPLUS_INCLUDE_PATH:=${CPLUS_INCLUDE_PATH}:${JAVA_INCLUDE_JNI}
#CPATH:=${CPATH}:${JAVA_INCLUDE_JNI}
#INCLUDE:=${INCLUDE}:${JAVA_INCLUDE_JNI}

# ---------
#  Cuda 4.1
#----------

#CUDA_HOME=/usr/local/cuda
#CUDA_BIN=${CUDA_HOME}/bin
#CUDA_LIB=${CUDA_HOME}/lib 
#CUDA_LIB_64=${CUDA_HOME}/lib64

#CUDA_INCLUDE_MAIN:=${CUDA_HOME}/include
#CUDA_INCLUDE_2:=${CUDA_INCLUDE_MAIN}/CL
#CUDA_INCLUDE_3:=${CUDA_INCLUDE_MAIN}/crt
#CUDA_INCLUDE_4:=${CUDA_INCLUDE_MAIN}/thrust
#CUDA_INCLUDE:=${CUDA_INCLUDE_MAIN}:${CUDA_INCLUDE_2}:${CUDA_INCLUDE_3}:${CUDA_INCLUDE_4}

#C_INCLUDE_PATH:=${C_INCLUDE_PATH}:${CUDA_INCLUDE}
#CPLUS_INCLUDE_PATH:=${CPLUS_INCLUDE_PATH}:${CUDA_INCLUDE}
#CPATH:=${CPATH}:${CUDA_INCLUDE}
#INCLUDE:=${INCLUDE}:${CUDA_INCLUDE}

#LD_LIBRARY_PATH:=${LD_LIBRARY_PATH}:${CUDA_LIB_64}
#LIBRARY_PATH:=${LIBRARY_PATH}:${CUDA_LIB_64}

# ---------
#  Cula r14dense
#----------

#C_INCLUDE_PATH:=${C_INCLUDE_PATH}:${CULA_INC_PATH} 
#CPLUS_INCLUDE_PATH:=${CPLUS_INCLUDE_PATH}:${CULA_INC_PATH}
#CPATH:=${CPATH}:${CULA_INC_PATH}
#INCLUDE:=${INCLUDE_PATH}:${CULA_INC_PATH}

#LD_LIBRARY_PATH:=${LD_LIBRARY_PATH}:${CULA_LIB_PATH_64} 
#LIBRARY_PATH:=${LIBRARY_PATH}:${CULA_LIB_PATH_64} 

######################
#   Init	     #
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

# -----------------
#   Compiling
#------------------


# -----------------
#   linking
#------------------

# ---------
#  Cuda 4.1
#----------

CUDA_LIB_FILES_l:=${CUDA_LIB_FILES_l} -lcudart
CUDA_LIB_FILES_l:=${CUDA_LIB_FILES_l} -lcublas
CUDA_LIB_FILES_l:=${CUDA_LIB_FILES_l} -lcufft
CUDA_LIB_FILES_l:=${CUDA_LIB_FILES_l} -lcuinj
CUDA_LIB_FILES_l:=${CUDA_LIB_FILES_l} -lcurand
CUDA_LIB_FILES_l:=${CUDA_LIB_FILES_l} -lcusparse
CUDA_LIB_FILES_l:=${CUDA_LIB_FILES_l} -lnpp

#hyp : ${CUDA_LIB_64} must be define before or outside the makefile

CUDA_LIB_L:=-L ${CUDA_LIB_64}

# ---------
#  Cula r14dense
#----------

CULA_LIB_FILES_l:=${CULA_LIB_FILES_l} -lcula_core
CULA_LIB_FILES_l:=${CULA_LIB_FILES_l} -lcula_lapack 

#hyp : ${CULA_LIB_PATH_64} must be define before or outside the makefile

CULA_LIB_L:=-L ${CULA_LIB_PATH_64}

########
# Path #
########

SRC_ROOT:=src
TARGET_OBJ:=${TARGET_PATH}/obj
TARGET_BIN:=${TARGET_PATH}/bin
TARGET_CUBIN:=${TARGET_PATH}/cubin

########
# Cuda #
########

NVCC := nvcc
PTXAS_FLAGS := -fastimul
OBJ_EXTENSION:=o
OPTION_SEPARATOR:=-#attention, end without space
LINK_FLAG_DLL:=-shared #with space ! pour nvcc
EXTENSION_LIB:=.a
EXTENSION_DLL:=.so
LIB_PREFIXE:=lib# example : libXXX.a
LIB_FLAG_SEPARATOR:=l #attention end with space!
LIB_PATH_SEPARATOR:=L #attention end with space!

########
#32/64 #
########

ifeq ($(ARCHI_32_64),64)
	#override NVCCFLAGS	+= -m64 	#Deprecated!
	#override CXXLDFLAGS+=/MACHINE:X64 	#Deprecated!	
endif

TARGET_NAME:=$(TARGET_NAME)$(ARCHI_32_64)

###########
# jcuda   #
###########

# Goal :	 keep intermediate .cubin requiered by jcuda
# Solution : 	 All intermediate files are stored in --keep-dir current directory! 

override NVCCFLAGS += -keep -keep-dir ${TARGET_CUBIN}

############
# optimisation #
############

override NVCCFLAGS += -use_fast_math#idem -ftz=true -prec_div=false -prec_sqrt=false
override NVCCFLAGS += --fmad=true 

############
#Set files #
############

SRC_PATH:=$(shell find $(SRC_ROOT) -type d)	

ifdef SRC_AUX
	SRC_PATH_AUX:=$(shell find $(SRC_AUX) -type d)
else
	SRC_PATH_AUX:=
endif

SRC_PATH_ALL:=$(SRC_PATH) $(SRC_PATH_AUX)
SRC_SO_FILES:=$(foreach dir,$(SRC_PATH_ALL),$(wildcard $(dir)/*.so))

# Libraries au format standard
#
#	Input : 
#		SRC_PATH_ALL
#	Output :
#		All files 
#			libXXX.a
#		 	libXXX.so
#			XXX.so
#		Excepted
#			XXX.a 
#	Goals :
#		Les .a prefixe par lib (example libXXX.a) seront donnee a GCC sous la forme -lXXX)
#		Alors que les YYY.a devront etre donner a GCC sous la forme YYY.a
#	Convention
#		Sous linux les .a standards sont libXXX.a
#		Les YYY.a sont non standards.
#
SRC_A_FILES_STANDART:=$(foreach dir,$(SRC_PATH_ALL),$(wildcard $(dir)/$(LIB_PREFIXE)*$(EXTENSION_LIB)))
SRC_A_FILES_STANDART+=$(SRC_SO_FILES)

# Libraries au format non standard
#
#	Input : 
#		SRC_PATH_ALL
#	Output :
#		All files XXX.a (without libXXX.a)
#	Objectifs :
#		Les .a prefixer par lib (libXXX.a) seront donnee a GCC sous la forme -lXXX
#		Alors que les YYY.a devront etre donner a GCC sous la forme YYY.a avec la path complet (par exemple ../libs/YYY.a)
#
SRC_A_FILES_NOT_STANDARD:=$(foreach dir,$(SRC_PATH_ALL),$(filter-out $(dir)/$(LIB_PREFIXE)%$(EXTENSION_LIB),$(wildcard $(dir)/*$(EXTENSION_LIB))))

SRC_CPP_FILES := $(foreach dir,$(SRC_PATH_ALL),$(wildcard $(dir)/*.cpp)) 
SRC_C_FILES := $(foreach dir,$(SRC_PATH_ALL),$(wildcard $(dir)/*.c)) 
SRC_CU_FILES  := $(foreach dir,$(SRC_PATH_ALL),$(wildcard $(dir)/*.cu)) 

OBJ_FILES_CPP:= $(SRC_CPP_FILES:.cpp=.$(OBJ_EXTENSION))
OBJ_FILES_C:= $(SRC_C_FILES:.c=.$(OBJ_EXTENSION))
OBJ_FILES:= ${OBJ_FILES_CPP} ${OBJ_FILES_C}
OBJ_FILES:= $(addprefix $(TARGET_OBJ)/,$(notdir $(OBJ_FILES)))

CU_FILES := $(SRC_CU_FILES:.cu=.$(OBJ_EXTENSION))
CU_FILES := $(addprefix $(TARGET_OBJ)/,$(notdir $(CU_FILES))) 

OBJ_CU_FILES:=$(OBJ_FILES) $(CU_FILES)

#################
# PREPARE FLAGS	#
#################

#only fileName (./libs/libXXX.a ./libs/YYY.so -> lixXXX.a YYY.so)
LIB_FLAG:=$(notdir $(SRC_A_FILES_STANDART))

#removing prefix lib (libXXX.a libYYY.a libZZZ.so -> XXX.a YYY.a ZZZ.so)
LIB_FLAG:=$(subst $(LIB_PREFIXE),,$(LIB_FLAG))#remplace lib par rien

#Delete extension .a (XXX YYY)
LIB_FLAG:=$(LIB_FLAG:$(EXTENSION_LIB)=)

#Delete extension .so (AAA.so BBB.so -> AAA BBB)
LIB_FLAG:=$(LIB_FLAG:$(EXTENSION_DLL)=)

#ADDING user specified lib  (GL GLUT gomp ...)
LIB_FLAG+=$(ADD_LIBRARY_FILES)

# Input :
#	list lib to delete example (AAA ZZZ)
#
#	before : LIB_FLAG (XXX YYY ZZZ)
#	after  : LIB_FLAG (XXX YYY) without ZZZ
LIB_FLAG:=$(filter-out $(EXCLUDE_LIBRARY_FILES),$(LIB_FLAG))

#Adding Lib FLAG separator (XXX YYY -> -lXXX -lYYY)
LIB_FLAG:=$(addprefix $(OPTION_SEPARATOR)$(LIB_FLAG_SEPARATOR),$(LIB_FLAG))
LIB_FLAG+=$(CUDA_LIB_FILES_l) $(CULA_LIB_FILES_l)

#Adding Lib path FLAG separator -L (../AAA ./BBB -> -L../AAA _L./BBB)
LIB_PATH_FLAG:=$(addprefix $(OPTION_SEPARATOR)$(LIB_PATH_SEPARATOR),$(SRC_PATH_ALL))
LIB_PATH_FLAG+=$(CUDA_LIB_L) $(CULA_LIB_L)

#Adding Include FLAG separator
SRC_HEADER_I := $(addprefix  $(OPTION_SEPARATOR)I ,$(SRC_PATH_ALL))
ALL_HEADERS_I:= $(SRC_HEADER_I) 

#Injection variable in .cpp code (VAR1 VAR2 -> -DVAR1 -DVAR2)
CODE_DEFINE_VARIABLES_D:= $(addprefix  -D,$(CODE_DEFINE_VARIABLES))

override NVCCFLAGS   += $(ALL_HEADERS_I) 
override NVCCLDFLAGS += $(LIB_PATH_FLAG) $(LIB_FLAG) $(SRC_A_FILES_NOT_STANDARD)
override CXXFLAGS += $(CODE_DEFINE_VARIABLES_D)

#Ajoute automatiquement gomp(gcc) or iomp5(Intel)  si on use OpenMP
ifneq (, $(findstring openmp,$(CXXFLAGS)))#findstring return vide si openmp pas trouver!
	ADD_LIBRARY_FILES+=gomp#iomp5 pour intel
endif

#Directory search path (use implicit in rules)
VPATH := $(SRC_PATH_ALL)

###########
#Extension#
###########

ifeq ($(TARGET_MODE),SHARED_LIB)
	override NVCCLDFLAGS+=$(LINK_FLAG_DLL) 
	override CXXFLAGS += -fPIC -fvisibility=hidden
	TARGET_NAME_FULL=lib$(TARGET_NAME).so
endif

ifeq ($(TARGET_MODE),EXE)
	TARGET_NAME_FULL=$(TARGET_NAME).run
endif

TARGET:=$(TARGET_BIN)/$(TARGET_NAME_FULL)
TARGET_DEPLOY:=$(TARGET_DEPLOY_PATH)/$(TARGET_NAME_FULL)

#Adding " " around CXXFLAGS and CXXLDFLAGS, otherwise we can't specifie more than one options !
override CXXFLAGS:=" $(CXXFLAGS) " 
override CXXLDFLAGS:=" $(CXXLDFLAGS) " 

###########
#time chrono#
###########

override TIME_START:=$(shell date +%T)
TIME_CURRENT=$(shell date +%T)
#TIME_DELTA:=$(shell echo $(TIME_CURRENT) - $(TIME_START) | bc) #marche pas sous win, a tester sous linux

######################
#        Rules       #
######################

################
#.o->.run      #
################

$(TARGET) : $(OBJ_CU_FILES)
#@echo "debug link: "$(NVCC) $(NVCCLDFLAGS) -Xlinker $(CXXLDFLAGS) -link $^ -o $(TARGET)
	@echo ""
	@echo "[CBI]->linking to "$(TARGET)
	@$(NVCC) $(NVCCLDFLAGS) -Xlinker $(CXXLDFLAGS) $^ -o $(TARGET)
	@echo ""
	@echo "=================================================================================="
	@echo "[CBI]->Target Name	: "$(TARGET_NAME)
	@echo "[CBI]->Type	 		: "$(TARGET_MODE)
	@echo "[CBI]->Arch	 		: "$(ARCHI_32_64)
	@echo "[CBI]->OS	 		: "$(OS)
	@echo "[CBI]->User	 		: "$(USER)
	@echo "[CBI]->Src_aux 		: "$(SRC_AUX)
	@echo "[CBI]->Location 	: "$(TARGET)
	@echo "[CBI]->Deploy 		: "$(TARGET_DEPLOY_PATH)
	@echo "[CBI]->Compilateur 	: g++ && "${NVCC}
	@echo "[CBI]->Task			: End Compiling-Linking !" 
	@echo "[CBI]->Time			: "${TIME_CURRENT} 
	@echo "=================================================================================="
	@echo ""

# -o =outfile
# tabulation obligatoire before @

################
#   .cpp->.o   #
################

$(TARGET_OBJ)/%.$(OBJ_EXTENSION) :%.cpp
#@echo "debug : compil cpp"$(NVCC) $(NVCCFLAGS) -odir $(TARGET_OBJ) -Xcompiler $(CXXFLAGS) -c $< -o $@
	@echo "[CBI]->compiling .cpp : "$<
	@$(NVCC) $(NVCCFLAGS) -odir $(TARGET_OBJ) -Xcompiler $(CXXFLAGS) -o $@ -c $<

# -c = compilation
# -o =outfile

################
#   .c->.o   #
################

$(TARGET_OBJ)/%.$(OBJ_EXTENSION) :%.c
#@echo "debug : compil cpp"$(NVCC) $(NVCCFLAGS) -odir $(TARGET_OBJ) -Xcompiler $(CXXFLAGS) -c $< -o $@
	@echo "[CBI]->compiling .c : "$<
	@$(NVCC) $(NVCCFLAGS) -odir $(TARGET_OBJ) -Xcompiler $(CXXFLAGS) -o $@ -c $<

# -c = compilation
# -o =outfile

################
#   .cu->.o   #
################

$(TARGET_OBJ)/%.$(OBJ_EXTENSION) :%.cu
#@echo "debug : compil cu : "@$(NVCC) $(NVCCFLAGS) -odir $(TARGET_OBJ) -Xcompiler $(CXXFLAGS) -c $< -o $@
	@echo "[CBI]->compiling .cu : "$<
	@$(NVCC) $(NVCCFLAGS) -odir $(TARGET_OBJ) -Xcompiler $(CXXFLAGS) -c $< -o $@

# -c = compilation
# -o =outfile

######################
#        TARGET      #
######################

#all: version help
#all: echoing $(TARGET) deploy 
all: echoing init $(TARGET) deploy cleanTempCudaFile
	@echo ""
	
version:
	@echo ""
	@nvcc --version
	@echo ""
	@gcc --version
	@echo ""
	@g++ --version
	@echo ""
	@make --version
	@echo ""
	@bash --version
	@echo ""

help:
	@echo ""
	@nvcc --help
	
echoCudaCulaVariable:
	@echo ""
	@echo "Cuda variables : (Empty is not a good sign!)"
	@echo "path  .so : CUDA_LIB_L       =" ${CUDA_LIB_L}
	@echo "files .so : CULA_LIB_FILES_l ="${CULA_LIB_FILES_l}
	@echo "path  .h  : CUDA_INCLUDE     =" ${CUDA_INCLUDE}
	@echo ""
	@echo "Cula variables : (Empty is not a good sign!)"
	@echo "path  .so : CULA_LIB_L       =" ${CULA_LIB_L}
	@echo "files .so : CULA_LIB_FILES_l ="${CULA_LIB_FILES_l}
	@echo "path  .h  : CULA_INC_PATH    =" ${CULA_INC_PATH}
	@echo ""
	
cleanTempCudaFile:
	@rm -f ${TARGET_CUBIN}/*.c
	@rm -f ${TARGET_CUBIN}/*.cpp
	@rm -f ${TARGET_CUBIN}/*.gpu
	@rm -f ${TARGET_CUBIN}/*.i
	@rm -f ${TARGET_CUBIN}/*.ii
	@rm -f ${TARGET_CUBIN}/*.hash
	@rm -f ${TARGET_CUBIN}/*.ptx
	@echo ""
	@echo "[CBI]->Cleaning : Cuda temp files, excepted .cubin for JCuda"
	@echo ""

deploy:
ifdef TARGET_DEPLOY_PATH
	@$(shell cp $(TARGET) $(TARGET_DEPLOY))
	@echo ""
	@echo "[CBI]->Deploying  : "$(TARGET_NAME_FULL)
endif

run:
	@echo ""
	@echo "[CBI]->Running  : "$(TARGET)
	@$(TARGET)
	
runDeploy:
	@echo ""
	@echo "[CBI]->Running  : "$(TARGET_DEPLOY)
	@$(TARGET_DEPLOY)		

runGl:
	#gl is a wrapper of virtualgl
	#gl is necessary to run opengl remotely with turbovnc
	#OS : linux only
	@echo ""
	@echo "[CBI]->Running remote-gl : "$(TARGET)
	@gl $(TARGET) 

runGlDeploy:
	#gl is a wrapper of virtualgl
	#gl is necessary to run opengl remotely with turbovnc
	#OS : linux only!
	@echo ""
	@echo "[CBI]->Running remote-gl : "$(TARGET_DEPLOY)
	@gl $(TARGET_DEPLOY) 

echoing:
	@echo ""
	@echo "=================================================================================="
	@echo "[CBI]->Target Name	: "$(TARGET_NAME)
	@echo "[CBI]->Type	 		: "$(TARGET_MODE)
	@echo "[CBI]->Arch	 		: "$(ARCHI_32_64)
	@echo "[CBI]->OS	 		: "$(OS)
	@echo "[CBI]->User	 		: "$(USER)
	@echo "[CBI]->Src_aux 		: "$(SRC_AUX)
	@echo "[CBI]->Location 	: "$(TARGET)
	@echo "[CBI]->Deploy 		: "$(TARGET_DEPLOY_PATH)
	@echo "[CBI]->Compilateur 	: gcc && "${NVCC}
	@echo "[CBI]->Task			: Start Compiling-Linking !" 
	@echo "[CBI]->Time			: "${TIME_CURRENT} 
	@echo "=================================================================================="
	@echo ""
#@echo "[CBI]->NVCCFLAGS"
#@echo "[CBI]->"$(NVCCFLAGS)
#@echo ""
#@echo "[CBI]->NVCCLDFLAGS"
#@echo "[CBI]->"$(NVCCLDFLAGS)
#@echo ""
#@echo "[CBI]->CXXFLAGS"
#@echo "[CBI]->"$(CXXFLAGS)
#@echo ""
#@echo "[CBI]->CXXLDFLAGS"
#@echo "[CBI]->"$(CXXLDFLAGS)
#@echo ""

init:
#create folder heirerarchy TARGET_BIN_PATH iff don't exist
ifeq (,$(findstring $(TARGET_BIN),$(wildcard $(TARGET_BIN) )))
	@$(shell mkdir -p $(TARGET_BIN))
	@echo ""
	@echo "[CBI]->Create folder : "$(TARGET_BIN)
endif
#create folder heirerarchy TARGET_BIN_PATH iff don't exist
ifeq (,$(findstring $(TARGET_OBJ),$(wildcard $(TARGET_OBJ) )))
	@$(shell mkdir -p $(TARGET_OBJ))
	@echo "[CBI]->Create folder : "$(TARGET_OBJ)
endif
#create folder heirerarchy TARGET_BIN_PATH iff don't exist
ifeq (,$(findstring $(TARGET_CUBIN),$(wildcard $(TARGET_CUBIN) )))
	@$(shell mkdir -p $(TARGET_CUBIN))
	@echo "[CBI]->Create folder : "$(TARGET_CUBIN)
	@echo ""
endif

.PHONY: clean 
clean:
	@rm -f $(TARGET_OBJ)/*.o
	@rm -f $(TARGET_OBJ)/*.obj
	@rm -f $(TARGET_BIN)/*.exp
	@rm -f $(TARGET_BIN)/*.lib
	@rm -f $(TARGET)
	@rm -f $(TARGET_DEPLOY)
	@rm -f $(TARGET_CUBIN)/*
	@echo ""
	@echo "=================================================================================="
	@echo "[CBI]->Target Name	: "$(TARGET_NAME)
	@echo "[CBI]->Type	 		: "$(TARGET_MODE)
	@echo "[CBI]->Arch	 		: "$(ARCHI_32_64)
	@echo "[CBI]->OS	 		: "$(OS)
	@echo "[CBI]->User	 		: "$(USER)
	@echo "[CBI]->Src_aux 		: "$(SRC_AUX)
	@echo "[CBI]->Location 	: "$(TARGET)
	@echo "[CBI]->Deploy 		: "$(TARGET_DEPLOY_PATH)
	@echo "[CBI]->Compilateur 	: gcc && "${NVCC}
	@echo "[CBI]->Task			: Cleaning folder : "$(TARGET_OBJ) $(TARGET_BIN) $(TARGET_CUBIN)
	@echo "[CBI]->Time			: "${TIME_CURRENT} 
	@echo "=================================================================================="
	@echo ""

#rm -r #serait recursif (dangereux!!)
#rm -f #pas d'erreur si file existe pas!
	
######################
#        HELP        #
######################

# target : dependencies
#
# $@ = name of the target
# $^ = all dependencie of a target
# $< =first (unique dependency of a target) (rm, compilation,linking)
#
# @ = diminue verbosit� commande
#
# Attention : tabulation obligatoire avant commande dans rule!!
#
# http://www.gnu.org/software/make/manual/

######################
#        END         #
######################

