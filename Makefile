SOURCES = $(wildcard "src/kernel/*.lua")

build: ldos.lsys

rebuild: clean build

clean:
	rm LDOS.LSYS

LDOS.LSYS: ${SOURCES}
	cat src/kernel/*.lua > LDOS.LSYS
