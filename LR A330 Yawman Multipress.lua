--[[
 Laminar Research A333 mapping for the Yawman Arrow By Ryan Mikulovsky, CC0 1.0. 
 
 Initial commit: 2024-12-27
 
 Inspired by Yawman's mapping for the MSFS PMDG 777.
 Thanks for Thomas Nield for suggesting looking into Lua for better controller support in XP12. Button numbers and their variable names came from Thomas.
 
 See Thomas' video and access example Lua scripts at https://www.youtube.com/watch?v=x8SMg33RRQ4
 
 Repository at https://github.com/rpmik/Lua-Yawman-Control-LR-A333
]]
-- use local to prevent other unknown Lua scripts from overwriting variables (or vice versa)

local scriptedAircraft = "A333"

local dref_lnav = "laminar/A333/autopilot/heading_knob_pull"
local dref_vnav = "laminar/A333/autopilot/altitude_knob_push"
local dref_APPR = "sim/autopilot/approach"
local dref_LOC = "sim/autopilot/NAV"

local dref_APAltHold = "laminar/A333/autopilot/altitude_knob_push"
local dref_APHdgHold = "laminar/A333/autopilot/heading_knob_push"
local dref_APVSHold = "laminar/A333/autopilot/vertical_knob_push"
local dref_APSPDHold = "laminar/A333/autopilot/speed_knob_push"
local dref_APSPD = "laminar/A333/autopilot/speed_knob_pull"

local dref_AP1Button = "sim/autopilot/servos_toggle"
local dref_AP1Disconnect = "sim/autopilot/servos_off_any"

local dref_APAlt = "sim/autopilot/FMS"
local dref_APAirSpeedUp = "sim/autopilot/airspeed_up"
local dref_APAirSpeedDown = "sim/autopilot/airspeed_down"

local dref_FlightDirector1 = "sim/autopilot/fdir_command_bars_toggle"

local dref_APAdjust = {
	AltUp = "sim/autopilot/altitude_up",
	AltDown = "sim/autopilot/altitude_down",
	HdgUp = "sim/autopilot/heading_up",
	HdgDown = "sim/autopilot/heading_down",
	VSUp = "sim/autopilot/vertical_speed_up",
	VSDown = "sim/autopilot/vertical_speed_down",
	Baro1Up = "sim/instruments/barometer_up",
	Baro1Down = "sim/instruments/barometer_down",
	Baro1Std = "sim/instruments/barometer_std",
	Baro1Push = "laminar/A333/push/baro/capt_std",
	Baro1Pull = "laminar/A333/pull/baro/capt_std",
	BaroStdCap = "laminar/A333/barometer/capt_mode", -- usually it's 1 if set to STD, 0 if anything else
	BaroStdCapTrue = 1 -- 1 means captain's baro is set to STD
}

local dref_AutoThrottle = "laminar/A333/autopilot/a_thr_toggle"

-- Planes can have different # of landing lights
-- The 330 has the light switches reversed and includes Taxi TO has part of the landing lights bank
local dref_LandingLightSwitches_Up = {
	"sim/lights/landing_01_light_off", -- Taxi T.O.
	"sim/lights/landing_02_light_off" -- Landing lights
}

-- Planes can have different # of landing lights
local dref_LandingLightSwitches_Down = {
	"sim/lights/landing_01_light_on", -- Taxi T.O.
	"sim/lights/landing_02_light_on" -- Landing Lights
}

local dref_FlightControls = {
	pitchTrimUp = "sim/flight_controls/pitch_trim_up",
	pitchTrimDown = "sim/flight_controls/pitch_trim_down",
	brakesRegular = "sim/flight_controls/brakes_regular",
	brakesMax = "sim/flight_controls/brakes_toggle_max",
	flapsUp = "sim/flight_controls/flaps_up",
	flapsDown = "sim/flight_controls/flaps_down"
}

local dref_LRStandard = {
	flashLightRed = "sim/view/flashlight_red",
	glanceLeft = "sim/view/glance_left",
	glanceRight = "sim/view/glance_right",
	defaultView = "sim/view/default_view",
	chaseView = "sim/view/chase"
}

-- To find view coordinates for below, set true to disable left seat view (dpad up plus dpad left) and print current view coordinates to log.txt
local printViewCoordinates = false

