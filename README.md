# PlayaWiFi ESP8266 Firmware

## Instructions

If you are using a WeMos D1 Mini you can flash the pre-built `PlayaWiFi.ino.bin` binary to any devices prefixed with `/dev/tty.usbserial-` by running `make autoflash` and plugging in the WeMos.

Otherwise, open `PlayaWiFi.ino` in the Arduino IDE, select your board settings, then select `Sketch` > `Export compiled Binary`. Then run `./flash /dev/tty.YOUR_DEVICE_PORT ./PlayaWiFi.ino.YOUR_DEVICE_TYPE.bin` (using Arduino IDE directly will not reset the flash storage the sketch uses). If you modify `index.html`, run `make index.h` before compiling.

You can also try updating the `Makefile` with your board info, then running `make build`.
