RegisterNetEvent('triggerPanicAndLogCall')
AddEventHandler('triggerPanicAndLogCall', function(x, y, z)
    -- Panic button logic logic goes here later....
    print("Panic button triggered due to a vehicle crash at coordinates:", x, y, z)

    -- Fetch street names for a more detailed location in the 911 call
    local s1, s2 = GetStreetNameAtCoord(x, y, z)
    local streetName1 = GetStreetNameFromHashKey(s1)
    local streetName2 = GetStreetNameFromHashKey(s2)
    local locationDescription = streetName1
    if streetName2 ~= "" then
        locationDescription = locationDescription .. " and " .. streetName2
    end

    -- Log a 911 call (assuming the function to do so is correctly set up)
    TriggerEvent('SonoranCAD::callcommands:SendCallApi', 'new911Call', {
        ['location'] = locationDescription,
        ['caller'] = 'Automated Crash Detection System',
        ['description'] = 'A severe vehicle crash detected.',
        ['isEmergency'] = true,
        ['serverId'] = source, -- Assuming 'source' is the player ID triggering the event -- Will need to test
        ['postal'] = 'Unknown' -- If available, replace 'Unknown' with actual data
    })

    -- Custom blip creation (according to Sonoran CAD documentation)
    -- TODO: Will need to add a trigger to remove the blip on some sort of outcome.
    TriggerClientEvent('createCustomBlip', -1, x, y, z)
end)