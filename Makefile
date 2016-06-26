KERNEL_SOURCES = $(wildcard "src/kernel/*.lua")
SHELL_SOURCES = $(wildcard "src/shell/*.lua")

build: LDOS.SYS COMMAND.COM

rebuild: clean build

clean:
	rm LDOS.SYS
	rm COMMAND.COM

LDOS.SYS: ${KERNEL_SOURCES}
	cat src/kernel/*.lua > LDOS.SYS

COMMAND.COM: ${SHELL_SOURCES}
	cat src/shell/*.lua > COMMAND.COM