-- Copy the output values directly to the correct key
local views = {
	leftSeat = {-0.49431699514389,2.0375928878784,-26.434343338013,359.4375,-8.6666660308838},
	rightSeat = {0.53769993782043,2.0375928878784,-26.44446182251,359.4375,-8.6666660308838},
	glareshield = {0.046303998678923,1.8065810203552,-26.526182174683,0.93749821186066,-15.032203674316},
	radios = {0.046303998678923,1.8065810203552,-26.526182174683,0.18749795854092,-66.166702270508},
	FMS = {-0.021554447710514,1.59057533741,-26.888492584229,359.625,-64.659187316895},
	overhead = {0.046506874263287,1.7229561805725,-26.510683059692,359.0625,80.833274841309},
	EFBor45Left = {-0.49431699514389,2.0375928878784,-26.434343338013,307.125,-19.934391021729},
	pilotThrottles = {-0.49431699514389,2.0375928878784,-26.434343338013,31.418642044067,-45.184192657471}
}

-- Clean up the code with this
local NoCommand = "sim/none/none"

local STICK_X = 0 
local STICK_Y = 1
local POLE_RIGHT = 2 
local POLE_LEFT = 3
local RUDDER = 4
local SLIDER_LEFT = 5
local SLIDER_RIGHT = 6 
local POV_UP = 0
local POV_RIGHT = 2
local POV_DOWN = 4
local POV_LEFT = 6
local THUMBSTICK_CLK = 8
local SIXPACK_1 = 9
local SIXPACK_2 = 10
local SIXPACK_3 = 11
local SIXPACK_4 = 12
local SIXPACK_5 = 13
local SIXPACK_6 = 14
local POV_CENTER = 15
local RIGHT_BUMPER = 16
local DPAD_CENTER = 17
local LEFT_BUMPER = 18
local WHEEL_DOWN = 19
local WHEEL_UP = 20
local DPAD_UP = 21
local DPAD_LEFT = 22
local DPAD_DOWN = 23
local DPAD_RIGHT = 24

-- Logic states to keep button assignments sane
local STILL_PRESSED = false -- track presses for everything
local MULTI_SIXPACK_PRESSED = false -- track presses for only the six pack where there's multiple six pack buttons involved
local DPAD_PRESSED = false
local BUMPERS_PRESSED = false

local CHASE_VIEW = false

local FRAME_COUNT = 0.0
local GoFasterFrameRate = 0.0
local PauseIncrementFrameCount = 0.0
local FrameRate = 0.0
local CurFrame = 0.0


function multipressTolissA333_buttons() 
    -- if aircraft is an A333 then procede
    if PLANE_ICAO == scriptedAircraft then 
        FRAME_COUNT = FRAME_COUNT + 1.0  
		-- Base Config buttons that should almost always get reassigned except during a press
        if not STILL_PRESSED then -- avoid overwriting assignments during other activity
        	set_button_assignment(THUMBSTICK_CLK,dref_FlightControls.brakesRegular)
			set_button_assignment(DPAD_UP,NoCommand)
			set_button_assignment(DPAD_DOWN,NoCommand)
			set_button_assignment(DPAD_LEFT,"sim/general/zoom_out_fast")
			set_button_assignment(DPAD_RIGHT,"sim/general/zoom_in_fast")
			set_button_assignment(DPAD_CENTER,NoCommand)
			set_button_assignment(WHEEL_UP, NoCommand)
			set_button_assignment(WHEEL_DOWN, NoCommand)
			set_button_assignment(LEFT_BUMPER, NoCommand) -- multifunction
			set_button_assignment(RIGHT_BUMPER, NoCommand) -- multifunction
			set_button_assignment(SIXPACK_1,NoCommand)
			set_button_assignment(SIXPACK_2,NoCommand)
			set_button_assignment(SIXPACK_3,NoCommand)		
			set_button_assignment(SIXPACK_4,NoCommand)
			set_button_assignment(SIXPACK_5,NoCommand)
			set_button_assignment(SIXPACK_6,NoCommand)			
			set_button_assignment(POV_UP, dref_FlightControls.pitchTrimUp)
			set_button_assignment(POV_DOWN, dref_FlightControls.pitchTrimDown)
			set_button_assignment(POV_LEFT, dref_LRStandard.glanceLeft)
			set_button_assignment(POV_RIGHT, dref_LRStandard.glanceRight)
			set_button_assignment(POV_CENTER, NoCommand)
			--set_button_assignment(THUMBSTICK_CLK,"sim/flight_controls/brakes_toggle_regular")

        end 
        
        -- Get button status every frame
    
        right_bumper_pressed = button(RIGHT_BUMPER)
        left_bumper_pressed = button(LEFT_BUMPER)
        
        sp1_pressed = button(SIXPACK_1)
        sp2_pressed = button(SIXPACK_2)
        sp3_pressed = button(SIXPACK_3)
		sp4_pressed = button(SIXPACK_4)
		sp5_pressed = button(SIXPACK_5)
		sp6_pressed = button(SIXPACK_6)
		
		pov_up_pressed = button(POV_UP)
		pov_down_pressed = button(POV_DOWN)
		
		dpad_up_pressed = button(DPAD_UP)
		dpad_center_pressed = button(DPAD_CENTER)
		dpad_down_pressed = button(DPAD_DOWN)
		dpad_left_pressed = button(DPAD_LEFT)
		dpad_right_pressed = button(DPAD_RIGHT)
		
		wheel_up_pressed = button(WHEEL_UP)
		wheel_down_pressed = button(WHEEL_DOWN)
		
