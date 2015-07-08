SOURCES = $(wildcard "src/kernel/*.lua")

build: ldos.lsys

ldos.lsys: ${SOURCES}
	cat kernel/*.lua > build/System
