-- StoreGui.client.lua – Tienda con Pestañas (Robux y Estelas Cosméticas)
-- Colócalo en StarterGui (se ejecuta como LocalScript en cada cliente)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")

local BuyGamePass = RemoteEvents:WaitForChild("BuyGamePass")
local BuyProduct = RemoteEvents:WaitForChild("BuyProduct")
local BuyTrail = RemoteEvents:WaitForChild("BuyTrail")
local EquipTrail = RemoteEvents:WaitForChild("EquipTrail")

-- ScreenGui
local storeGui = Instance.new("ScreenGui")
storeGui.Name = "StoreGui"
storeGui.ResetOnSpawn = false
storeGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
storeGui.Parent = playerGui

-- Marco Principal (Modal)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 600, 0, 420)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = storeGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 14)
frameCorner.Parent = mainFrame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(240, 150, 40)
frameStroke.Thickness = 2.5
frameStroke.Parent = mainFrame

-- Encabezado: Título y Cerrar
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -70, 0, 45)
title.Position = UDim2.new(0, 20, 0, 10)
title.BackgroundTransparency = 1
title.Text = "🛒 TIENDA DE MEJORAS"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.FredokaOne
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -48, 0, 12)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.FredokaOne
closeBtn.TextSize = 20
closeBtn.Text = "✕"
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Pestañas de Navegación
local tabRobuxBtn = Instance.new("TextButton")
tabRobuxBtn.Size = UDim2.new(0.48, 0, 0, 36)
tabRobuxBtn.Position = UDim2.new(0, 20, 0, 58)
tabRobuxBtn.BackgroundColor3 = Color3.fromRGB(240, 140, 20)
tabRobuxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tabRobuxBtn.Font = Enum.Font.FredokaOne
tabRobuxBtn.TextSize = 15
tabRobuxBtn.Text = "💎 ROBUX & PASES"
tabRobuxBtn.Parent = mainFrame

local tCorner1 = Instance.new("UICorner")
tCorner1.CornerRadius = UDim.new(0, 8)
tCorner1.Parent = tabRobuxBtn

local tabTrailsBtn = Instance.new("TextButton")
tabTrailsBtn.Size = UDim2.new(0.48, 0, 0, 36)
tabTrailsBtn.Position = UDim2.new(0.52, -10, 0, 58)
tabTrailsBtn.BackgroundColor3 = Color3.fromRGB(50, 55, 70)
tabTrailsBtn.TextColor3 = Color3.fromRGB(200, 205, 220)
tabTrailsBtn.Font = Enum.Font.FredokaOne
tabTrailsBtn.TextSize = 15
tabTrailsBtn.Text = "✨ ESTELAS COSMÉTICAS"
tabTrailsBtn.Parent = mainFrame

local tCorner2 = Instance.new("UICorner")
tCorner2.CornerRadius = UDim.new(0, 8)
tCorner2.Parent = tabTrailsBtn

-- Contenedores de contenido
local robuxContainer = Instance.new("Frame")
robuxContainer.Name = "RobuxContainer"
robuxContainer.Size = UDim2.new(1, -40, 1, -115)
robuxContainer.Position = UDim2.new(0, 20, 0, 105)
robuxContainer.BackgroundTransparency = 1
robuxContainer.Parent = mainFrame

local trailsContainer = Instance.new("ScrollingFrame")
trailsContainer.Name = "TrailsContainer"
trailsContainer.Size = UDim2.new(1, -40, 1, -115)
trailsContainer.Position = UDim2.new(0, 20, 0, 105)
trailsContainer.BackgroundTransparency = 1
trailsContainer.BorderSizePixel = 0
trailsContainer.ScrollBarThickness = 6
trailsContainer.CanvasSize = UDim2.new(0, 0, 1.4, 0)
trailsContainer.Visible = false
trailsContainer.Parent = mainFrame

