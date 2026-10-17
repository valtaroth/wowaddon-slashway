local ADDON_NAME = ...

local function printInfo(msg)
    print(ADDON_NAME .. ': ' .. msg)
end

local function printError(err)
    print('|cffff0000' .. ADDON_NAME .. ': ' .. err .. '|r')
end

local function printUsage()
    printInfo('Command must be one of:')
    printInfo('/way x y')
    printInfo('/way #mapid x y')
    printInfo('/way here x y')
    printInfo('Each command may be followed by an optional description which will be ignored.')
end

local wrongseparator = "(%d)" .. (tonumber("1.1") and "," or ".") .. "(%d)"
local rightseparator =   "%1" .. (tonumber("1.1") and "." or ",") .. "%2"

local function SlashWay(msg, editbox)
    -- fix coordinate formats to allow both periods and commas
    msg = msg:gsub("(%d)[%.,] (%d)", "%1 %2"):gsub(wrongseparator, rightseparator)

    -- tokenize arguments
    local tokens = {}
    for token in msg:gmatch("%S+") do table.insert(tokens, token) end

    local argMapID, mapEnd, mapID

    if tokens[1] then
        -- arguments with zone: zone x y description
        if not tonumber(tokens[1]) then
            -- find entire zone name
            for idx = 1, #tokens do
                local token = tokens[idx]
                if tonumber(token) then
                    -- zone names don't end in numbers so we must have reached the x coordinate
                    mapEnd = idx - 1
                    break
                end
            end

            if not mapEnd then
                printUsage()
                return
            end

            argMapID = table.concat(tokens, " ", 1, mapEnd)
            if argMapID == "here" then
                mapID = C_Map.GetBestMapForUnit("player")
            elseif string.sub(argMapID, 1, 1) == "#" then
                mapID = tonumber(strtrim(argMapID, "#"))
            else
                printError('Waypoints cannot be set using zone names; use the zone\'s id or "here" or no map for your character\'s current map!')
                return
            end

        else
            mapID = C_Map.GetBestMapForUnit("player")
            mapEnd = 0
        end
    else
        printUsage()
        return
    end

    if mapID == nil then
        printError('Failed to place waypoint for map id "' .. argMapID .. '"!')
        return
    end

    local argX, argY, argDesc = select(mapEnd + 1, unpack(tokens))
    if argDesc then
        argDesc = table.concat(tokens, " ", mapEnd + 3)
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

    if argDesc == nil or argDesc == '' then
        printInfo('Placed waypoint on map #' .. mapID .. ' (' .. map.name .. ') at coordinates (' .. x .. '/' .. y .. ').')
    else
        printInfo('Placed waypoint ' .. argDesc .. ' on map #' .. mapID .. ' (' .. map.name .. ') at coordinates (' .. x .. '/' .. y .. ').')
    end
end

SLASH_SLASHWAY1 = '/way'
SlashCmdList["SLASHWAY"] = SlashWay
