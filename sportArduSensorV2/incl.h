#include <Arduino.h>
#include <SoftwareSerial.h> //S-PORT SOFT_SERIAL_PIN_2 to SOFT_SERIAL_PIN_12 for ATmega328P

#include "UbxGpsNavPosllh.h" //from local folder sketch  //<UbxGpsNavPosllh.h> - from arduino/library folder

#include "FrSkySportTelemetry/FrSkySportSensor.h"
#include "FrSkySportTelemetry/FrSkySportSingleWireSerial.h"
#include "FrSkySportTelemetry/FrSkySportTelemetry.h"
#include "FrSkySportTelemetry/FrSkySportPolling.h"

#include "FrSkySportTelemetry/FrSkySportSensor.cpp"
#include "FrSkySportTelemetry/FrSkySportSingleWireSerial.cpp"
#include "FrSkySportTelemetry/FrSkySportTelemetry.cpp"
#include "FrSkySportTelemetry/FrSkySportPolling.cpp"

#include "FrSkySportTelemetry/FrSkySportSensorGps.h"
#include "FrSkySportTelemetry/FrSkySportSensorFcs.h"

#include "FrSkySportTelemetry/FrSkySportSensorGps.cpp"
#include "FrSkySportTelemetry/FrSkySportSensorFcs.cpp"


