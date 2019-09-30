void SPORT_telemetry_send() {
  sensor_fcs_main.setData(SYS_acc_video_v, SYS_acc_main_v); //A, V   <---> V, V

  //setData(float lat, float lon, float alt, float speed, float cog, uint8_t year, uint8_t month, uint8_t day, uint8_t hour, uint8_t minute, uint8_t second);
  sensor_gps.setData(GPS_lat, GPS_lng,   // Latitude and longitude in degrees decimal (positive for N/E, negative for S/W)
                     GPS_alt ,                 // Altitude in m (can be negative)
                     GPS_speed,                 // Speed in m/s
                     GPS_course,                 // Course over ground in degrees (0-359, 0 = north)
                     GPS_y, GPS_m, GPS_d,             // Date (year - 2000, month, day)
                     GPS_h, GPS_i, GPS_s);           // Time (hour, minute, second) - will be affected by timezone setings in your radio

  frsky_telemetry.send();
}
