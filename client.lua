-- Global variables to track the state of various effects and the player's condition
local effectActive = false            -- Indicates if the blur screen effect is currently active
local blackOutActive = false          -- Indicates if the blackout effect is currently active
local currAccidentLevel = 0           -- Stores the current level of accident effect that is active
local wasInCar = false                -- Flag to track if the player was previously in a car
local oldBodyDamage = 0.0             -- Stores the previous body damage value of the vehicle
local oldSpeed = 0.0                  -- Stores the previous speed of the vehicle
local currentDamage = 0.0             -- Stores the current body damage value of the vehicle
local currentSpeed = 0.0              -- Stores the current speed of the vehicle
local vehicle                         -- Variable to hold the current vehicle entity
local disableControls = false         -- Flag to disable player controls during certain effects

-- Function to check if an entity is a car based on its vehicle class
IsCar = function(veh)
        local vc = GetVehicleClass(veh)
        -- Vehicle classes between 0 and 7, 9 to 12, and 17 to 20 are considered cars
        return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end 

-- Helper function to display notifications in-game
function note(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

-- Registers a network event for triggering the crash effect
RegisterNetEvent("crashEffect")
-- Event handler for the crash effect, takes countdown duration and accident level as parameters
AddEventHandler("crashEffect", function(countDown, accidentLevel)
    -- Only activates if the effect is not already active or if the new accident level is higher than the current
    if not effectActive or (accidentLevel > currAccidentLevel) then
        currAccidentLevel = accidentLevel
        disableControls = true
        effectActive = true
        blackOutActive = true
        DoScreenFadeOut(100) -- Initiates a screen fade out effect
        Wait(Config.BlackoutTime) -- Pauses the script for a duration based on the blackout time configuration
        DoScreenFadeIn(250) -- Initiates a screen fade in effect
        blackOutActive = false

        -- Starts various screen effects to simulate the aftermath of a crash
        StartScreenEffect('PeyoteEndOut', 0, true)
        StartScreenEffect('Dont_tazeme_bro', 0, true)
        StartScreenEffect('MP_race_crash', 0, true)
    
        -- Countdown loop to manage the duration of the effects
        while countDown > 0 do
            -- Conditionally shakes the gameplay camera for added effect based on the remaining countdown and accident level
            if countDown > (3.5*accidentLevel) then 
                ShakeGameplayCam("MEDIUM_EXPLOSION_SHAKE", (accidentLevel * Config.ScreenShakeMultiplier))
            end 
            Wait(750) -- Pauses the script for 750 milliseconds
            
            countDown = countDown - 1 -- Decrements the countdown timer

            -- Re-enables controls if the countdown is less than a configured threshold
            if countDown < Config.TimeLeftToEnableControls and disableControls then
                disableControls = false
            end

            -- Stops all screen effects if the countdown is about to finish
            if countDown <= 1 then
                StopScreenEffect('PeyoteEndOut')
                StopScreenEffect('Dont_tazeme_bro')
                StopScreenEffect('MP_race_crash')
            end
        end
        -- Resets variables after the effect is concluded
        currAccidentLevel = 0
        effectActive = false
    end
end)

-- Main loop that continuously checks for vehicle damage and speed changes to trigger effects
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10) -- Small delay to prevent script from hogging resources
        
        -- Fetches the current vehicle and updates the player's state based on vehicle status and damage
        vehicle = GetVehiclePedIsIn(PlayerPedId(-1), false)
        -- Checks if the player's current vehicle exists and if the player was in a car or is currently in a car
        if DoesEntityExist(vehicle) and (wasInCar or IsCar(vehicle)) then
            wasInCar = true
            -- Update old and current damage/speed values
            oldSpeed = currentSpeed
            oldBodyDamage = currentDamage
            currentDamage = GetVehicleBodyHealth(vehicle)
            currentSpeed = GetEntitySpeed(vehicle) * 2.23 -- Converts speed to MPH

            -- Triggers the crash effect based on damage thresholds
            if currentDamage ~= oldBodyDamage then
                print("crash") -- Debug print
                if not effect and currentDamage < oldBodyDamage then
                    print("effect") -- Debug print
                    print(oldBodyDamage - currentDamage) -- Debug print
                    
                    -- Checks against various damage thresholds to determine the level of the crash effect, worst crash to least worse
                    
                    if (oldBodyDamage - currentDamage) >= Config.BlackoutDamageRequiredLevel5 or
                    (oldSpeed - currentSpeed)  >= Config.BlackoutSpeedRequiredLevel5 then
                        oldBodyDamage = currentDamage
                        TriggerEvent("crashEffect", Config.EffectTimeLevel5, 5)
                        TriggerServerEvent('triggerPanicAndLogCall', pos.x, pos.y, pos.z)
                        note(effect) -- Debug print
                        note(oldBodyDamage - currentDamage) -- Debug print
                        
                        -- Additional thresholds for other levels of crash effects
                    elseif (oldBodyDamage - currentDamage) >= Config.BlackoutDamageRequiredLevel4 or
                    (oldSpeed - currentSpeed)  >= Config.BlackoutSpeedRequiredLevel4 then
                        TriggerEvent("crashEffect", Config.EffectTimeLevel4, 4)
                        TriggerServerEvent('triggerPanicAndLogCall', pos.x, pos.y, pos.z)
                        oldBodyDamage = currentDamage
                        note(effect) -- Debug print
                        note(oldBodyDamage - currentDamage) -- Debug print
                        
                        -- And so on for other levels...
                    elseif (oldBodyDamage - currentDamage) >= Config.BlackoutDamageRequiredLevel3 or
                    (oldSpeed - currentSpeed)  >= Config.BlackoutSpeedRequiredLevel3 then   
                        oldBodyDamage = currentDamage
                        TriggerEvent("crashEffect", Config.EffectTimeLevel3, 3)
                        note(effect) -- Debug print
                        note(oldBodyDamage - currentDamage) -- Debug print
                        
                    elseif (oldBodyDamage - currentDamage) >= Config.BlackoutDamageRequiredLevel2 or
                    (oldSpeed - currentSpeed)  >= Config.BlackoutSpeedRequiredLevel2 then
                        oldBodyDamage = currentDamage
                        TriggerEvent("crashEffect", Config.EffectTimeLevel2, 2)
                        note(effect) -- Debug print
                        note(oldBodyDamage - currentDamage) -- Debug print

                    elseif (oldBodyDamage - currentDamage) >= Config.BlackoutDamageRequiredLevel1 or
                    (oldSpeed - currentSpeed)  >= Config.BlackoutSpeedRequiredLevel1 then
                        oldBodyDamage = currentDamage
                        TriggerEvent("crashEffect", Config.EffectTimeLevel1, 1)
                        note(effect) -- Debug print
                        note(oldBodyDamage - currentDamage) -- Debug print

                    end
                end
            end
        elseif wasInCar then
            -- Resets variables if the player exits the vehicle
            wasInCar = false
            currentDamage = 0
            oldBodyDamage = 0
            currentSpeed = 0
            oldSpeed = 0
        end
        
        -- Disables certain vehicle controls if controls are to be disabled during blackout
        if disableControls and Config.DisableControlsOnBlackout then
            DisableControlAction(0,71,true) -- veh forward
            DisableControlAction(0,72,true) -- veh backwards
            DisableControlAction(0,63,true) -- veh turn left
            DisableControlAction(0,64,true) -- veh turn right
            DisableControlAction(0,75,true) -- disable exit vehicle
        end
    end
end)
