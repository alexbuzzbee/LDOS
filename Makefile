SOURCES = $(wildcard "src/kernel/*.lua")

build: LDOS.LSYS

rebuild: clean build

clean:
	rm LDOS.LSYS

LDOS.LSYS: ${SOURCES}
	cat src/kernel/*.lua > LDOS.LSYS
