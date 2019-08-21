#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <DNSServer.h>
#include <EEPROM.h>

#define WIFI_NAME "Burning Man Free WiFi"

const byte DNS_PORT = 53;
IPAddress apIP(192, 168, 1, 1);
DNSServer dnsServer;
ESP8266WebServer webServer(80);

#include "index.h"

int ledState = LOW;  
unsigned long previousMillis = 0; 
unsigned long interval;

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  
  EEPROM.begin(3);

  // blink the LED twice as fast on first run so we know it was successfully programmed
  unsigned int runCount = EEPROM.read(2);
  EEPROM.write(2, runCount + 1);
  EEPROM.commit();
  interval = runCount > 0 ? 500 : 100;
  
  WiFi.mode(WIFI_AP);
  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));
  WiFi.softAP(WIFI_NAME, NULL, NULL, false, 8);

  dnsServer.start(DNS_PORT, "*", apIP);

  webServer.on("/favicon.ico", []() {
    webServer.send(404, "text/plain", "nope");
  });
  webServer.onNotFound([]() {
    unsigned long count = (EEPROM.read(0) + EEPROM.read(1) * 256) + 1;
    EEPROM.write(0, count % 256);
    EEPROM.write(1, count / 256);
    EEPROM.commit();
    webServer.send(200, "text/html", responseHTML + "\n<span style=\"color: #222\">" + String(count) + "</span>");
  });
  webServer.begin();
}

void loop() {
  dnsServer.processNextRequest();
  webServer.handleClient();

  // asynchronously blink the LED
  unsigned long currentMillis = millis();
  if (currentMillis - previousMillis >= interval) {
    previousMillis = currentMillis;
    ledState = !ledState;
    digitalWrite(LED_BUILTIN, ledState);
  }
}
