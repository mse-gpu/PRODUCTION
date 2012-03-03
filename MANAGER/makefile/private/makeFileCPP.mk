# Version 	: 0.0.2
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

#######################
#    Temp	       #
######################

# Hyp		: Environement Variables must be set
#
#				ARCHI_32_64	: 32 or 64

######################
#    Variables       #
######################

#OS:=$(shell uname)
#MACHINE:=${shell uname -m}

########
#32/64 #
########

TARGET_NAME:=$(TARGET_NAME)$(ARCHI_32_64)

########
#setfile #
########

OBJ_FILES_CPP:= $(SRC_CPP_FILES:.cpp=.$(EXTENSION_OBJ))
OBJ_FILES_C:= $(SRC_C_FILES:.c=.$(EXTENSION_OBJ))

OBJ_FILES:= ${OBJ_FILES_CPP} ${OBJ_FILES_C}

##########
# TARGET #
##########

TARGET_NAME_EXE:=$(TARGET_NAME).${EXTENSION_EXE}
TARGET_NAME_DLL:=${LIB_PREFIXE}$(TARGET_NAME).$(EXTENSION_DLL)
TARGET_NAME_LIB:=${LIB_PREFIXE}$(TARGET_NAME).${EXTENSION_LIB}

TARGET_EXE:=${TARGET_BIN_PATH}/$(TARGET_NAME_EXE)
TARGET_DLL:=${TARGET_BIN_PATH}/$(TARGET_NAME_DLL)
TARGET_LIB:=${TARGET_BIN_PATH}/$(TARGET_NAME_LIB)
TARGET_OBJ:=$(addprefix $(TARGET_OBJ_PATH)/,$(notdir $(OBJ_FILES)))

#Selection de la target en fonction TARGET_MODE
ifeq ($(TARGET_MODE),EXE)
	TARGET:=${TARGET_EXE}
	TARGET_DEPLOY:=$(TARGET_DEPLOY_PATH)/$(TARGET_NAME_EXE)
endif

ifeq ($(TARGET_MODE),SHARED_LIB)
	TARGET:=${TARGET_DLL}
	TARGET_DEPLOY:=$(TARGET_DEPLOY_PATH)/$(TARGET_NAME_DLL)
	override LDFLAGS += $(LINK_FLAG_DLL)
endif

ifeq ($(TARGET_MODE),STATIC_LIB)
	TARGET:=${TARGET_LIB}
	TARGET_DEPLOY:=$(TARGET_DEPLOY_PATH)/$(TARGET_NAME_LIB)
endif

ifeq (,$(findstring $(RESOURCES_PATH),$(wildcard $(RESOURCES_PATH) )))
	nbFileRessources:=0
else
	nbFileRessources:=$(shell ls $(RESOURCES_PATH) | wc -l )
endif

VPATH := $(SRC_PATH_ALL) 

#time chrono
override TIME_START:=$(shell date +%T)
TIME_CURRENT=$(shell date +%T)
#TIME_DELTA:=$(shell echo $(TIME_CURRENT) - $(TIME_START) | bc) #marche pas

######################
#        Rules       #
######################

# tabulation obligatoire before @

################
#   .o->.exe   #
################

${TARGET_EXE}:$(TARGET_OBJ)
#@echo "debug link: "$(CXX) $(OUT_FILE_LINK)${TARGET_EXE} $^ $(LDFLAGS)
	@echo ""
	@echo "[CBI]->linking to "$(TARGET)
	@$(CXX) $(OUT_FILE_LINK)${TARGET_EXE} $^ $(LDFLAGS)
	@echo ""
#Only for Visual (include .manifest in .exe)
ifdef EMBED_MANIFEST 
	@$(EMBED_MANIFEST) -nologo -manifest $@.manifest -outputresource:$@
endif
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
	@echo "[CBI]->Compilateur 	: "${COMPILATEUR}   [CXX=$(CXX)]
	@echo "[CBI]->Task			: End Compiling-Linking !" 
	@echo "[CBI]->Time			: "${TIME_CURRENT} 
	@echo "=================================================================================="
	@echo ""
	
################
#   .o->.dll   #
################

${TARGET_DLL}:$(TARGET_OBJ)
#@echo "debug link: "$(CXX) $(OUT_FILE_LINK)${TARGET_DLL} $^ $(LDFLAGS)
	@echo ""
	@echo "[CBI]->linking to "$(TARGET)
	@$(CXX) $(OUT_FILE_LINK)${TARGET_DLL} $^ $(LDFLAGS)
	@echo ""
ifdef EMBED_MANIFEST 	#Only for Visual (include .manifest in .dll)
	@$(EMBED_MANIFEST) -manifest $@.manifest -outputresource:$@
endif
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
	@echo "[CBI]->Compilateur 	: "${COMPILATEUR}   [CXX=$(CXX)]
	@echo "[CBI]->Task			: End Compiling-Linking !" 
	@echo "[CBI]->Time			: "${TIME_CURRENT} 
	@echo "=================================================================================="
	@echo ""
	
################
#  .o->.lib    #
################

${TARGET_LIB}:$(TARGET_OBJ)
#@echo "debug link: "${AR} ${AR_OUT_FLAG}${TARGET_LIB} ${ARFLAGS} $^
	@echo ""
	@echo "[CBI]->linking to "$(TARGET)
	@${AR} ${AR_OUT_FLAG}${TARGET_LIB} ${ARFLAGS} $^
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
	@echo "[CBI]->Compilateur 	: "${COMPILATEUR}   [CXX=$(CXX)]
	@echo "[CBI]->Archiveur 	: "$(AR)
	@echo "[CBI]->Task			: End Compiling-Linking !" 
	@echo "[CBI]->Time			: "${TIME_CURRENT} 
	@echo "=================================================================================="
	@echo ""
	
