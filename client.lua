ESX = nil
local atL = false
storedATM = {}
closestATM = {
	'prop_atm_01',
	'prop_atm_02',
	'prop_atm_03',
	'prop_fleeca_atm',
	'v_5_b_atm1',
	'v_5_b_atm2'
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

GetPlayers = function()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

GetClosestPlayer = function()
  local players = GetPlayers()
  local closestDistance = -1
  local closestPlayer = -1
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)
  
  for index,value in ipairs(players) do
    local target = GetPlayerPed(value)
    if(target ~= ply) then
      local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
      local distance = GetDistanceBetweenCoords(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
      if(closestDistance == -1 or closestDistance > distance) then
        closestPlayer = value
        closestDistance = distance
      end
    end
  end
  
  return closestPlayer, closestDistance
end

LMenu = function()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lester_shop', {
		title    = 'Lester\'s Deals',
		align    = 'top-left',
		elements = {
			{label = 'Purchase Skimmer', value = 'buy_skimmer'},
			{label = 'Purchase Scanner', value = 'buy_scanner'}
		}
	}, function(data, menu)
		
		if data.current.value == 'buy_skimmer' then
			TriggerServerEvent('esx_skimmer:giveItem', 'skimdev', 1)
		elseif data.current.value == 'buy_scanner' then
			TriggerServerEvent('esx_skimmer:giveItem', 'scandev', 1)
		end
	end, function(data, menu)
		atL = false
		menu.close()
		ESX.ShowNotification('Lester thanks you for your business')
	end)
end

RegisterNetEvent('esx_skimmer:scanPlayer')
AddEventHandler('esx_skimmer:scanPlayer', function()
	local ped = GetPlayerPed(-1)
	local pos = GetEntityCoords(ped)
	local tar, dis = GetClosestPlayer()
	TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_STAND_MOBILE', 0, false)
	if (dis ~= -1 and dis <= 1) then
		Citizen.Wait(5000)
		TriggerServerEvent('esx_skimmer:takeBank', GetPlayerServerId(tar))
		ClearPedTasks(ped)
	else
		Citizen.Wait(5000)
		ESX.ShowNotification('No data card within range')
		ClearPedTasks(ped)
	end
end)

RegisterNetEvent('esx_skimmer:skimATM')
AddEventHandler('esx_skimmer:skimATM', function()
	local ped = GetPlayerPed(-1)
	local coords = GetEntityCoords(ped)
	for i = 1,#closestATM do
		local atm = GetClosestObjectOfType(coords, 1.0, GetHashKey(closestATM[i]), false, false, false)
		local entity = nil
		if DoesEntityExist(atm) then
			entity = atm
			TaskStartScenarioInPlace(ped, 'PROP_HUMAN_ATM', 0, false)
			Citizen.Wait(1000)
			if not storedATM[entity] then
				TriggerServerEvent('esx_skimmer:applySkim')
				ESX.ShowNotification('Skimmer applied')
				storedATM[entity] = true
				entity = nil
			else
				ESX.ShowNotification('You have already skimmed this ATM')
			end
			Citizen.Wait(1000)
			ClearPedTasks(ped)
		end
	end
end)

Citizen.CreateThread(function()
	local model = -1248528957
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(10)
	end
	local Lester = CreatePed(1, model, 1275.00, -1707.89, 53.26, 115.24, false, true)
	SetBlockingOfNonTemporaryEvents(Lester, true)
	SetPedDiesWhenInjured(Lester, false)
	SetPedCanPlayAmbientAnims(Lester, true)
	SetPedCanRagdollFromPlayerImpact(Lester, false)
	SetEntityInvincible(Lester, true)
	FreezeEntityPosition(Lester, true)
	TaskStartScenarioInPlace(Lester, 'PROP_HUMAN_SEAT_DECKCHAIR', 0, true)
end)
	
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local pos = GetEntityCoords(ped)
		local dis = GetDistanceBetweenCoords(pos, 1274.88, -1707.89, 55.26, true)
		if dis < 1.5 and not atL then
			if ESX.PlayerData.job.name ~= 'police' then
				PlayAmbientSpeechWithVoice(Lester, 'GENERIC_HI', 'LESTER', 'SPEECH_PARAMS_FORCE_NO_REPEAT_FRONTEND', 0)
				ESX.ShowHelpNotification('Press ~g~E~s~ to see what Lester has for you')
				if IsControlJustReleased(0, 38) then
					atL = true
					LMenu()
				end
			else
				ESX.ShowNotification('Lester doesn\'t talk to the cops')
			end
		elseif dis > 1.5 and atL then
			ESX.ShowNotification('Lester thinks it rude for you to just walk away')
			ESX.UI.Menu.CloseAll()
			atL = false
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		ESX.UI.Menu.CloseAll()
	end
end)