-- CoinSpawner.lua – Genera monedas giratorias coleccionables a lo largo del circuito
-- Colócalo en ServerScriptService/Core

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local CoinSpawner = {}

local function createSpinningCoin(position, parentFolder)
    local coin = Instance.new("Part")
    coin.Name = "GoldCoin"
    coin.Shape = Enum.PartType.Cylinder
    coin.Size = Vector3.new(0.4, 2.5, 2.5)
    coin.Orientation = Vector3.new(0, 0, 90)
    coin.Position = position
    coin.Anchored = true
    coin.CanCollide = false
    coin.Material = Enum.Material.Neon
    coin.Color = Color3.fromRGB(255, 215, 0)
    coin.Parent = parentFolder

    -- Brillo / PointLight
    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(255, 220, 100)
    light.Brightness = 2
    light.Range = 8
    light.Parent = coin

    -- Animación de rotación continua
    task.spawn(function()
        while coin and coin.Parent do
            coin.CFrame = coin.CFrame * CFrame.Angles(0, math.rad(4), 0)
            task.wait(0.03)
        end
    end)

    -- Detección de recolección
    local isCollected = false
    coin.Touched:Connect(function(hit)
        local character = hit.Parent
        local player = Players:GetPlayerFromCharacter(character)
        if player and not isCollected then
            isCollected = true

            -- Multiplicador si tiene atributo VIP
            local multiplier = player:GetAttribute("VIP") and 2 or 1
            local reward = 1 * multiplier
            local currentCoins = player:GetAttribute("Coins") or 0
            player:SetAttribute("Coins", currentCoins + reward)

            -- Ocultar temporalmente
            coin.Transparency = 1
            light.Enabled = false

            -- Reaparece tras 12 segundos
            task.delay(12, function()
                if coin and coin.Parent then
                    coin.Transparency = 0
                    light.Enabled = true
                    isCollected = false
                end
            end)
        end
    end)

    return coin
end

function CoinSpawner.spawnCoins()
    local existing = Workspace:FindFirstChild("CoinsFolder")
    if existing then
        existing:Destroy()
    end

    local coinsFolder = Instance.new("Folder")
    coinsFolder.Name = "CoinsFolder"
    coinsFolder.Parent = Workspace

    local obby = Workspace:FindFirstChild("Obby")
    if obby and obby:FindFirstChild("Platforms") then
        for _, platform in ipairs(obby.Platforms:GetChildren()) do
            -- Generar una moneda flotando 3 studs arriba de cada plataforma
            local coinPos = platform.Position + Vector3.new(0, 3.5, 0)
            createSpinningCoin(coinPos, coinsFolder)
        end
    end

    print("[CoinSpawner] Monedas generadas y animadas sobre el recorrido.")
end

return CoinSpawner
