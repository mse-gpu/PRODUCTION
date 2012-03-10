# Version 	: 0.0.3
# Date		: 26.01.2012
# Author 	: Cedric.Bilat@he-arc.ch
#
# See 		: OptionCompilateur.txt
#			  MakeFileNotice.txt
#
# Hyp		: Application that must be in path
#				nvcc
#				mingw32-make
#				cl
#
# 			:  Environement Variables must be set
#
#				ARCHI_32_64			:	32 or 64
#				JAVA_HEADER_JNI		:	folder of JNI header, for exemple ('%JAVA_HOME%/include' '%JAVA_HOME%/include/win32'
#				CUDA_LIB_FILES_l	:	Cuda library files, with right compilier option and without extention, exemple (-l cublas -l cuda)
#				CULA_LIB_FILES_l	:	Cula library files, with right compilier option and without extention, exemple (-l cublas -l cuda)
#				CUDA_LIB_L			:	Folder of CUDA library folder path with right compiler option exemple (-L ./folder -L %CUDA_HOME/libs)
#				CULA_LIB_L			:	Foloder of CULA library folder path with right compiler option exemple (-L ./folder -L %CULA_HOME/libs)
#				CUDA_HEADER_I		:	Folder path for Cuda header with right compiler option, exemple (-I %CUDA_HOME_SDK%/shared/inc  -I %CUDA_HOME_SDK%/shared/inc/GL)
#				CULA_HEADER_I		:	Folder path for Cula header with right compiler option, exemple (-I %CUDA_HOME_SDK%/shared/inc  -I %CUDA_HOME_SDK%/shared/inc/GL)

######################
#    Variables       #
######################

########
# Path #
########

SRC_ROOT   :=src
TARGET_OBJ:=${TARGET_PATH}/obj
TARGET_BIN:= ${TARGET_PATH}/bin
TARGET_CUBIN:=${TARGET_PATH}/cubin

########
# Cuda #
########

NVCC := nvcc
PTXAS_FLAGS := -fastimul
OBJ_EXTENSION:=obj
OPTION_SEPARATOR:=-#attention, end without space
LINK_FLAG_DLL:=-shared#attention,end without space

########
#32/64 #
########

ifeq ($(ARCHI_32_64),64)
	#override NVCCFLAGS	+= -m64 			#Plus nécessaire!
	#override CXXLDFLAGS+=/MACHINE:X64 	#Plus nécessaire! 	#En plus posait problème de guillement (à la définition de CXXLDFLAGS)
endif

TARGET_NAME:=$(TARGET_NAME)$(ARCHI_32_64)

###########
#jcuda    #
###########

# Goal :	 keep intermediate .cubin requiered by jcuda
# Solution : All intermediate files are stored in --keep-dir current directory! 
#			 Next remove all file witch don't have .cubin extension. 
#			 see target CleanNotCubin

override NVCCFLAGS += -keep -keep-dir ${TARGET_CUBIN}

############
# optimisation #
############

override NVCCFLAGS += -use_fast_math#idem -ftz=true -prec_div=false -prec_sqrt=false
override NVCCFLAGS += --fmad=true 

############
# windows #
############

ifeq ($(OS),Win)
	override NVCCFLAGS += --cl-version=2008 #onlx window, version of cl
endif


############
# Params   #
############

EXTENSION_LIB:=.lib
EXTENSION_DLL:=.dll
LIB_PREFIX:=#pas de prefixe

############
#Set files #
############

#Hyp : Shell sh
SRC_PATH:=$(shell find $(SRC_ROOT) -type d)	
ifdef SRC_AUX
	SRC_PATH_AUX:=$(shell find $(SRC_AUX) -type d)
else
	SRC_PATH_AUX:=
endif

SRC_PATH_ALL:=$(SRC_PATH) $(SRC_PATH_AUX)