local trailsGrid = Instance.new("UIGridLayout")
trailsGrid.CellSize = UDim2.new(0.48, 0, 0, 175)
trailsGrid.CellPadding = UDim2.new(0.04, 0, 0, 15)
trailsGrid.Parent = trailsContainer

-- Conmutador de Pestañas
tabRobuxBtn.MouseButton1Click:Connect(function()
    tabRobuxBtn.BackgroundColor3 = Color3.fromRGB(240, 140, 20)
    tabRobuxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabTrailsBtn.BackgroundColor3 = Color3.fromRGB(50, 55, 70)
    tabTrailsBtn.TextColor3 = Color3.fromRGB(200, 205, 220)
    robuxContainer.Visible = true
    trailsContainer.Visible = false
end)

tabTrailsBtn.MouseButton1Click:Connect(function()
    tabTrailsBtn.BackgroundColor3 = Color3.fromRGB(160, 50, 230)
    tabTrailsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabRobuxBtn.BackgroundColor3 = Color3.fromRGB(50, 55, 70)
    tabRobuxBtn.TextColor3 = Color3.fromRGB(200, 205, 220)
    robuxContainer.Visible = false
    trailsContainer.Visible = true
end)

-- =========================================================
-- PESTAÑA 1: PRODUCTOS ROBUX
-- =========================================================
local function createRobuxCard(titleText, descText, priceText, btnColor, xOffset, onBuy)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.48, 0, 1, 0)
    card.Position = UDim2.new(xOffset, 0, 0, 0)
    card.BackgroundColor3 = Color3.fromRGB(38, 41, 52)
    card.BorderSizePixel = 0
    card.Parent = robuxContainer

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 12)
    cardCorner.Parent = card

    local itemTitle = Instance.new("TextLabel")
    itemTitle.Size = UDim2.new(1, -20, 0, 35)
    itemTitle.Position = UDim2.new(0, 10, 0, 10)
    itemTitle.BackgroundTransparency = 1
    itemTitle.Text = titleText
    itemTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
    itemTitle.Font = Enum.Font.FredokaOne
    itemTitle.TextSize = 18
    itemTitle.Parent = card

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -20, 0, 160)
    desc.Position = UDim2.new(0, 10, 0, 45)
    desc.BackgroundTransparency = 1
    desc.Text = descText
    desc.TextColor3 = Color3.fromRGB(200, 205, 215)
    desc.Font = Enum.Font.SourceSans
    desc.TextSize = 16
    desc.TextWrapped = true
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.Parent = card

    local buyButton = Instance.new("TextButton")
    buyButton.Size = UDim2.new(1, -24, 0, 44)
    buyButton.Position = UDim2.new(0, 12, 1, -54)
    buyButton.BackgroundColor3 = btnColor
    buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    buyButton.Font = Enum.Font.FredokaOne
    buyButton.TextSize = 17
    buyButton.Text = priceText
    buyButton.AutoButtonColor = true
    buyButton.Parent = card

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 8)
    bCorner.Parent = buyButton

    buyButton.MouseButton1Click:Connect(onBuy)
    return card
end

createRobuxCard(
    "👑 PASE VIP",
    "• Multiplicador x2 permanente en todas las monedas del mapa.\n• +1,000 Monedas inmediatas.\n• Distintivo [VIP] exclusivo en pantalla y clasificaciones.",
    "Comprar VIP",
    Color3.fromRGB(230, 130, 20),
    0,
    function()
        BuyGamePass:FireServer()
    end
)

createRobuxCard(
    "💰 PACK 500 COINS",
    "• Recibe +500 Monedas al instante.\n• Úsalas para desbloquear estelas legendarias inmediatamente.\n• ¡Compra repetible!",
    "Comprar Pack",
    Color3.fromRGB(40, 175, 90),
    0.52,
    function()
        BuyProduct:FireServer()
    end
)

