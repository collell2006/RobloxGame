-- DataStoreHandler.lua – Sistema de persistencia seguro con reintentos, leaderstats y renacimientos
-- Colócalo en ServerScriptService/Core

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local PlayerDataStore = DataStoreService:GetDataStore("MiPrimerJuego_PlayerData_v2")

local MAX_RETRIES = 3
local RETRY_DELAY = 1

local DEFAULT_DATA = {
    Coins = 0,
    Stage = 1,
    Rebirths = 0,
    Experience = 0,
    EquippedTrail = "None",
    OwnedTrails = {"None"},
}

-- Función auxiliar para reintentar operaciones de red
local function retryAsync(operation)
    local attempts = 0
    local success, result
    repeat
        attempts = attempts + 1
        success, result = pcall(operation)
        if not success then
            task.wait(RETRY_DELAY)
        end
    until success or attempts >= MAX_RETRIES
    return success, result
end

-- Cargar datos
local function loadData(userId)
    local success, data = retryAsync(function()
        return PlayerDataStore:GetAsync(tostring(userId))
    end)

    if success and data then
        data.Coins = data.Coins or DEFAULT_DATA.Coins
        data.Stage = data.Stage or DEFAULT_DATA.Stage
        data.Rebirths = data.Rebirths or DEFAULT_DATA.Rebirths
        data.Experience = data.Experience or DEFAULT_DATA.Experience
        data.EquippedTrail = data.EquippedTrail or DEFAULT_DATA.EquippedTrail
        data.OwnedTrails = data.OwnedTrails or DEFAULT_DATA.OwnedTrails
        return data
    else
        return {
            Coins = DEFAULT_DATA.Coins,
            Stage = DEFAULT_DATA.Stage,
            Rebirths = DEFAULT_DATA.Rebirths,
            Experience = DEFAULT_DATA.Experience,
            EquippedTrail = DEFAULT_DATA.EquippedTrail,
            OwnedTrails = {"None"},
        }
    end
end

-- Guardar datos
local function saveData(userId, data)
    local success, err = retryAsync(function()
        PlayerDataStore:SetAsync(tostring(userId), data)
    end)
    if not success then
        warn("Error al guardar datos de " .. tostring(userId) .. ": " .. tostring(err))
    end
    return success
end

-- Extraer datos actuales de los atributos del jugador
local function getPlayerDataFromPlayer(player)
    local ownedTrailsJson = player:GetAttribute("OwnedTrails") or '["None"]'
    local ownedTable = {"None"}
    pcall(function()
        ownedTable = HttpService:JSONDecode(ownedTrailsJson)
    end)

    return {
        Coins = player:GetAttribute("Coins") or 0,
        Stage = player:GetAttribute("Stage") or 1,
        Rebirths = player:GetAttribute("Rebirths") or 0,
        Experience = player:GetAttribute("Experience") or 0,
        EquippedTrail = player:GetAttribute("EquippedTrail") or "None",
        OwnedTrails = ownedTable,
    }
end

-- Configuración de leaderstats visibles en la lista de jugadores de Roblox
local function setupPlayer(player)
    local data = loadData(player.UserId)

    -- Guardar en atributos
    player:SetAttribute("Coins", data.Coins)
    player:SetAttribute("Stage", data.Stage)
    player:SetAttribute("Rebirths", data.Rebirths)
    player:SetAttribute("Experience", data.Experience)
    player:SetAttribute("EquippedTrail", data.EquippedTrail)
    player:SetAttribute("OwnedTrails", HttpService:JSONEncode(data.OwnedTrails))

    -- Crear carpeta leaderstats oficial de Roblox
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local stageVal = Instance.new("IntValue")
    stageVal.Name = "Nivel"
    stageVal.Value = data.Stage
    stageVal.Parent = leaderstats

    local coinsVal = Instance.new("IntValue")
    coinsVal.Name = "Monedas"
    coinsVal.Value = data.Coins
    coinsVal.Parent = leaderstats

    local rebirthVal = Instance.new("IntValue")
    rebirthVal.Name = "Renacer"
    rebirthVal.Value = data.Rebirths
    rebirthVal.Parent = leaderstats

    -- Sincronizar atributos con leaderstats reactivamente
    player:GetAttributeChangedSignal("Coins"):Connect(function()
        coinsVal.Value = player:GetAttribute("Coins") or 0
    end)

    player:GetAttributeChangedSignal("Stage"):Connect(function()
        stageVal.Value = player:GetAttribute("Stage") or 1
    end)

    player:GetAttributeChangedSignal("Rebirths"):Connect(function()
        rebirthVal.Value = player:GetAttribute("Rebirths") or 0
    end)
end

local function onPlayerRemoving(player)
    local data = getPlayerDataFromPlayer(player)
    saveData(player.UserId, data)
end

-- Guardado seguro al cerrar el servidor (BindToClose)
game:BindToClose(function()
    print("[DataStore] Servidor cerrándose. Guardando datos de todos los jugadores...")
    for _, player in ipairs(Players:GetPlayers()) do
        onPlayerRemoving(player)
    end
    if RunService:IsStudio() then
        task.wait(2)
    end
end)

-- Auto-guardado periódico cada 3 minutos
task.spawn(function()
    while true do
        task.wait(180)
        for _, player in ipairs(Players:GetPlayers()) do
            local data = getPlayerDataFromPlayer(player)
            saveData(player.UserId, data)
        end
    end
end)

Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(onPlayerRemoving)

local DataStoreHandler = {}
DataStoreHandler.Load = loadData
DataStoreHandler.Save = saveData
DataStoreHandler.SetupPlayer = setupPlayer
DataStoreHandler.GetPlayerData = getPlayerDataFromPlayer
return DataStoreHandler
