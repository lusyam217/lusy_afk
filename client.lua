local activeAfk = {}
local closeAfk = {}

Citizen.CreateThread(function()
    TriggerServerEvent('lusy_afk:pleaseDontBlameMe')
end)

RegisterNetEvent('lusy_afk:butSomeoneIsActuallySellingThis')
AddEventHandler('lusy_afk:butSomeoneIsActuallySellingThis', function(data)
    activeAfk = data
    startMainThread()
end)

RegisterNetEvent('lusy_afk:cringe')
AddEventHandler('lusy_afk:cringe', function(action, data)
    if action == 'remove' then
        activeAfk[data.sId] = nil
        closeAfk[data.sId] = nil
    elseif action == 'add' then
        activeAfk[data.sId] = data.text
    end
end)

RegisterNetEvent('lusy_afk:whyTwoEvents')
AddEventHandler('lusy_afk:whyTwoEvents', function(bool)
    local playerPed = PlayerPedId()
    SetEntityAlpha(playerPed, bool and 190 or 255, false)
    FreezeEntityPosition(playerPed, bool)
    NetworkSetPlayerIsPassive(bool)
end)

function startMainThread()
    Citizen.CreateThread(function()
        while true do
            local sleep = 1000
            local myCoords = GetEntityCoords(PlayerPedId())

            for sId, v in pairs(activeAfk) do
                local cId = GetPlayerFromServerId(sId)
                if cId ~= -1 then
                    local cPed = GetPlayerPed(cId)
                    local cCoords = GetEntityCoords(cPed)
                    local dist = #(myCoords - cCoords)

                    if dist < 15.0 and not closeAfk[sId] then
                        closeAfk[sId] = {ped = cPed, text = v}
                        sleep = 0
                    elseif dist >= 15.0 and closeAfk[sId] then
                        closeAfk[sId] = nil
                    end
                end
            end

            Citizen.Wait(sleep)
        end
    end)

    Citizen.CreateThread(function()
        while true do
            local sleep = 1000
            if next(closeAfk) ~= nil then
                sleep = 0
                for k, v in pairs(closeAfk) do
                    -- Muestra el texto u otra lógica
                end
            end
            Citizen.Wait(sleep)
        end
    end)
end
