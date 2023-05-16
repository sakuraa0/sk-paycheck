QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('sk-paycheck:Register')
AddEventHandler('sk-paycheck:Register', function()
    local source = source
	local Player = QBCore.Functions.GetPlayer(source)	
	local cid = Player.PlayerData.citizenid
    local payment = Player.PlayerData.job.payment
    if Player.PlayerData.job.onduty then
        MySQL.Async.fetchAll("SELECT * FROM `sk-paycheck` WHERE citizenid = '"..cid.."'", function(result)
            if result[1] ~= nil then
                local collectamount = result[1].collectamount+payment
                local currentpaycheck = result[1].collectamount
                exports.oxmysql:execute("UPDATE sk-paycheck SET collectamount = '"..collectamount.."' WHERE citizenid = '"..cid.."'")
                TriggerClientEvent('QBCore:Notify', source, 'go receive your paycheck')
                Citizen.Wait(1000)
                TriggerEvent("qb-log:server:CreateLog", "sk-paycheck", "Paychecks", "white", " | "..cid.." now has "..collectamount.." waiting as a paycheck")
            else	
                exports.oxmysql:insert("INSERT INTO `sk-paycheck` (`citizenid`, `collectamount`) VALUES ('"..cid.."', '"..payment.."')")
            end
        end)
    else
        TriggerClientEvent('QBCore:Notify', source, 'you need set on duty')
    end
end)

RegisterServerEvent('sk-paycheck:Collect')
AddEventHandler('sk-paycheck:Collect', function()
    local source = source
	local Player = QBCore.Functions.GetPlayer(source)	
	local cid = Player.PlayerData.citizenid
    local payment = Player.PlayerData.job.payment
    MySQL.Async.fetchAll("SELECT * FROM `sk-paycheck` WHERE citizenid = '"..cid.."'", function(result)
        if result[1] ~= nil then
            local paycheck = result[1].collectamount
            Player.Functions.AddMoney("cash", paycheck)
            exports.oxmysql:execute("UPDATE sk-paycheck SET collectamount = 0 WHERE citizenid = '"..cid.."'")
            TriggerClientEvent('QBCore:Notify', source, 'receive a payment of '..paycheck..'!')
            TriggerEvent("qb-log:server:CreateLog", "sk-paycheck", "Paychecks", "white", " | "..cid.." collected "..paycheck.." from their paycheck")
        else
            print('You don\'t have a job?')
        end
    end)
end)