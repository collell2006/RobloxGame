-- StoreGui.client.lua – Ventana emergente interactiva de Tienda
-- Colócalo en StarterGui (se ejecuta como LocalScript en cada cliente)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local BuyGamePass = RemoteEvents:WaitForChild("BuyGamePass")
local BuyProduct = RemoteEvents:WaitForChild("BuyProduct")

-- ScreenGui
local storeGui = Instance.new("ScreenGui")
storeGui.Name = "StoreGui"
storeGui.ResetOnSpawn = false
storeGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
storeGui.Parent = playerGui

-- Marco Principal (Modal)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 540, 0, 360)
mainFrame.Position = UDim2.new(0.5, -270, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false -- Oculto por defecto
mainFrame.Parent = storeGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 14)
frameCorner.Parent = mainFrame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(240, 150, 40)
frameStroke.Thickness = 2.5
frameStroke.Parent = mainFrame

-- Título
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -60, 0, 50)
title.Position = UDim2.new(0, 20, 0, 10)
title.BackgroundTransparency = 1
title.Text = "🛒 TIENDA DE MEJORAS"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.FredokaOne
title.TextSize = 24
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

-- Botón Cerrar (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -46, 0, 14)
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

-- Contenedor de Tarjetas de Productos
local cardsContainer = Instance.new("Frame")
cardsContainer.Name = "CardsContainer"
cardsContainer.Size = UDim2.new(1, -40, 1, -80)
cardsContainer.Position = UDim2.new(0, 20, 0, 65)
cardsContainer.BackgroundTransparency = 1
cardsContainer.Parent = mainFrame

-- Función para construir tarjeta de producto
local function createProductCard(titleText, descText, priceText, btnColor, xOffset, onBuy)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.48, 0, 1, 0)
    card.Position = UDim2.new(xOffset, 0, 0, 0)
    card.BackgroundColor3 = Color3.fromRGB(42, 45, 56)
    card.BorderSizePixel = 0
    card.Parent = cardsContainer

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 10)
    cardCorner.Parent = card

    -- Título del ítem
    local itemTitle = Instance.new("TextLabel")
    itemTitle.Size = UDim2.new(1, -20, 0, 35)
    itemTitle.Position = UDim2.new(0, 10, 0, 10)
    itemTitle.BackgroundTransparency = 1
    itemTitle.Text = titleText
    itemTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
    itemTitle.Font = Enum.Font.FredokaOne
    itemTitle.TextSize = 18
    itemTitle.Parent = card

    -- Descripción
    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -20, 0, 110)
    desc.Position = UDim2.new(0, 10, 0, 45)
    desc.BackgroundTransparency = 1
    desc.Text = descText
    desc.TextColor3 = Color3.fromRGB(200, 205, 215)
    desc.Font = Enum.Font.SourceSans
    desc.TextSize = 16
    desc.TextWrapped = true
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.Parent = card

    -- Botón de Compra
    local buyButton = Instance.new("TextButton")
    buyButton.Size = UDim2.new(1, -24, 0, 42)
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

-- Tarjeta 1: Pase VIP (Game Pass)
createProductCard(
    "👑 PASE VIP",
    "• Multiplicador x2 permanente en monedas.\n• +1,000 Monedas inmediatas.\n• Distintivo VIP en pantalla.",
    "Comprar VIP",
    Color3.fromRGB(230, 130, 20),
    0,
    function()
        BuyGamePass:FireServer()
    end
)

-- Tarjeta 2: Pack Monedas (Developer Product)
createProductCard(
    "💰 PACK 500 COINS",
    "• Recibe +500 Monedas de inmediato.\n• ¡Puedes comprarlo todas las veces que quieras!",
    "Comprar Pack",
    Color3.fromRGB(40, 175, 90),
    0.52,
    function()
        BuyProduct:FireServer()
    end
)

print("[StoreGui] Interfaz de tienda lista.")
