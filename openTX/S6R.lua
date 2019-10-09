--mysdcard\SCRIPTS\TELEMETRY
 

local gps_lat_home = 0
local gps_lon_home = 0
local gps_lat_last = 0
local gps_lon_last = 0
local gps_GAlt_home = 0
local gps_GAlt_last = 0
local gps_home_time_start = 0  
local gps_home_time_delay = 5 --seconds   TODO 30..60 sec
local gps_home_is_init = 1

local data_ids_GPS = 0 
local data_ids_GAlt = 0
local data_ids_VFAS = 0 
local data_ids_RPM = 0     
local data_ids_GSpd = 0  
local data_ids_Tmp1 = 0
local data_ids_Tmp2 = 0
local data_ids_Curr = 0

local GPS_sat_count = 0 --data_ids_RPM 
local GPS_DOP = 0 -- data_ids_Tmp1
local GPS_fixType = 0 --data_ids_Tmp2
local GSpd = 0 -- GSpd
local VTX_volt = 0 --data_ids_Curr 
local LIPO_volt = 0 --main accum

--покажи сообщение "ждите * сек, чтобы GPS HOME сформировался" и обратный таймер, если gps_lat_home || gps_lon_home нулевые
 

local function helper_getMetersBetweenCoordinates(Lat1, Lon1, Lat2, Lon2)
  -- Returns distance in meters between two GPS positions
  -- Latitude and Longitude in decimal degrees
  -- 40.1234, -75.4523342
  if Lat1 == nil then -- No GPS lock
    return 0
  end
  local R = 6371 * 10^3 -- radius of the earth in metres (meter)
  local Phi1 = math.rad(Lat1)
  local Phi2 = math.rad(Lat2)
  local dPhi = math.rad(Lat2-Lat1)
  local dLambda = math.rad(Lon2-Lon1)
  local a = math.sin(dPhi/2)^2 + math.cos(Phi1) * math.cos(Phi2) * math.sin(dLambda/2)^2
  local c = 2 * math.atan2(math.sqrt(a), math.sqrt(1-a))

  -- distance = R * c
  return math.floor(math.abs(R * c)) 
end

local function helper_math_round(v,d)
    if d then
     return math.floor((v*10^d)+0.5)/(10^d)
    else
     return math.floor(v+0.5)
    end
end 

local function gps_home_init()
	  if(0==gps_home_time_start) then 
		gps_home_time_start = getTime()  
	  end	 
end

local function gps_home_process()
	 delta = (getTime() - gps_home_time_start) / 100  --in seconds (time in X*10ms)
	 if(delta < gps_home_time_delay) then 
		gps_lat_home = gps_lat_last
		gps_lon_home = gps_lon_last 
		gps_GAlt_home = gps_GAlt_last
	 else	
		gps_home_is_init = 0 
	 end 
end

local function get_gps_fix_name(fixTypeInt)
	local nm = "?";
	--NO_FIX 1
	--DEAD_RECKONING 2
	--FIX_2D 3
	--FIX_3D 4
	--GNSS_AND_DEAD_RECKONING 5
	--TIME_ONLY 6 
	if(1==fixTypeInt)then
		nm= "NO_FIX";
    elseif(2==fixTypeInt) then
		nm= "DEADRECKONING";
	elseif(3==fixTypeInt) then
		nm= "FIX_2D";
	elseif(4==fixTypeInt) then
		nm= "FIX_3D";
	elseif(5==fixTypeInt) then
		nm= "GNSSDEADRECKONING";	
	elseif(6==fixTypeInt) then
		nm= "TIME_ONLY";		
	end
	return nm;
end

--function is called once when script is loaded and begins execution
local function init_func()
	data_ids_GPS = getFieldInfo("GPS").id 
	data_ids_GAlt = getFieldInfo("GAlt").id     
	data_ids_VFAS = getFieldInfo("VFAS").id 
	data_ids_RPM = getFieldInfo("RPM").id      
	data_ids_GSpd = getFieldInfo("GSpd").id  
	data_ids_Tmp1 = getFieldInfo("Tmp1").id  
	data_ids_Tmp2 = getFieldInfo("Tmp2").id  
	data_ids_Curr = getFieldInfo("Curr").id                     
end

--is called periodically, the screen visibility does not matter
local function background_func()	   
	 GPS_sat_count = getValue(data_ids_RPM) 
	 GPS_DOP = getValue(data_ids_Tmp1)
	 GPS_fixType = getValue(data_ids_Tmp2)
	 GSpd = getValue(data_ids_GSpd)
	 VTX_volt = getValue(data_ids_Curr) 
	 LIPO_volt = getValue(data_ids_VFAS)	 
	 
	 if((GPS_sat_count > 4) and (GPS_fixType==4))then 
			  gpsLatLon = getValue(data_ids_GPS)
			  if ("table"==type(gpsLatLon)) then
					gps_lat_last = gpsLatLon["lat"]
					gps_lon_last = gpsLatLon["lon"]    
					gps_home_init() 
					gps_home_process()
			  end  
			  gps_GAlt_last = getValue(data_ids_GAlt)   
	 end    
end 



--function is called periodically when custom telemetry screen is visible
local function run_func(e)
  lcd.clear()
  --background_func() вероятно, не нужно дергать, потому что background_func выполняется само периодически
  
  SD = getValue('sd')  
  if(SD <= -900) then
    lcd.drawText(1,1,"STAB", 0)
  end
  if((SD > -50) and (SD < 50)) then 
    lcd.drawText(1,1,"NOSTAB", 0)
  end
  if(SD >= 900) then
    lcd.drawText(1,1,"GYRO", 0) 
  end   
  
  if(1==gps_home_is_init) then
	lcd.drawText(1,10,"WAIT...GPS HOME INIT",0)
  else  	
	lcd.drawText(1,10,"DIST_"..helper_getMetersBetweenCoordinates(gps_lat_home,gps_lon_home,gps_lat_last,gps_lon_last).." m",0)
    lcd.drawText(1,20,"ALT_"..(gps_GAlt_last-gps_GAlt_home).." m",0) 	
	lcd.drawText(1,30,"SPD_"..helper_math_round(GSpd,0).." m/s", 0)
	gpsValue = helper_math_round(gps_lat_last,6) .. ", " .. helper_math_round(gps_lon_last,6)     
	lcd.drawText(1,40,"GPS_"..gpsValue, 0)   	
	lcd.drawText(1,50,"ACC_"..helper_math_round(LIPO_volt,2), 0)   
	lcd.drawText(64,50,"VTX_"..helper_math_round(VTX_volt,2), 0)       
  end  	
    lcd.drawText(1,58,"SAT_"..GPS_sat_count, SMLSIZE)	
	lcd.drawText(33,58,"DOP_"..GPS_DOP, SMLSIZE)
    lcd.drawText(62,58,get_gps_fix_name(GPS_fixType), SMLSIZE)	 
   
end

return{init=init_func,run=run_func,background=background_func}