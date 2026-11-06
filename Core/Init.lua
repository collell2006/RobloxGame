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

-- 3. Generar el mundo del juego (Obby y Lava)
local Obby = require(script.Parent:WaitForChild("ObbySetup"))
local checkpointsFolder = Obby.buildObby()

-- 4. Inicializar sistema de Checkpoints y Respawn
local CheckpointManager = require(script.Parent:WaitForChild("CheckpointManager"))
CheckpointManager.Init(checkpointsFolder)

-- 5. Generar monedas animadas sobre las plataformas
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
}

return Init