-- =========================================================
-- PESTAÑA 2: ESTELAS (COSMÉTICOS CON MONEDAS)
-- =========================================================
local trailsData = {
    {Id = "Rainbow", Name = "Arcoíris Cósmico", Price = 100, Color = Color3.fromRGB(255, 100, 200)},
    {Id = "Fire", Name = "Fuego Volcánico", Price = 250, Color = Color3.fromRGB(255, 120, 0)},
    {Id = "Cyber", Name = "Ciber Neón", Price = 450, Color = Color3.fromRGB(0, 220, 255)},
    {Id = "Golden", Name = "Oro Divino", Price = 800, Color = Color3.fromRGB(255, 215, 0)},
}

local function renderTrails()
    for _, child in ipairs(trailsContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    local ownedJson = localPlayer:GetAttribute("OwnedTrails") or '["None"]'
    local ownedTable = {"None"}
    pcall(function()
        ownedTable = HttpService:JSONDecode(ownedJson)
    end)

    local equipped = localPlayer:GetAttribute("EquippedTrail") or "None"

    local function owns(id)
        for _, item in ipairs(ownedTable) do
            if item == id then return true end
        end
        return false
    end

    for _, t in ipairs(trailsData) do
        local card = Instance.new("Frame")
        card.BackgroundColor3 = Color3.fromRGB(38, 41, 52)
        card.Parent = trailsContainer

        local cCorner = Instance.new("UICorner")
        cCorner.CornerRadius = UDim.new(0, 10)
        cCorner.Parent = card

        local tTitle = Instance.new("TextLabel")
        tTitle.Size = UDim2.new(1, -20, 0, 30)
        tTitle.Position = UDim2.new(0, 10, 0, 10)
        tTitle.BackgroundTransparency = 1
        tTitle.Text = t.Name
        tTitle.TextColor3 = t.Color
        tTitle.Font = Enum.Font.FredokaOne
        tTitle.TextSize = 17
        tTitle.Parent = card

        local pLabel = Instance.new("TextLabel")
        pLabel.Size = UDim2.new(1, -20, 0, 25)
        pLabel.Position = UDim2.new(0, 10, 0, 42)
        pLabel.BackgroundTransparency = 1
        pLabel.Text = string.format("🪙 Precio: %d monedas", t.Price)
        pLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
        pLabel.Font = Enum.Font.SourceSansBold
        pLabel.TextSize = 15
        pLabel.Parent = card

        local actionBtn = Instance.new("TextButton")
        actionBtn.Size = UDim2.new(1, -24, 0, 42)
        actionBtn.Position = UDim2.new(0, 12, 1, -52)
        actionBtn.Font = Enum.Font.FredokaOne
        actionBtn.TextSize = 16
        actionBtn.AutoButtonColor = true
        actionBtn.Parent = card

        local abCorner = Instance.new("UICorner")
        abCorner.CornerRadius = UDim.new(0, 8)
        abCorner.Parent = actionBtn

        if not owns(t.Id) then
            actionBtn.Text = string.format("Comprar (%d 🪙)", t.Price)
            actionBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 90)
            actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            actionBtn.MouseButton1Click:Connect(function()
                BuyTrail:FireServer(t.Id)
            end)
        elseif equipped == t.Id then
            actionBtn.Text = "✅ Equipado (Quitar)"
            actionBtn.BackgroundColor3 = Color3.fromRGB(60, 160, 240)
            actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            actionBtn.MouseButton1Click:Connect(function()
                EquipTrail:FireServer("None")
            end)
        else
            actionBtn.Text = "Equipar"
            actionBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 230)
            actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            actionBtn.MouseButton1Click:Connect(function()
                EquipTrail:FireServer(t.Id)
            end)
        end
    end
end

localPlayer:GetAttributeChangedSignal("OwnedTrails"):Connect(renderTrails)
localPlayer:GetAttributeChangedSignal("EquippedTrail"):Connect(renderTrails)
renderTrails()

print("[StoreGui] Tienda multi-pestaña cargada correctamente.")
