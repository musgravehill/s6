void GPS_process() {
  while (Serial.available()) {
    GPS_parser.encode(Serial.read());
  }
  if (GPS_parser.satellites.isValid()) {
    GPS_sat_count = GPS_parser.satellites.value();
  }
  if (GPS_sat_count >= GPS_SAT_MIN_COUNT) {
    if (GPS_parser.location.isValid())  {
      GPS_lat = GPS_parser.location.lat();
      GPS_lng = GPS_parser.location.lng();
    }
    if (GPS_parser.altitude.isValid()) {
      GPS_alt = GPS_parser.altitude.meters();
    }
    if (GPS_parser.speed.isValid()) {
      GPS_speed = GPS_parser.speed.kmph() * 1000 / 3600; // m\s
    }
    if (GPS_parser.course.isValid()) {
      GPS_course = GPS_parser.course.deg();
    }
    if (GPS_parser.date.isValid()) {
      GPS_y = GPS_parser.date.year() - 2000;
      GPS_m = GPS_parser.date.month();
      GPS_d = GPS_parser.date.day();
    }
    if (GPS_parser.time.isValid()) {
      GPS_h = GPS_parser.time.hour();
      GPS_i = GPS_parser.time.minute();
      GPS_s = GPS_parser.time.second();
    }
  }

  //printInt(gps.satellites.value(), gps.satellites.isValid(), 5);
  //printInt(gps.hdop.value(), gps.hdop.isValid(), 5);
  //printFloat(gps.location.lat(), gps.location.isValid(), 11, 6);
  //printFloat(gps.location.lng(), gps.location.isValid(), 12, 6);
  //printInt(gps.location.age(), gps.location.isValid(), 5);
  //printDateTime(gps.date, gps.time);
  //printFloat(gps.altitude.meters(), gps.altitude.isValid(), 7, 2);
  //printFloat(gps.course.deg(), gps.course.isValid(), 7, 2);
  //printFloat(gps.speed.kmph(), gps.speed.isValid(), 6, 2);
  //printStr(gps.course.isValid() ? GPS_parserlus::cardinal(gps.course.value()) : "*** ", 6);


}
