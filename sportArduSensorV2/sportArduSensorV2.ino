/*
    USE RESISTOR 4.7K TO S.PORT FROM 5v-ARDUINO.

    The default S.Port rate for polling a GPS is 1 hz.

    Use hardware serial for GPS. Disconnect GPS when programming.

    Also note that to avoid interrupt conflict with the mentioned SoftwareSerial library you need to disable attitude (roll/pitch)
    sensing in the NazaDecoder library by uncommenting the following line in NazaDecoder.h file:
  //#define ATTITUDE_SENSING_DISABLED
*/

#include "incl.h"

FrSkySportTelemetry frsky_telemetry;
FrSkySportSensorFcs sensor_fcs_main;
FrSkySportSensorGps sensor_gps;

TinyGPSPlus GPS_parser;

//sys vars
float GPS_lat = 0;
float GPS_lng = 0;
int16_t GPS_alt; //+- m
int8_t GPS_speed; // m/s
float    GPS_course; // 90.23 Course over ground in degrees (0-359, 0 = north)
int16_t GPS_y, GPS_m, GPS_d; //17, 4, 29,  Date (year - 2000, month, day)
int16_t GPS_h, GPS_i, GPS_s; // 12,59, 59);   // Time (hour, minute, second) - will be affected by timezone setings in your radio
byte GPS_sat_count = 0;

float SYS_acc_main_v = 0.0f;
float SYS_acc_video_v = 0.0f;

#define GPS_SAT_MIN_COUNT 1
#define SYS_ADC_PIN_acc_main A0
#define SYS_ADC_PIN_acc_video A1

//TIMEMACHINE
uint32_t TIMEMACHINE_prevMicros_1ms = 0L;
uint32_t TIMEMACHINE_prevMicros_1103ms = 0L;

void setup() {
  delay(100);
  frsky_telemetry.begin(FrSkySportSingleWireSerial::SOFT_SERIAL_PIN_12,  &sensor_gps, &sensor_fcs_main);
  delay(100);
  Serial.begin(57600);
  delay(100);
  Serial.println(F("$PMTK300,1000,0,0,0,0*1C")); //1Hz for MTK chipset!!!!!!
  delay(100);
  Serial.flush();
  analogReference(DEFAULT); //0..5 V on 5v_arduino
}

void loop() {
  TIMEMACHINE_process();
  GPS_process();
}



