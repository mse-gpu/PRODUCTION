common :  regroupe tout les fichiers commun au projet :

	In Makefile dataProject.mk
	
		SRC_AUX+= ../PRODUCTION/commonExt/common/include
		
windows : regroupe tout les fichiers propres au projet sous Windows (GLEW et GLUT)

	In MakeFile visual.mk, intelWin.mk,cudaWin.mk et mingw.mk
	
		SRC_AUX+= ../PRODUCTION/commonExt/windows
		
linux : regroupe tout les fichiers propres au projet sous Linux
	
	In Makefile gcc.mk, cudaWin.mk et intelLinux.mk

		SRC_AUX+= ../PRODUCTION/commonExt/linux
		
cuda : regroupe tout les fichier lorsque l'on fait du Cuda avec GLImage sous Linux et windows

	In Makefile cudaLinux.mk et cudaWind.mk

		SRC_AUX+= ../PRODUCTION/commonExt/cuda