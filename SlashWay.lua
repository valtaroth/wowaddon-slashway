local ADDON_NAME = ...

local function printInfo(msg)
    print(ADDON_NAME .. ': ' .. msg)
end

local function printError(err)
    print('|cffff0000' .. ADDON_NAME .. ': ' .. err .. '|r')
end

local function SlashWay(msg, editbox)
    -- msg will be split into [mapID, x, y, anything else (for TomTom commands usually a name)]
    local argMapID, argX, argY, argName = strsplit(" ", msg, 4)
    
    local mapID = tonumber(strtrim(argMapID, "#"))
    if mapID == nil then
        printError('Failed to place waypoint for invalid map id "' .. argMapID .. '"!')
        return
    end

    local map = C_Map.GetMapInfo(mapID)
    if map == nil or map == '' then
        printError('Failed to place waypoint for unknown map id "' .. argMapID .. '"!')
        return
    elseif not C_Map.CanSetUserWaypointOnMap(mapID) then
        printError('Not allowed to place waypoint on map ' .. map.name)
        return
    end

    local x = tonumber(argX)
    if x == nil then
        printError('Failed to place waypoint with invalid X coordinate "' .. argX .. '"!')
        return
    end

    local y = tonumber(argY)
    if y == nil then
        printError('Failed to place waypoint with invalid Y coordinate "' .. argY .. '"!')
        return
    end

    local point = UiMapPoint.CreateFromCoordinates(mapID, x / 100, y / 100)
    C_Map.SetUserWaypoint(point)
    C_SuperTrack.SetSuperTrackedUserWaypoint(true)

    if argName == nil or argName == '' then
        printInfo('Placed waypoint on map #' .. mapID .. ' (' .. map.name .. ') at coordinates (' .. x .. '/' .. y .. ').')
    else
        printInfo('Placed waypoint ' .. argName .. ' on map #' .. mapID .. ' (' .. map.name .. ') at coordinates (' .. x .. '/' .. y .. ').')
    end
end

SLASH_SLASHWAY1 = '/way'
SlashCmdList["SLASHWAY"] = SlashWay