--mysdcard\SCRIPTS\TELEMETRYds 

--is called periodically, the screen visibility does not matter
local function background_func()	   
	  
end 



--function is called periodically when custom telemetry screen is visible
--background_func() вероятно, не нужно дергать, потому что background_func выполняется само периодически
local function run_func(e)
	lcd.clear()      
  
	SD = getValue('sd')  
	if(SD <= -900) then
		lcd.drawText(1,40,"STAB", 0) 
	end
	if((SD > -50) and (SD < 50)) then 
		lcd.drawText(1,40,"NOSTAB", 0)
	end
	if(SD >= 900) then
		lcd.drawText(1,40,"GYRO", 0) 
	end     
end

return{init=init_func,run=run_func,background=background_func}