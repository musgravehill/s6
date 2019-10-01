/*

  TODO
  CHECK GPS-accuracy! UBX-messages приходят даже когда модуль не ловит спутники, приходят lat=17 lon=17 h=4000m

    USE RESISTOR 4.7K TO S.PORT FROM 5v-ARDUINO.

    The default S.Port rate for polling a GPS is 1 hz.

    Use hardware serial for GPS. Disconnect GPS when programming.


*/

#include "incl.h"

FrSkySportTelemetry frsky_telemetry;
FrSkySportSensorFcs sensor_fcs_main;
FrSkySportSensorGps sensor_gps;


//sys vars
#define GPS_BAUDRATE 57600L

UbxGpsNavPosllh<HardwareSerial> gps(Serial); // GPS on HardwareSerial //NEO-6M does NOT support NavPvt-messages UBX-protocol

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


#define SYS_ADC_PIN_acc_main A0
#define SYS_ADC_PIN_acc_video A1

//TIMEMACHINE
uint32_t TIMEMACHINE_prevMicros_1ms = 0L;
uint32_t TIMEMACHINE_prevMicros_1103ms = 0L;

void setup() {
  delay(100);
  frsky_telemetry.begin(FrSkySportSingleWireSerial::SOFT_SERIAL_PIN_12,  &sensor_gps, &sensor_fcs_main);
  gps.begin(GPS_BAUDRATE);
  analogReference(DEFAULT); //0..5 V on 5v_arduino
}

void loop() {
  TIMEMACHINE_process();
  GPS_process();
}