################
#   .cpp->.o   #
################

$(TARGET_OBJ_PATH)/%.$(EXTENSION_OBJ):%.cpp  
#@echo "debug : compil" $(CXX) $(CXXFLAGS) $(OUT_FILE_COMPILE)$@ -c  $< 
ifeq (${COMPILATEUR},mingw)
	@echo "[CBI]->compiling .cpp : "$<
endif
ifeq (${COMPILATEUR},g++)
	@echo "[CBI]->compiling .cpp : "$<
endif
	@$(CXX) $(CXXFLAGS) $(OUT_FILE_COMPILE)$@ -c  $< 
	
# -c = compilation

################
#   .c->.o   #
################

$(TARGET_OBJ_PATH)/%.$(EXTENSION_OBJ):%.c  
#@echo "debug : compil" $(CXX) $(CXXFLAGS) $(OUT_FILE_COMPILE)$@ -c  $< 
ifeq (${COMPILATEUR},mingw)
	@echo "[CBI]->compiling .c : "$<
endif
ifeq (${COMPILATEUR},g++)
	@echo "[CBI]->compiling .c : "$<
endif
	@$(CXX) $(CXXFLAGS) $(OUT_FILE_COMPILE)$@ -c  $< 
	
# -c = compilation

######################
#        TARGET      #
######################

all: echoing init $(TARGET) deploy
	@echo ""
	@echo "[CBI]->"$(TARGET)" : End ALL!"
	
version:
	@echo ""
	@$(VERSION_CXX)
	@echo ""

help:
	@echo ""
	@$(CXX_HELP)
	@echo ""

deploy:
ifdef TARGET_DEPLOY_PATH
	@$(shell cp $(TARGET) $(TARGET_DEPLOY))	
	@echo ""
	@echo "[CBI]->Deploying  : "$(TARGET_DEPLOY)
ifneq ($(nbFileRessources),0)
	@echo "[CBI]->Deploying  : copying resources : "$(RESOURCES_PATH)" -> "${TARGET_DEPLOY_PATH}
	@cp -f -r $(RESOURCES_PATH)/* $(TARGET_DEPLOY_PATH)
endif
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

init:
#create folder heirerarchy TARGET_BIN_PATH iff don't exist
ifeq (,$(findstring $(TARGET_BIN_PATH),$(wildcard $(TARGET_BIN_PATH) )))
	@$(shell mkdir -p $(TARGET_BIN_PATH))
	@echo ""
	@echo "[CBI]->Create folder : "$(TARGET_BIN_PATH)
endif
#create folder heirerarchy TARGET_BIN_PATH iff don't exist
ifeq (,$(findstring $(TARGET_OBJ_PATH),$(wildcard $(TARGET_OBJ_PATH) )))
	@$(shell mkdir -p $(TARGET_OBJ_PATH))
	@echo "[CBI]->Create folder : "$(TARGET_OBJ_PATH)
	@echo ""
endif
	
# -p permet de créer l’arborescence complete si existe pas

.PHONY: clean 
clean:
	@rm -f $(TARGET_OBJ_PATH)/*.o
	@rm -f $(TARGET_OBJ_PATH)/*.obj
	@rm -f $(TARGET_BIN_PATH)/*.exp
	@rm -f $(TARGET_BIN_PATH)/*.html
	@rm -f $(TARGET_BIN_PATH)/*.lib
	@rm -f $(TARGET_BIN_PATH)/*.a
	@rm -f $(TARGET_BIN_PATH)/*.def
	@rm -f $(TARGET_BIN_PATH)/*.map
	@rm -f $(TARGET_BIN_PATH)/*.manifest
	@rm -f $(TARGET)
	@rm -f $(TARGET_DEPLOY)
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
	@echo "[CBI]->Compilateur 	: "${COMPILATEUR}   [CXX=$(CXX)]
	@echo "[CBI]->Task			: Cleaning folder : "$(TARGET_OBJ_PATH) $(TARGET_BIN_PATH)
	@echo "[CBI]->Time			: "${TIME_CURRENT} 
	@echo "=================================================================================="
	@echo ""

# -v verbose
# -r recursif
# -f pas d'erreur si file existe pas
#rm -rf #serait recursif (dangereux!!)

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
	@echo "[CBI]->Compilateur 	: "${COMPILATEUR}   [CXX=$(CXX)]
	@echo "[CBI]->Task			: Start Compiling-Linking !" 
	@echo "[CBI]->Time			: "${TIME_CURRENT} 
	@echo "=================================================================================="
	@echo ""
#@echo "[CBI]->CXXFLAGS"
#@echo "[CBI]->"$(CXXFLAGS)
#@echo ""
#@echo "[CBI]->LDFLAGS"
#@echo "[CBI]->"$(LDFLAGS)
#@echo ""

######################
#        HELP        #
######################

# target : dependencies
#
# $@ = name of the target
# $^ = all dependencie of a target
# $< =first (unique dependency of a target) (rm, compilation,linking)
#
# @ = diminue verbosite commande
#
# Attention : tabulation obligatoire avant commande dans rule!!
#
# http://www.gnu.org/software/make/manual/

######################
#        END         #
######################

