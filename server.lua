local afkPlayers = {}
local ignoredSteamID = "steam:xxxx" -- Reemplaza con la ID de Steam específica

RegisterNetEvent('lusy_afk:pleaseDontBlameMe')
AddEventHandler('lusy_afk:pleaseDontBlameMe', function()
    local src = source
    local steamID = GetPlayerIdentifiers(src)[1]
    if steamID ~= ignoredSteamID then
        TriggerClientEvent('lusy_afk:butSomeoneIsActuallySellingThis', src, afkPlayers)
    end
end)

RegisterCommand('afk', function(src, args)
    local steamID = GetPlayerIdentifiers(src)[1]
    if steamID == ignoredSteamID then return end

    local argument = table.concat(args, " ", 1, #args)
    if not isAdmin(src) then return end

    if argument == '' then
        if afkPlayers[src] then
            afkPlayers[src] = nil
            TriggerClientEvent('lusy_afk:whyTwoEvents', src, false)
            TriggerClientEvent('lusy_afk:cringe', -1, 'remove', {sId = src})
        end
        return 
    end

    if args[1] ~= '' then
        if argument then
            afkPlayers[src] = argument
            local time = os.date("*t")
            TriggerClientEvent('lusy_afk:whyTwoEvents', src, true)
            TriggerClientEvent('lusy_afk:cringe', -1, 'add', {
                sId = src,
                text = string.format('~o~ AFK ~w~\n~b~Tiempo:~w~ %02d:%02d\n~b~Razon:~w~ %s', time.hour, time.min, argument)
            })
        end
    end
end)

RegisterCommand('afkid', function(src, args)
    local plyId = tonumber(args[1])
    local argument = table.concat(args, " ", 2, #args)

    local steamID = GetPlayerIdentifiers(plyId)[1]
    if steamID == ignoredSteamID then return end

    if not isAdmin(src) then return end

    if plyId == nil or GetPlayerPing(plyId) == 0 then return end

    if argument == '' then
        if afkPlayers[plyId] then
            afkPlayers[plyId] = nil
            TriggerClientEvent('lusy_afk:whyTwoEvents', plyId, false)
            TriggerClientEvent('lusy_afk:cringe', -1, 'remove', {sId = plyId})
        end
        return 
    end

    if argument then
        afkPlayers[plyId] = argument
        local time = os.date("*t")
        TriggerClientEvent('lusy_afk:whyTwoEvents', plyId, true)
        TriggerClientEvent('lusy_afk:cringe', -1, 'add', {
            sId = plyId,
            text = string.format('~b~- AFK -~w~\n~b~Tiempo:~w~ %02d:%02d\n~b~Motivo:~w~ %s', time.hour, time.min, argument)
        })
    end
end, false)

function isAdmin(src)
    local srcSteam = GetPlayerIdentifiers(src)[1]
    for _, v in pairs(adminHex) do
        if v == srcSteam then
            return true
        end
    end
    return false
end
