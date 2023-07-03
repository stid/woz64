BUILD_PATH = ./bin
KICKASS_BIN = /Applications/KickAssembler/KickAss.jar
PRG_FILE = ${BUILD_PATH}/main.prg
CRT_FILE = ${BUILD_PATH}/woz.crt

.PHONY: all build eprom clean run

all: build

build: ${PRG_FILE} ${CRT_FILE}

eprom: ${PRG_FILE} ${CRT_FILE}
	cartconv -i ${CRT_FILE} -o ${BUILD_PATH}/woz.bin

clean:
	rm -Rf $(BUILD_PATH)

run: build
	x64sc $(CRT_FILE)

${BUILD_PATH}:
	mkdir -p $(BUILD_PATH)

${PRG_FILE}: ${BUILD_PATH}
	java -jar ${KICKASS_BIN} -odir ${BUILD_PATH} -log ${BUILD_PATH}/buildlog.txt -showmem ./main.asm

${CRT_FILE}: ${PRG_FILE}
	cartconv -t normal -n "woz" -i $(PRG_FILE) -o $(CRT_FILE)