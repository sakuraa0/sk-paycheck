QBCore = exports['qb-core']:GetCoreObject()

local waitMinutes = 10 -- change this for the time you want a paycheck receive
local wait = 60000 * waitMinutes


Citizen.CreateThread(function()
    sk-blip = AddBlipForCoord(-1082.91, -247.99, 37.76)
    SetBlipSprite (sk-blip, 605)
    SetBlipDisplay(sk-blip, 4)
    SetBlipScale  (sk-blip, 0.8)
    SetBlipAsShortRange(sk-blip, true)
    -- SetBlipColour(sk-blip, 50)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Pagamentos")
    EndTextCommandSetBlipName(sk-blip)
end) 

Citizen.CreateThread(function()
    while true do
        Wait(wait)
        TriggerServerEvent('sk-paycheck:Register')
    end
end)

RegisterNetEvent('sk-paycheck:targetcollect')
AddEventHandler('sk-paycheck:targetcollect', function()
    TriggerServerEvent('sk-paycheck:Collect')
end)

CreateThread(function()
    exports['qb-target']:AddBoxZone('paychecks', vector3(-1083.21, -246.95, 37.52), 1.5, 1.6, {
        name = 'paychecks',
        heading = 240,
        debugPoly = false,
    }, {
        options = {
            {
                type = "client",
                event = "sk-paycheck:targetcollect",
                icon = "fas fa-money-check-alt",
                label = "Paycheck",
            },
        },           
        distance = 2.0
    })
end)