-- Start expanded control logic

		if dpad_center_pressed and not sp6_pressed and not DPAD_PRESSED then
			if not CHASE_VIEW then
				command_once(dref_LRStandard.chaseView)
				CHASE_VIEW = true
				DPAD_PRESSED = true
			elseif CHASE_VIEW then
				command_once(dref_LRStandard.defaultView)
				CHASE_VIEW = false
				DPAD_PRESSED = true
			end
		end
	
-- Auto pilot engage A 
		
		if right_bumper_pressed and not dpad_up_pressed and not last_button(RIGHT_BUMPER) then
			command_once(dref_AP1Button)

		end
		
-- autopilot control
	
		if sp1_pressed and last_button(SIXPACK_1) then
			set_button_assignment(RIGHT_BUMPER,dref_AutoThrottle)
			set_button_assignment(DPAD_LEFT, dref_APSPDHold)
			set_button_assignment(DPAD_RIGHT, dref_APSPD)

			if dpad_up_pressed then
				meterA333Interaction(DPAD_PRESSED,dref_APAirSpeedUp, dref_APAirSpeedUp, 1.0, 2.0) -- at around two seconds, use larger increment
				DPAD_PRESSED = true
			elseif dpad_down_pressed then
				meterA333Interaction(DPAD_PRESSED,dref_APAirSpeedDown, dref_APAirSpeedDown,1.0,2.0)
				DPAD_PRESSED = true
			end
			

		-- Pause Simulation
			if sp2_pressed and sp3_pressed and not MULTI_SIXPACK_PRESSED then
				command_once("sim/operation/pause_toggle")
				MULTI_SIXPACK_PRESSED = true
			end
			
			--STILL_PRESSED = true
		end
		
		if sp2_pressed and last_button(SIXPACK_2) then
			set_button_assignment(RIGHT_BUMPER,dref_FlightDirector1) -- works
			set_button_assignment(DPAD_RIGHT, dref_lnav) -- works
			set_button_assignment(DPAD_LEFT,dref_LOC) -- works
			set_button_assignment(DPAD_DOWN, dref_APPR) -- works
			set_button_assignment(DPAD_UP, dref_vnav) -- works

					
			-- Flash Light
			if sp5_pressed and not MULTI_SIXPACK_PRESSED then
				command_once(dref_LRStandard.flashLightRed)
				MULTI_SIXPACK_PRESSED = true
			end
			
		end

		if sp3_pressed and last_button(SIXPACK_3) then


			set_button_assignment(RIGHT_BUMPER, dref_APAlt)
			set_button_assignment(SIXPACK_6,"sim/lights/landing_lights_toggle")
			set_button_assignment(DPAD_LEFT, dref_APAltHold)
			set_button_assignment(DPAD_RIGHT, dref_vnav)

			
			if dpad_up_pressed then
				meterA333Interaction(DPAD_PRESSED, dref_APAdjust.AltUp, dref_APAdjust.AltUp, 1.0, 2.0) -- at around two seconds, use larger increment
				DPAD_PRESSED = true
			elseif dpad_down_pressed then
				meterA333Interaction(DPAD_PRESSED, dref_APAdjust.AltDown, dref_APAdjust.AltDown, 1.0, 2.0)
				DPAD_PRESSED = true
			end
			
			if sp6_pressed and not MULTI_SIXPACK_PRESSED then
				-- LR Standard data ref for landing light switches. In the case of the A330, index 1 at 0.5 means taxi lights are on.
				LandingLightSwitchStatus = dataref_table("sim/cockpit2/switches/landing_lights_switch")
				--DataRef("LandingLightStatus_Left","sim/cockpit2/switches/landing_lights_on","readonly")
				--DataRef("LandingLightStatus_Right","sim/cockpit/electrical/landing_lights_on","readonly")
				LandingLightStatus_Left = LandingLightSwitchStatus[0]
				LandingLightStatus_Right = LandingLightSwitchStatus[1]
				-- LR A333 specific if statement....
				if LandingLightStatus_Left == 1 and LandingLightStatus_Right == 1 then
					for i,lights in ipairs(dref_LandingLightSwitches_Down) do
						command_once(lights)

					end	

					MULTI_SIXPACK_PRESSED = true
				elseif LandingLightStatus_Left == 0 and LandingLightStatus_Right == 0 then
					for i,lights in ipairs(dref_LandingLightSwitches_Up) do
						command_once(lights)
						
					end	

					MULTI_SIXPACK_PRESSED = true
				end
								

				
				MULTI_SIXPACK_PRESSED = true
				

				
			end
			

			
		end
		
		if sp5_pressed and last_button(SIXPACK_5) then
			set_button_assignment(RIGHT_BUMPER,dref_APHdgHold)
			set_button_assignment(DPAD_LEFT, dref_APHdgHold)
			set_button_assignment(DPAD_RIGHT, dref_lnav)
			
			if dpad_up_pressed then
				meterA333Interaction(DPAD_PRESSED,dref_APAdjust.HdgUp, dref_APAdjust.HdgUp, 1.0, 3.0) -- at around two seconds, use larger increment
				DPAD_PRESSED = true
			elseif dpad_down_pressed then
				meterA333Interaction(DPAD_PRESSED, dref_APAdjust.HdgDown, dref_APAdjust.HdgDown, 1.0, 3.0)
				DPAD_PRESSED = true
			end

		end
		
		if sp6_pressed and last_button(SIXPACK_6) then
			set_button_assignment(DPAD_LEFT, dref_APAdjust.Baro1Down)
			set_button_assignment(DPAD_RIGHT, dref_APAdjust.Baro1Up)
			set_button_assignment(RIGHT_BUMPER, dref_APVSHold)
			--set_button_assignment(DPAD_CENTER, "AirbusFBW/BaroStdCapt")
			--set_button_assignment(DPAD_CENTER,"sim/autopilot/vertical_speed")

			DataRef("dref_BaroStdCap", dref_APAdjust.BaroStdCap,"readonly")
			if dpad_up_pressed then
				meterA333Interaction(DPAD_PRESSED, dref_APAdjust.VSUp, dref_APAdjust.VSUp, 1.0, 3.0) -- at around two seconds, use larger increment
				DPAD_PRESSED = true
			elseif dpad_down_pressed then
				meterA333Interaction(DPAD_PRESSED, dref_APAdjust.VSDown, dref_APAdjust.VSDown, 1.0, 3.0)
				DPAD_PRESSED = true
			elseif dpad_center_pressed then
				if dref_BaroStdCap == dref_APAdjust.BaroStdCapTrue then
					meterA333Interaction(DPAD_PRESSED, dref_APAdjust.Baro1Push, dref_APAdjust.Baro1Push, 1.0, 3.0)
				else
					meterA333Interaction(DPAD_PRESSED, dref_APAdjust.Baro1Pull, dref_APAdjust.Baro1Pull, 1.0, 3.0)
				end
				DPAD_PRESSED = true
			end
			
		end