SRC_CPP_FILES := $(foreach dir,$(SRC_PATH_ALL),$(wildcard $(dir)/*.cpp)) 
SRC_C_FILES := $(foreach dir,$(SRC_PATH_ALL),$(wildcard $(dir)/*.c)) 
SRC_CU_FILES  := $(foreach dir,$(SRC_PATH_ALL),$(wildcard $(dir)/*.cu)) 
SRC_LIB_FILES := $(foreach dir,$(SRC_PATH_ALL),$(wildcard $(dir)/*.lib)) $(ADD_LIBRARY_FILES)

#################
# PREPARE FLAGS #
#################

#ifneq (, $(findstring openmp,$(CXXFLAGS)))#findstring return vide si openmp pas trouver!
#	ADD_LIBRARY_FILES+=libiomp5md.lib 
#endif

#Delete extension .lib
SRC_LIB_FILES:= $(SRC_LIB_FILES:$(EXTENSION_LIB)=)

SRC_LIB_FILES_l:= $(addprefix $(OPTION_SEPARATOR)l ,$(notdir $(SRC_LIB_FILES))) 
ALL_LIB_FILES_l:= $(CUDA_LIB_FILES_l) $(CULA_LIB_FILES_l) $(SRC_LIB_FILES_l)

SRC_LIB_L:=$(addprefix $(OPTION_SEPARATOR)L ,$(SRC_PATH_ALL))

ALL_LIB_L:=$(SRC_LIB_L) $(CUDA_LIB_L) $(CULA_LIB_L)

SRC_HEADER_I := $(addprefix  $(OPTION_SEPARATOR)I ,$(SRC_PATH_ALL))
JNI_HEADER_I := $(addprefix $(OPTION_SEPARATOR)I ,$(JAVA_HEADER_JNI))
JNI_HEADER_I := $(subst  Program $(OPTION_SEPARATOR)I Files,Program Files,$(JNI_HEADER_I)) #correction de "Program -I File" en "Program File"
ALL_HEADERS_I:= $(SRC_HEADER_I) $(JNI_HEADER_I) $(CUDA_HEADER_I) $(CULA_HEADER_I)

OBJ_FILES_CPP:= $(SRC_CPP_FILES:.cpp=.$(OBJ_EXTENSION))
OBJ_FILES_C:= $(SRC_C_FILES:.c=.$(OBJ_EXTENSION))
OBJ_FILES:= ${OBJ_FILES_CPP} ${OBJ_FILES_C}
OBJ_FILES:= $(addprefix $(TARGET_OBJ)/,$(notdir $(OBJ_FILES)))

CU_FILES := $(SRC_CU_FILES:.cu=.$(OBJ_EXTENSION))
CU_FILES := $(addprefix $(TARGET_OBJ)/,$(notdir $(CU_FILES))) 

OBJ_CU_FILES:=$(OBJ_FILES) $(CU_FILES)

#Injection variable in .cpp code (VAR1 VAR2 -> -DVAR1 -DVAR2)
CODE_DEFINE_VARIABLES_D:= $(addprefix  -D,$(CODE_DEFINE_VARIABLES))

override NVCCFLAGS   += $(ALL_HEADERS_I) 
override NVCCLDFLAGS += $(ALL_LIB_L) $(ALL_LIB_FILES_l)
override CXXFLAGS += $(CODE_DEFINE_VARIABLES_D)

ifneq (, $(findstring /MD,$(CXXFLAGS)))#findstring return vide si /MD pas trouver!
	override CXXLDFLAGS+=/NODEFAULTLIB:LIBCMT
endif

#Adding " " around CXXFLAGS and CXXLDFLAGS, otherwise we can't specifie more than one options !
override CXXFLAGS:=" $(CXXFLAGS) " 
override CXXLDFLAGS:=" $(CXXLDFLAGS) "

#Directory search path(use implicit in rules)
VPATH := $(SRC_PATH_ALL)

###########
#Extension#
###########

ifeq ($(TARGET_MODE),SHARED_LIB)
	override NVCCLDFLAGS+=$(LINK_FLAG_DLL) 
	TARGET_NAME_FULL=$(TARGET_NAME).dll
endif

ifeq ($(TARGET_MODE),EXE)
	TARGET_NAME_FULL=$(TARGET_NAME).exe
endif

TARGET:=$(TARGET_BIN)/$(TARGET_NAME_FULL)
TARGET_DEPLOY:=$(TARGET_DEPLOY_PATH)/$(TARGET_NAME_FULL)

###########
#time chrono#
###########

override TIME_START:=$(shell date +%T)
TIME_CURRENT=$(shell date +%T)
#TIME_DELTA:=$(shell echo $(TIME_CURRENT) - $(TIME_START) | bc) #marche pas

###########
#visual#
###########

EMBED_MANIFEST:=mt.exe

######################
#        Rules       #
######################

################
#.o->.exe,.dll #
################

$(TARGET) : $(OBJ_CU_FILES)
#@echo "debug link: "$(NVCC) $(NVCCLDFLAGS) -Xlinker $(CXXLDFLAGS) -link $^ -o $(TARGET)
	@echo ""
	@echo "[CBI]->linking to "$(TARGET)
	@$(NVCC) $(NVCCLDFLAGS) -Xlinker $(CXXLDFLAGS) $^ -o $(TARGET)
	@echo ""
#Only for Visual (include .manifest in .exe)
	@$(EMBED_MANIFEST) -nologo -manifest $@.manifest -outputresource:$@
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
	@echo "[CBI]->Compilateur 	: VISUAL && "${NVCC}
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
#@echo "debug : compil cpp : "$(NVCC) $(NVCCFLAGS) -odir $(TARGET_OBJ) -Xcompiler $(CXXFLAGS) -c $< -o $@
#@echo "[CBI]->compiling .cpp : "$<
	@$(NVCC) $(NVCCFLAGS) -odir $(TARGET_OBJ) -Xcompiler $(CXXFLAGS)  $@ -c $<

# -c = compilation
# -o =outfile

################
#   .c->.o   #
################

$(TARGET_OBJ)/%.$(OBJ_EXTENSION) :%.c
#@echo "debug : compil cpp : "$(NVCC) $(NVCCFLAGS) -odir $(TARGET_OBJ) -Xcompiler $(CXXFLAGS) -c $< -o $@
#@echo "[CBI]->compiling .c : "$<
	@$(NVCC) $(NVCCFLAGS) -odir $(TARGET_OBJ) -Xcompiler $(CXXFLAGS)  $@ -c $<

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
	@cl 

help:
	@echo ""
	@nvcc --help
	
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

#rm -f #pas d'erreur si file existe pas!

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
	@echo "[CBI]->Compilateur 	: VISUAL && "${NVCC}
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
	@echo "[CBI]->Compilateur 	: VISUAL && "${NVCC}
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
# @ = diminue verbosité commande
#
# Attention : tabulation obligatoire avant commande dans rule!!
#
# http://www.gnu.org/software/make/manual/

######################
#        END         #
######################

