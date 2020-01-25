BUILD_PATH = ./bin
KICKASS_BIN = /opt/develop/stid/c64/KickAssembler/KickAss.jar

all: build

build:
	java -jar ${KICKASS_BIN} -odir ${BUILD_PATH} -log ${BUILD_PATH}/buildlog.txt -showmem ./main.asm
	cartconv -t normal -name "woz" -i ${BUILD_PATH}/main.prg -o ${BUILD_PATH}/woz.crt

eprom:
	java -jar ${KICKASS_BIN} -odir ${BUILD_PATH} -log ${BUILD_PATH}/buildlog.txt -showmem ./main.asm
	cartconv -t normal -name "woz" -i ${BUILD_PATH}/main.prg -o ${BUILD_PATH}/woz.crt
	cartconv -i ${BUILD_PATH}/woz.crt -o ${BUILD_PATH}/woz.bin

clean:
	rm -Rf ./bin

