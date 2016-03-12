### Attributes ###
LIBRARY_VERSION=0.4.4

### Targets ###

zip-framework:
	cd ${HOME}/Desktop && find RadarKit.framework -name .DS_Store -delete
	cd ${HOME}/Desktop/RadarKit.framework && find -L .
	cd ${HOME}/Desktop && zip --symlinks -r RadarKit.framework.${LIBRARY_VERSION}.zip RadarKit.framework
