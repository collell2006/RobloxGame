-- TrailManager.lua – Sistema de cosméticos y estelas (Trails) para los jugadores
-- Colócalo en ServerScriptService/Core

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local BuyTrail = RemoteEvents:WaitForChild("BuyTrail")
local EquipTrail = RemoteEvents:WaitForChild("EquipTrail")
local Notify = RemoteEvents:WaitForChild("Notify")

local TrailManager = {}

-- Catálogo de estelas disponibles en el juego
TrailManager.TrailsCatalog = {
    ["Rainbow"] = {
        Name = "Arcoíris Cósmico",
        Price = 100,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 165, 0)),
            ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 200, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 0, 255)),
        }),
        LightEmission = 1,
        Lifetime = 0.7,
    },
    ["Fire"] = {
        Name = "Fuego Volcánico",
        Price = 250,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 100)),
            ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 120, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 20, 0)),
        }),
        LightEmission = 0.8,
        Lifetime = 0.6,
    },
    ["Cyber"] = {
        Name = "Ciber Neón",
        Price = 450,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 150)),
        }),
        LightEmission = 1,
        Lifetime = 0.8,
    },
    ["Golden"] = {
        Name = "Oro Divino",
        Price = 800,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 240, 150)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 150, 0)),
        }),
        LightEmission = 1,
        Lifetime = 0.9,
    },
}

-- Función auxiliar para verificar si un jugador posee una estela
local function playerOwnsTrail(player, trailId)
    if trailId == "None" then return true end
    local ownedJson = player:GetAttribute("OwnedTrails") or '["None"]'
    local ownedTable = {"None"}
    pcall(function()
        ownedTable = HttpService:JSONDecode(ownedJson)
    end)
    for _, id in ipairs(ownedTable) do
        if id == trailId then return true end
    end
    return false
end

-- Añadir estela al inventario del jugador
local function addTrailToPlayer(player, trailId)
    local ownedJson = player:GetAttribute("OwnedTrails") or '["None"]'
    local ownedTable = {"None"}
    pcall(function()
        ownedTable = HttpService:JSONDecode(ownedJson)
    end)
    table.insert(ownedTable, trailId)
    player:SetAttribute("OwnedTrails", HttpService:JSONEncode(ownedTable))
end

-- Eliminar estelas existentes del personaje
local function clearExistingTrails(character)
    for _, item in ipairs(character:GetDescendants()) do
        if item:IsA("Trail") and item.Name == "PlayerActiveTrail" then
            item:Destroy()
        end
    end
end

-- Aplicar la estela al personaje físico
function TrailManager.ApplyTrailToCharacter(player, character)
    local equipped = player:GetAttribute("EquippedTrail") or "None"
    clearExistingTrails(character)

    if equipped == "None" or not TrailManager.TrailsCatalog[equipped] then
        return
    end

    local trailData = TrailManager.TrailsCatalog[equipped]
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    if not rootPart then return end

    -- Asegurar Attachments
    local attTop = rootPart:FindFirstChild("TrailAttTop")
    if not attTop then
        attTop = Instance.new("Attachment")
        attTop.Name = "TrailAttTop"
        attTop.Position = Vector3.new(0, 1.2, 0)
        attTop.Parent = rootPart
    end

    local attBottom = rootPart:FindFirstChild("TrailAttBottom")
    if not attBottom then
        attBottom = Instance.new("Attachment")
        attBottom.Name = "TrailAttBottom"
        attBottom.Position = Vector3.new(0, -1.2, 0)
        attBottom.Parent = rootPart
    end

    -- Crear Trail
    local trail = Instance.new("Trail")
    trail.Name = "PlayerActiveTrail"
    trail.Attachment0 = attTop
    trail.Attachment1 = attBottom
    trail.Color = trailData.Color
    trail.LightEmission = trailData.LightEmission
    trail.Lifetime = trailData.Lifetime
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(0.8, 0.4),
        NumberSequenceKeypoint.new(1, 1),
    })
    trail.WidthScale = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0.1),
    })
    trail.Parent = rootPart
end

-- Inicialización y eventos
function TrailManager.Init()
    -- Conectar reaparición del personaje
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(char)
            task.wait(0.2)
            TrailManager.ApplyTrailToCharacter(player, char)
        end)
    end)

    for _, player in ipairs(Players:GetPlayers()) do
        player.CharacterAdded:Connect(function(char)
            task.wait(0.2)
            TrailManager.ApplyTrailToCharacter(player, char)
        end)
    end

    -- Compra de Estelas
    BuyTrail.OnServerEvent:Connect(function(player, trailId)
        local trailData = TrailManager.TrailsCatalog[trailId]
        if not trailData then return end

        if playerOwnsTrail(player, trailId) then
            Notify:FireClient(player, {
                text = "¡Ya tienes esta estela!",
                type = "Info"
            })
            return
        end

        local currentCoins = player:GetAttribute("Coins") or 0
        if currentCoins >= trailData.Price then
            player:SetAttribute("Coins", currentCoins - trailData.Price)
            addTrailToPlayer(player, trailId)
            player:SetAttribute("EquippedTrail", trailId)

            if player.Character then
                TrailManager.ApplyTrailToCharacter(player, player.Character)
            end

            Notify:FireClient(player, {
                text = string.format("¡Compraste %s! Se ha equipado automáticamente.", trailData.Name),
                type = "Success"
            })
            print(string.format("[Trails] %s compró %s por %d monedas.", player.Name, trailId, trailData.Price))
        else
            Notify:FireClient(player, {
                text = string.format("Monedas insuficientes. Necesitas %d monedas.", trailData.Price),
                type = "Error"
            })
        end
    end)

    -- Equipar / Desequipar Estelas
    EquipTrail.OnServerEvent:Connect(function(player, trailId)
        if trailId ~= "None" and not playerOwnsTrail(player, trailId) then
            Notify:FireClient(player, {
                text = "No posees esta estela todavía.",
                type = "Error"
            })
            return
        end

        player:SetAttribute("EquippedTrail", trailId)
        if player.Character then
            TrailManager.ApplyTrailToCharacter(player, player.Character)
        end

        local msg = (trailId == "None") and "Estela desequipada." or "Estela equipada con éxito."
        Notify:FireClient(player, {
            text = msg,
            type = "Info"
        })
    end)

    print("[TrailManager] Sistema de estelas y cosméticos activo.")
end

return TrailManager
