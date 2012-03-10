## Version 	: 0.0.3
# Date		: 26.01.2012
# Author 	: Cedric.Bilat@he-arc.ch
#
# See 		: OptionCompilateur.txt
#			  MakeFileNotice.txt
#
# Hyp		: Application that must be in path

######################
#    Variables       #
######################

ifdef IS_DEFAULT_SYS_LIBRARY_ENABLE
	DEFAULT_SYS_LIBRARY_FILES:=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib 
	DEFAULT_SYS_LIBRARY_FILES+=shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib	
endif

#flag permettant de linker dynamiquement les librairies systemes de visual (la CRT entre autre)
ifdef IS_ADVANCED_SYS_LIBRARY_ENABLE
	override CXXFLAGS+=/MD #dynamicaly link CRT with the target
else
	#override CXXFLAGS+=/MT #statically link the MS CRT to the DLL par défaut !
	# en commentaire, pour pouvoir mettre /MD pour linker own lib without activate IS_ADVANCED_SYS_LIBRARY_ENABLE
endif

# Problem :
#            /MD generate a .manifest file, this file is required then for using target
# Solution :
#            Embed the manifest in the target using mt.exe
#            SEE : http://msdn.microsoft.com/en-us/library/ms235591(v=vs.80).aspx
ifneq (, $(findstring /MD,$(CXXFLAGS)))#findstring return vide si /MD pas trouver!
	EMBED_MANIFEST:=mt.exe
endif

ifeq ($(COMPILATEUR),VISUAL)
	#Compilateur ,Archiveur (static lib)
	CXX:=cl
	AR:=lib
	
	ifdef IS_ADVANCED_SYS_LIBRARY_ENABLE
		ADVANCED_SYS_LIBRARY:=$(LIB)	#where LIB is a va set by the script vcvarsamd64.bat. Requiert speccifique .dll as msvcr90.dll for running)
		ADVANCED_SYS_LIBRARY:=$(subst  \,/,$(ADVANCED_SYS_LIBRARY)) 
		ADVANCED_SYS_LIBRARY:=$(subst  ;, ,$(ADVANCED_SYS_LIBRARY))  
		#CRT =C runtime library.
		#Only one of: libcmt.lib libcmt.lib  libcmtd.lib msvcrtd.lib msvcmrt.lib msvcurt.lib  msvcrt.lib
		#must be used
		#Choice smart 1: use msvcrt.lib (Contrainte use /MD)
		#Choice smart 2: use libcmt.lib (Contrainte use /MT)
		EXCLUDE_LIBRARY_FILES+= libcmt.lib libcmtd.lib msvcrtd.lib msvcmrt.lib 	
	endif
	
	#############
	# 	OMP		#
	#############

	ifneq (, $(findstring openmp,$(CXXFLAGS)))#findstring return vide si openmp pas trouver!
		ADD_LIBRARY_FILES+=libiomp5md.lib 
    endif
    #pas necessaire pour intel compilateur (lib  integrer d'office)
endif

ifeq ($(COMPILATEUR),INTEL)
	#Compilateur ,Archiveur (static lib)
	CXX:=icl
	AR:=xilib
		
	ifdef IS_ADVANCED_SYS_LIBRARY_ENABLE
		ADVANCED_SYS_LIBRARY:=$(LIB)	#where LIB is a va set by the script vcvarsamd64.bat. Requiert speccifique .dll as msvcr90.dll for running)
		ADVANCED_SYS_LIBRARY:=$(subst  \,/,$(ADVANCED_SYS_LIBRARY)) 
		ADVANCED_SYS_LIBRARY:=$(subst  ;, ,$(ADVANCED_SYS_LIBRARY))  
		#CRT =C runtime library.
		#Only one of: libcmt.lib libcmt.lib  libcmtd.lib msvcrtd.lib msvcmrt.lib msvcurt.lib  msvcrt.lib
		#must be used
		#Choice smart 1: use msvcrt.lib (Contrainte use /MD)
		#Choice smart 2: use libcmt.lib (Contrainte use /MT)
		EXCLUDE_LIBRARY_FILES+= libcmt.lib libcmtd.lib msvcrtd.lib msvcmrt.lib libcpmtd.lib libcpmt.lib	
	endif
endif

#############
# Extension  #
#############

EXTENSION_OBJ:=obj#
EXTENSION_LIB:=lib#
EXTENSION_DLL:=dll#
EXTENSION_EXE:=exe#
# Note enstension sans le .

#############
#Compilateur#
#############

OPTION_SEPARATOR:=/#
LIB_FLAG_SEPARATOR:=#
LIB_PATH_SEPARATOR:=/LIBPATH:#
HEADER_OPTION:=I#
OUT_FILE_COMPILE:=/Fo#attention, end without space
OUT_FILE_LINK:=/Fe#idem
LINK_TAG:=/link#
LINK_FLAG_DLL:=/DLL#
SYS_LIBRARY_FILES:=#minimum rien

LIB_PREFIXE:=#rien

VERSION_CXX:=$(CXX)
CXX_HELP:=$(CXX) /help

##########
#ARCHIVEUR#
###########

AR_OUT_FLAG:=/OUT:#Sans espace

#############
# SET FILES	#
#############

SRC_LIB_FILES+=$(foreach dir,$(ADVANCED_SYS_LIBRARY),$(wildcard $(dir)/$(EXTENSION_LIB))) 

#################
# PREPARE FLAGS	#
#################

#only fileName (./libs/XXX.lib ./libs/YYY.lib -> XXX.lib YYY.lib)
LIB_FLAG:=$(notdir $(SRC_LIB_FILES))
LIB_FLAG+=${DEFAULT_SYS_LIBRARY_FILES}

#Custom exclude libs
LIB_FLAG:=$(filter-out $(EXCLUDE_LIBRARY_FILES),$(LIB_FLAG))

#ADDING User defined LIB
LIB_FLAG+=$(ADD_LIBRARY_FILES)

#Adding Lib path FLAG separator /LIBPATH: (../AAA ./BBB -> -/LIBPATH:../AAA /LIBPATH:./BBB)
LIB_PATH_FLAG:=${SRC_PATH_ALL}
LIB_PATH_FLAG:=$(addprefix $(LIB_PATH_SEPARATOR),$(LIB_PATH_FLAG))

HEADER_FLAG:= $(addprefix $(OPTION_SEPARATOR)$(HEADER_OPTION),$(HEADER_PATH_ALL))

CODE_DEFINE_VARIABLES_D:= $(addprefix  /D,$(CODE_DEFINE_VARIABLES))

override CXXFLAGS += /nologo 
override CXXFLAGS += $(HEADER_FLAG)
override CXXFLAGS += $(CODE_DEFINE_VARIABLES_D)
override LDFLAGS += $(LINK_TAG) $(LIB_PATH_FLAG) $(LIB_FLAG) $(LDFLAGS_AUX) /nologo

#########
#  End  #
#########