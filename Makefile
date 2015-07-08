SOURCES = $(wildcard "src/kernel/*.lua")

build: ldos.lsys

rebuild: clean build

clean:
	rm ldos.lsys

ldos.lsys: ${SOURCES}
	cat src/kernel/*.lua > ldos.lsys
