# variables for macOS + Arduino 1.8.5
SKETCH=$(PWD)
ARDUINO_DIR = /Applications/Arduino.app/Contents/Java
ARDUINO_LIB = $(HOME)/Library/Arduino15
ARDUINO_SKETCHBOOK = $(HOME)/Documents/Arduino

.PHONY: all build flash

all: build flash
	@echo > /dev/null

build: PlayaWiFi.ino.bin

PlayaWiFi.ino.bin: PlayaWiFi.ino index.h
	mkdir -p build cache
	$(ARDUINO_DIR)/arduino-builder \
		-compile \
		-logger=machine \
		-ide-version=10805 \
		-warnings=none \
		-verbose \
		-fqbn=esp8266:esp8266:d1_mini_lite:xtal=80,vt=flash,exception=disabled,ssl=all,eesz=1M,ip=lm2f,dbg=Disabled,lvl=None____,wipe=none,baud=921600 \
		-hardware $(ARDUINO_DIR)/hardware \
		-hardware $(ARDUINO_LIB)/packages \
		-hardware $(ARDUINO_SKETCHBOOK)/hardware \
		-tools $(ARDUINO_DIR)/tools-builder \
		-tools $(ARDUINO_DIR)/hardware/tools/avr \
		-tools $(ARDUINO_LIB)/packages \
		-built-in-libraries $(ARDUINO_DIR)/libraries \
		-libraries $(ARDUINO_SKETCHBOOK)/libraries \
		-prefs=build.warn_data_percentage=75 \
		-prefs=runtime.tools.python.path=$(ARDUINO_LIB)/packages/esp8266/tools/python/3.7.2-post1 \
		-prefs=runtime.tools.mkspiffs.path=$(ARDUINO_LIB)/packages/esp8266/tools/mkspiffs/2.5.0-3-20ed2b9 \
		-prefs=runtime.tools.xtensa-lx106-elf-gcc.path=$(ARDUINO_LIB)/packages/esp8266/tools/xtensa-lx106-elf-gcc/2.5.0-3-20ed2b9 \
		-build-cache $(PWD)/cache \
		-build-path $(PWD)/build \
		PlayaWiFi.ino
	mv build/PlayaWiFi.ino.bin PlayaWiFi.ino.bin

index.h: index.html
	./export-string-to-h.sh "responseHTML" < index.html > index.h

flash: PlayaWiFi.ino.bin.flashed

PlayaWiFi.ino.bin.flashed: PlayaWiFi.ino.bin
	./autoflash.sh "/dev/tty.usbserial-" "PlayaWiFi.ino.bin" 1
	cp PlayaWiFi.ino.bin PlayaWiFi.ino.bin.flashed

auto:
	@echo Waiting for changes...
	@while true; do make; sleep 1; done

clean:
	rm -rf build cache logs PlayaWiFi.ino.bin.flashed