-- parking brake			
		if left_bumper_pressed and last_button(LEFT_BUMPER) then
			set_button_assignment(SIXPACK_2,NoCommand)
			set_button_assignment(SIXPACK_1,NoCommand)

			if wheel_up_pressed or wheel_down_pressed then
				meterA333Interaction(BUMPERS_PRESSED, dref_FlightControls.brakesMax, dref_brakesMax, 2.0, 20) -- at around two seconds, use larger increment
				BUMPERS_PRESSED = true
			end
			
--[[
			if not STILL_PRESSED then
				set_button_assignment(WHEEL_UP,"sim/flight_controls/brakes_toggle_max")
				set_button_assignment(WHEEL_DOWN,"sim/flight_controls/brakes_toggle_max")
			end
]]
				-- Cockpit camera height not implemented as it deals with the rudder axes.....
			if sp4_pressed and not MULTI_SIXPACK_PRESSED then
				if dpad_up_pressed then
					-- EFB but this doesn't quite work. A333.
					--set_pilots_head(-0.60079902410507,1.5304770469666,-11.694169998169,306.1875,-17.333335876465)
				else
					-- Glareshield A333 +++
					set_pilots_head(views.glareshield[1],views.glareshield[2],views.glareshield[3],views.glareshield[4],views.glareshield[5])
				end
				MULTI_SIXPACK_PRESSED = true
			elseif sp2_pressed and not MULTI_SIXPACK_PRESSED then
				-- Nav, CDU, Transponder, etc A333 +++
				set_pilots_head(views.radios[1],views.radios[2],views.radios[3],views.radios[4],views.radios[5])
				MULTI_SIXPACK_PRESSED = true
			elseif sp5_pressed and not MULTI_SIXPACK_PRESSED then
				-- FMS A333 ++
				set_pilots_head(views.FMS[1],views.FMS[2],views.FMS[3],views.FMS[4],views.FMS[5])
				MULTI_SIXPACK_PRESSED = true
			elseif sp1_pressed and not MULTI_SIXPACK_PRESSED then
				-- Overhead panel A333 +++
				set_pilots_head(views.overhead[1],views.overhead[2],views.overhead[3],views.overhead[4],views.overhead[5])
				MULTI_SIXPACK_PRESSED = true
			elseif sp3_pressed and not MULTI_SIXPACK_PRESSED then
				-- A333 future tablet/EFB area, maybe ++
				set_pilots_head(views.EFBor45Left[1],views.EFBor45Left[2],views.EFBor45Left[3],views.EFBor45Left[4],views.EFBor45Left[5])
				MULTI_SIXPACK_PRESSED = true
			elseif sp6_pressed and not MULTI_SIXPACK_PRESSED then
				-- A333 pilot's view of throttles etc ++
				set_pilots_head(views.pilotThrottles[1],views.pilotThrottles[2],views.pilotThrottles[3],views.pilotThrottles[4],views.pilotThrottles[5])
				MULTI_SIXPACK_PRESSED = true
			end
			
			--STILL_PRESSED = true
		end
				

