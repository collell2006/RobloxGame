-- MarketplaceHandler.lua – Sistema oficial de compras, pases y ProcessReceipt
-- Colócalo en ServerScriptService/Core

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(game.ReplicatedStorage.Config.Products)
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local BuyGamePass = RemoteEvents:WaitForChild("BuyGamePass")
local BuyProduct = RemoteEvents:WaitForChild("BuyProduct")
local Notify = RemoteEvents:WaitForChild("Notify")

local MarketplaceHandler = {}

-- 1. Verificar si el jugador ya posee el Game Pass al entrar
local function checkGamePassOwnership(player)
    local passId = Config.GamePasses.PremiumPass
    if not passId or passId == 12345678 then return end

    local success, ownsPass = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(player.UserId, passId)
    end)

    if success and ownsPass then
        player:SetAttribute("VIP", true)
        print(player.Name .. " posee el Game Pass VIP.")
    end
end

-- 2. Manejo oficial de Developer Products con ProcessReceipt
MarketplaceService.ProcessReceipt = function(receiptInfo)
    local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
    if not player then
        -- El jugador abandonó el servidor antes de procesar la compra; reintentar después
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    local productId = receiptInfo.ProductId

    if productId == Config.DeveloperProducts.CoinPack then
        local currentCoins = player:GetAttribute("Coins") or 0
        player:SetAttribute("Coins", currentCoins + 500)

        Notify:FireClient(player, {
            text = "¡Compra exitosa! Has recibido +500 Monedas.",
            type = "Success"
        })
        print(string.format("[DevProduct] %s compró CoinPack (+500 coins).", player.Name))
        return Enum.ProductPurchaseDecision.PurchaseGranted
    end

    return Enum.ProductPurchaseDecision.PurchaseGranted
end

-- 3. Manejo de Game Pass comprado en la sesión actual
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamePassId, wasPurchased)
    if wasPurchased and gamePassId == Config.GamePasses.PremiumPass then
        player:SetAttribute("VIP", true)
        local currentCoins = player:GetAttribute("Coins") or 0
        player:SetAttribute("Coins", currentCoins + 1000)

        Notify:FireClient(player, {
            text = "¡VIP Activado! Recibes +1,000 Monedas y x2 en monedas.",
            type = "Success"
        })
        print(string.format("[GamePass] %s desbloqueó VIP.", player.Name))
    end
end)

-- 4. Disparar ventanas de compra desde la UI del cliente
BuyGamePass.OnServerEvent:Connect(function(player)
    local passId = Config.GamePasses.PremiumPass
    if passId then
        MarketplaceService:PromptGamePassPurchase(player, passId)
    end
end)

BuyProduct.OnServerEvent:Connect(function(player)
    local prodId = Config.DeveloperProducts.CoinPack
    if prodId then
        MarketplaceService:PromptProductPurchase(player, prodId)
    end
end)

Players.PlayerAdded:Connect(checkGamePassOwnership)

print("[MarketplaceHandler] Sistema de compras y ProcessReceipt activo.")

return MarketplaceHandler
