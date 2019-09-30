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

local lipo_v_max = 12.60 --volt
local lipo_v_min = 11.00 --volt
local lipo_v_gauge_w = 40 --px

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

--function is called once when script is loaded and begins execution
local function init_func()
  data_ids_GPS = getFieldInfo("GPS").id 
  data_ids_GAlt = getFieldInfo("GAlt").id     
  data_ids_VFAS = getFieldInfo("VFAS").id     
end

--is called periodically, the screen visibility does not matter
local function background_func()
  gpsLatLon = getValue(data_ids_GPS)
  if ("table"==type(gpsLatLon)) then
    gps_lat_last = gpsLatLon["lat"]
	gps_lon_last = gpsLatLon["lon"]    
    gps_home_init() 
	gps_home_process()
  end
  
  gps_GAlt_last = getValue(data_ids_GAlt)     
  
end 



--function is called periodically when custom telemetry screen is visible
local function run_func(e)
  lcd.clear()
  --background_func() вероятно, не нужно дергать, потому что background_func выполняется само периодически
  
  SA = getValue('sa')
  
  if(SA==-1024) then
    lcd.drawText(1,1,"MODE STAB", 0)
  end
  if(SA==0) then
    lcd.drawText(1,1,"MODE NOSTAB", 0)
  end
  if(SA==1024) then
    lcd.drawText(1,1,"MODE GYRO", 0)
  end
  
  
  
  if(1==gps_home_is_init) then
	lcd.drawText(1,12,"WAIT...GPS HOME INIT",0)
  else
    gpsValue = helper_math_round(gps_lat_last,6) .. ", " .. helper_math_round(gps_lon_last,6)    
    lcd.drawText(1,12,"GPS "..gpsValue, 0)
	lcd.drawText(1,24,"ALT "..(gps_GAlt_last-gps_GAlt_home).."m",0) 
	lcd.drawText(1,36,"DIST "..helper_getMetersBetweenCoordinates(gps_lat_home,gps_lon_home,gps_lat_last,gps_lon_last).."m",0)
  end
  
  lipo_v = getValue(data_ids_VFAS)  
  lipo_v_gauge_fill_max = 100*  (lipo_v_max-lipo_v_min) 
  lipo_v_gauge_fill = lipo_v_gauge_fill_max - 100*(lipo_v_max-lipo_v) 
  if(lipo_v_gauge_fill<0) then lipo_v_gauge_fill=0 end
  if(lipo_v_gauge_fill>lipo_v_gauge_fill_max) then lipo_v_gauge_fill=lipo_v_gauge_fill_max end 
       
  lcd.drawText(46,50, helper_math_round(lipo_v,2).."V", 0) 
  lcd.drawGauge(1, 48, lipo_v_gauge_w, 12, lipo_v_gauge_fill, lipo_v_gauge_fill_max)  -- x y w h fill max_fill    
   
end

return{init=init_func,run=run_func,background=background_func}