-- DPAD_up mode
		if dpad_up_pressed and last_button(DPAD_UP) then

			set_button_assignment(RIGHT_BUMPER, dref_AutoThrottle) -- there's only a toggle (Will investigate later)
			--set_button_assignment(WHEEL_UP,"sim/flight_controls/flaps_down")
			--set_button_assignment(WHEEL_DOWN,"sim/flight_controls/flaps_up")
			set_button_assignment(POV_LEFT,"sim/view/glance_left")
			set_button_assignment(POV_RIGHT,"sim/view/glance_right")
			set_button_assignment(POV_UP,"sim/view/straight_up")
			set_button_assignment(POV_DOWN,"sim/view/straight_down")
	
			set_button_assignment(DPAD_LEFT,NoCommand)
			set_button_assignment(DPAD_RIGHT,NoCommand)

			if wheel_up_pressed then
				meterA333Interaction(DPAD_PRESSED, dref_FlightControls.flapsDown, dref_FlightControls.flapsDown, 1.0, 10) -- at around two seconds, use larger increment
				DPAD_PRESSED = true
			elseif wheel_down_pressed then
				meterA333Interaction(DPAD_PRESSED, dref_FlightControls.flapsUp, dref_FlightControls.flapsUp, 1.0, 10) -- at around two seconds, use larger increment
				DPAD_PRESSED = true
			end
			
			if dpad_left_pressed then
				-- Pilot's seat A333
				if printViewCoordinates then
					headX, headY, headZ, heading, pitch = get_pilots_head()
					print(headX .. "," .. headY .. "," .. headZ .. "," .. heading .. "," .. pitch)
				else
					set_pilots_head(views.leftSeat[1],views.leftSeat[2],views.leftSeat[3],views.leftSeat[4],views.leftSeat[5])
				end
				

			elseif dpad_right_pressed then
				-- Copilot's seat A333
				set_pilots_head(views.rightSeat[1],views.rightSeat[2],views.rightSeat[3],views.rightSeat[4],views.rightSeat[5])

			end


		end
		
