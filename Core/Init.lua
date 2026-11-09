-- Init.lua – Orquestador principal del Servidor
-- Colócalo en ServerScriptService/Core o como Script principal en ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("==========================================")
print("🚀 Iniciando Servidor: MiPrimerJuego...")
print("==========================================")

-- 1. Inicializar RemoteEvents en ReplicatedStorage
local RemoteSetup = require(script.Parent:WaitForChild("RemoteEventsSetup"))
RemoteSetup()

-- 2. Cargar manejadores de base de datos y compras
local DataStore = require(script.Parent:WaitForChild("DataStoreHandler"))
local Marketplace = require(script.Parent:WaitForChild("MarketplaceHandler"))

-- 3. Cargar sistemas de Renacimientos y Estelas Cosméticas
local RebirthManager = require(script.Parent:WaitForChild("RebirthManager"))
RebirthManager.Init()

local TrailManager = require(script.Parent:WaitForChild("TrailManager"))
TrailManager.Init()

-- 4. Generar el mundo del juego (Obby, Trampolines, Boosters y Lava)
local Obby = require(script.Parent:WaitForChild("ObbySetup"))
local checkpointsFolder = Obby.buildObby()

-- 5. Inicializar sistema de Checkpoints y Respawn
local CheckpointManager = require(script.Parent:WaitForChild("CheckpointManager"))
CheckpointManager.Init(checkpointsFolder)

-- 6. Generar monedas animadas con partículas
local CoinSpawner = require(script.Parent:WaitForChild("CoinSpawner"))
CoinSpawner.spawnCoins()

print("==========================================")
print("✅ Servidor listo. ¡Partida iniciada con éxito!")
print("==========================================")

local Init = {
    Obby = Obby,
    CheckpointManager = CheckpointManager,
    CoinSpawner = CoinSpawner,
    DataStore = DataStore,
    Marketplace = Marketplace,
    RebirthManager = RebirthManager,
    TrailManager = TrailManager,
}

return Init
