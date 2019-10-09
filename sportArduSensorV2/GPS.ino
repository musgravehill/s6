void GPS_process() {
  if (gps.readSensor()) {
    GPS_DOP = gps.getpDOP();
    GPS_sat_count = gps.getNumSatellites();

    switch (gps.getFixType()) {
      case gps.NO_FIX:
        GPS_fixType = 0;
        break;
      case gps.DEAD_RECKONING:
        GPS_fixType = 1;
        break;
      case gps.FIX_2D:
        GPS_fixType = 2;
        break;
      case gps.FIX_3D:
        GPS_fixType = 3;
        break;
      case gps.GNSS_AND_DEAD_RECKONING:
        GPS_fixType = 4;
        break;
      case gps.TIME_ONLY:
        GPS_fixType = 5;
        break;
    }

    if (gps.getFixType() == gps.FIX_3D) {
      GPS_speed = gps.getGroundSpeed_ms();
      GPS_course = gps.getMotionHeading_deg();
      GPS_y = gps.getYear() - 2000;
      GPS_m = gps.getMonth();
      GPS_d = gps.getDay();
      GPS_h = gps.getHour();
      GPS_i = gps.getMin();
      GPS_s = gps.getSec();
      GPS_lat = gps.getLatitude_deg();
      GPS_lng = gps.getLongitude_deg();
      GPS_alt = gps.getMSLHeight_m() ; //?????
    }
  }
}