-- DPAD_down mode
		if dpad_down_pressed and last_button(DPAD_DOWN) then

			set_button_assignment(RIGHT_BUMPER, dref_AP1Disconnect)

		end

-- All buttons need to be released to end STILL_PRESSED phase
		if not sp1_pressed and not sp2_pressed and not sp3_pressed and not sp4_pressed and not sp5_pressed and not sp6_pressed and not right_bumper_pressed and not left_bumper_pressed and not dpad_center_pressed and not dpad_down_pressed and not dpad_left_pressed and not dpad_right_pressed then
			STILL_PRESSED = false
		end

		if not sp1_pressed and not sp2_pressed and not sp3_pressed and not sp4_pressed and not sp5_pressed and not sp6_pressed then
			MULTI_SIXPACK_PRESSED = false
		end 
		
		if not dpad_up_pressed and not dpad_left_pressed and not dpad_right_pressed and not dpad_down_pressed and not dpad_center_pressed then
			DPAD_PRESSED = false
		end
		
		if not left_bumper_pressed and not right_bumper_pressed then
			BUMPERS_PRESSED = false
		end
		
    end 
end

-- If aircraft's interactive Command increment is not continuous or continuous and too fast, use framerate to meter incrementing
function meterA333Interaction(boolButtonPressed, strCommandName1, strCommandName2, floatSeconds, floatIntervalSpeed)
		-- floatIntervalSpeed -- generally, higher is slower. 
		
		-- Set metering based on current frame rate
		DataRef("FrameRatePeriod","sim/operation/misc/frame_rate_period","writable")
		CurFrame = FRAME_COUNT
		
		if not boolButtonPressed then
			FrameRate = 1/FrameRatePeriod
			-- Roughly calculate how many frames to wait before incrementing based on floatSeconds
			GoFasterFrameRate = (floatSeconds * FrameRate) + CurFrame -- start five seconds of slow increments
		end

		if CurFrame < GoFasterFrameRate then
			if not boolButtonPressed then
				command_once(strCommandName1)
				-- calculate frame to wait until continuing
				-- if floatSeconds is 2 then we'll wait around 1 second before continuing so as to allow a single standalone increment
				PauseIncrementFrameCount = ((floatSeconds/2) * FrameRate) + CurFrame
			else
				-- wait a beat with PauseIncrementFrameCount then continue
				if (CurFrame > PauseIncrementFrameCount) and (CurFrame % floatIntervalSpeed) == 0 then
					command_once(strCommandName1)
				end
			end
		elseif CurFrame >= GoFasterFrameRate and boolButtonPressed then
			-- If current frame is divisible by five then issue a command -- helps to delay the command in a regular interval
			if (CurFrame % floatIntervalSpeed) == 0 then
				command_once(strCommandName2)
			end
		end			
end


-- Don't mess with other configurations
if PLANE_ICAO == scriptedAircraft then 
	clear_all_button_assignments()
	
--	set_axis_assignment(POLE_LEFT, "reverse", "reverse")
--	set_axis_assignment(POLE_RIGHT, "speedbrakes", "normal") -- Toliss expects Normal
--set_axis_assignment(STICK_X, "roll", "normal" )
--set_axis_assignment(STICK_Y, "pitch", "normal" )

--set_axis_assignment(RUDDER, "yaw", "normal" )

	do_every_frame("multipressTolissA333_buttons()")
end
