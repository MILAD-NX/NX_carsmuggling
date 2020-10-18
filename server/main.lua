--[[################################################
    #       Creat by : Rotcher & Milad_nx          #
    #                  Discord                     #
    #          https://discord.gg/QMvsJap          #
    ################################################]]
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local activity = 0
local activitySource = 0
local cooldown = 0

RegisterServerEvent('NX_carsmuggling:pay')
AddEventHandler('NX_carsmuggling:pay', function(payment)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(payment)
	
	--Add cooldown
	cooldown = Config.CooldownMinutes * 60000
end)

ESX.RegisterServerCallback('NX_carsmuggling:anycops',function(source, cb)
  local anycops = 0
  local playerList = ESX.GetPlayers()
  for i=1, #playerList, 1 do
    local _source = playerList[i]
    local xPlayer = ESX.GetPlayerFromId(_source)
    local playerjob = xPlayer.job.name
    if playerjob == 'police' then
      anycops = anycops + 1
    end
  end
  cb(anycops)
end)

ESX.RegisterServerCallback('NX_carsmuggling:isActive',function(source, cb)
  cb(activity, cooldown)
end)

RegisterServerEvent('NX_carsmuggling:registerActivity')
AddEventHandler('NX_carsmuggling:registerActivity', function(value)
	activity = value
	if value == 1 then
		activitySource = source
		--Send notification to cops
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				TriggerClientEvent('NX_carsmuggling:setcopnotification', xPlayers[i])
			end
		end
	else
		activitySource = 0
	end
end)

RegisterServerEvent('NX_carsmuggling:alertcops')
AddEventHandler('NX_carsmuggling:alertcops', function(cx,cy,cz)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('NX_carsmuggling:setcopblip', xPlayers[i], cx,cy,cz)
		end
	end
end)

RegisterServerEvent('NX_carsmuggling:stopalertcops')
AddEventHandler('NX_carsmuggling:stopalertcops', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('NX_carsmuggling:removecopblip', xPlayers[i])
		end
	end
end)

AddEventHandler('playerDropped', function ()
	local _source = source
	if _source == activitySource then
		--Remove blip for all cops
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				TriggerClientEvent('NX_carsmuggling:removecopblip', xPlayers[i])
			end
		end
		--Set activity to 0
		activity = 0
		activitySource = 0
	end
end)

--Cooldown manager
AddEventHandler('onResourceStart', function(resource)
	while true do
		Wait(5000)
		if cooldown > 0 then
			cooldown = cooldown - 5000
		end
	end
end)
