Config = {}

-- Amount of Time to Blackout, in milliseconds
-- 2000 = 2 seconds
Config.BlackoutTime = 3000

Config.EffectTimeLevel1 = 5
Config.EffectTimeLevel2 = 10
Config.EffectTimeLevel3 = 15
Config.EffectTimeLevel4 = 20
Config.EffectTimeLevel5 = 30

-- Enable blacking out due to vehicle damage
-- If a vehicle suffers an impact greater than the specified value, the player blacks out
Config.BlackoutDamageRequiredLevel1 = 15
Config.BlackoutDamageRequiredLevel2 = 25
Config.BlackoutDamageRequiredLevel3 = 45
Config.BlackoutDamageRequiredLevel4 = 65
Config.BlackoutDamageRequiredLevel5 = 300

-- Enable blacking out due to speed deceleration
-- If a vehicle slows down rapidly over this threshold, the player blacks out
Config.BlackoutSpeedRequiredLevel1 = 60 -- Speed in MPH
Config.BlackoutSpeedRequiredLevel2 = 80
Config.BlackoutSpeedRequiredLevel3 = 100
Config.BlackoutSpeedRequiredLevel4 = 130
Config.BlackoutSpeedRequiredLevel5 = 150

-- Enable the disabling of controls if the player is blacked out
Config.DisableControlsOnBlackout = true
Config.TimeLeftToEnableControls = 10

-- Multiplier of screen shaking strength
Config.ScreenShakeMultiplier = 0.1
