ESX = nil
-- ESX
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('scandev', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local chance  = math.random(8)
	if xPlayer.job.name ~= 'police' then
		if chance > 7 then
			xPlayer.removeInventoryItem('scandev', 1)
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'Your scanner broke')
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'Scanning for info...')
			TriggerClientEvent('esx_skimmer:scanPlayer', source)
		end
	end
end)

ESX.RegisterUsableItem('skimdev', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name ~= 'police' then
		TriggerClientEvent('esx_skimmer:skimATM', source)
	end
end)

RegisterServerEvent('esx_skimmer:takeBank')
AddEventHandler('esx_skimmer:takeBank', function(target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xTarget = ESX.GetPlayerFromId(target)
	local toLow = xTarget.getBank()
	if toLow > 500 then
		local low = math.floor(xTarget.getBank()/1000)
		local high = math.floor(xTarget.getBank()/50)
		local amount = math.random(low, high)
		if amount < 1 then
			amount = 1
		end
		xTarget.removeAccountMoney('bank', amount)
		xPlayer.addAccountMoney('bank', amount)
		TriggerClientEvent('esx:showAdvancedNotification', _source, 'BANK WARNING', 'Account transfer successful', ' $' .. amount, 'CHAR_BANK_FLEECA', 2)
		Citizen.Wait(2000)
		TriggerClientEvent('esx:showAdvancedNotification', xTarget.source, 'BANK WARNING', 'MAJOR ACCOUNT TRANSFER', ' $' .. amount, 'CHAR_BANK_FLEECA', 2)
	else
		TriggerClientEvent('esx:showAdvancedNotification', _source, 'BANK WARNING', 'Account transfer failed', 'Account too low', 'CHAR_BANK_FLEECA', 2)
	end
end)

RegisterServerEvent('esx_skimmer:applySkim')
AddEventHandler('esx_skimmer:applySkim', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('skimdev', 1)
	repeat
		local timer = math.random(5000, 60000)
		local amount = math.random(100, 3000)
		Citizen.Wait(timer)
		xPlayer.addAccountMoney('bank', amount)
		TriggerClientEvent('esx:showAdvancedNotification', _source, 'BANK WARNING', 'Account transfer successful', ' $' .. amount, 'CHAR_BANK_FLEECA', 2)
	until amount >= 2500
	TriggerClientEvent('esx:showNotification', _source, 'Your skimmer was found')
end)

RegisterServerEvent('esx_skimmer:giveItem')
AddEventHandler('esx_skimmer:giveItem', function(itemName, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local item = xPlayer.getInventoryItem(itemName)
	
	if itemName == 'skimdev' then
		if item.count < item.limit then
			if xPlayer.getMoney() >= 5000 then
				TriggerClientEvent('esx:showNotification', _source, 'You gave $5000 for a skim device')
				xPlayer.removeMoney(5000)
				xPlayer.addInventoryItem(itemName, amount)
			else
				TriggerClientEvent('esx:showNotification', _source, 'Lester needs $5000 cash for his product')
			end
		else
			TriggerClientEvent('esx:showNotification', _source, 'You don\'t want to get caught with too many skimmers')
		end
	elseif itemName == 'scandev' then
		if item.count < item.limit then
			if xPlayer.getMoney() >= 15000 then
				TriggerClientEvent('esx:showNotification', _source, 'You gave $15000 for a skim device')
				xPlayer.removeMoney(15000)
				xPlayer.addInventoryItem(itemName, amount)
			else
				TriggerClientEvent('esx:showNotification', _source, 'Lester needs $15000 cash for his product')
			end
		else
			TriggerClientEvent('esx:showNotification', _source, 'You don\'t want to get caught with too many scanners')
		end
	end
end)