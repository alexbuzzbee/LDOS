KERNEL_SOURCES = $(wildcard "src/kernel/*.lua")
SHELL_SOURCES = $(wildcard "src/shell/*.lua")

build: LDOS.LSYS COMMAND.LCOM

rebuild: clean build

clean:
	rm LDOS.LSYS
	rm COMMAND.LCOM

LDOS.LSYS: ${KERNEL_SOURCES}
	cat src/kernel/*.lua > LDOS.LSYS

COMMAND.LCOM: ${SHELL_SOURCES}
	cat src/shell/*.lua > COMMAND.LCOM
