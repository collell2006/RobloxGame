-- HUD.client.lua – Interfaz de usuario principal (Monedas, Nivel y Botones de acción)
-- Colócalo en StarterGui (se ejecuta como LocalScript en cada cliente)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local ResetToCheckpoint = RemoteEvents:WaitForChild("ResetToCheckpoint")

-- Crear ScreenGui principal del HUD
local hudGui = Instance.new("ScreenGui")
hudGui.Name = "MainHUD"
hudGui.ResetOnSpawn = false
hudGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
hudGui.Parent = playerGui

-- =========================================================
-- 1. CONTADOR DE MONEDAS Y NIVEL (Top Left)
-- =========================================================
local statsFrame = Instance.new("Frame")
statsFrame.Name = "StatsFrame"
statsFrame.Size = UDim2.new(0, 220, 0, 75)
statsFrame.Position = UDim2.new(0, 15, 0, 15)
statsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
statsFrame.BackgroundTransparency = 0.2
statsFrame.BorderSizePixel = 0
statsFrame.Parent = hudGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = statsFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 60, 75)
stroke.Thickness = 2
stroke.Parent = statsFrame

-- Label de Monedas
local coinLabel = Instance.new("TextLabel")
coinLabel.Name = "CoinLabel"
coinLabel.Size = UDim2.new(1, -20, 0, 30)
coinLabel.Position = UDim2.new(0, 10, 0, 8)
coinLabel.BackgroundTransparency = 1
coinLabel.TextColor3 = Color3.fromRGB(255, 220, 50)
coinLabel.Font = Enum.Font.FredokaOne
coinLabel.TextSize = 20
coinLabel.TextXAlignment = Enum.TextXAlignment.Left
coinLabel.Text = "🪙 Monedas: 0"
coinLabel.Parent = statsFrame

-- Label de Nivel
local stageLabel = Instance.new("TextLabel")
stageLabel.Name = "StageLabel"
stageLabel.Size = UDim2.new(1, -20, 0, 25)
stageLabel.Position = UDim2.new(0, 10, 0, 38)
stageLabel.BackgroundTransparency = 1
stageLabel.TextColor3 = Color3.fromRGB(80, 220, 140)
stageLabel.Font = Enum.Font.FredokaOne
stageLabel.TextSize = 18
stageLabel.TextXAlignment = Enum.TextXAlignment.Left
stageLabel.Text = "🚩 Nivel: 1 / 5"
stageLabel.Parent = statsFrame

-- =========================================================
-- 2. BOTONES LATERALES (Tienda y Reset)
-- =========================================================
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Name = "ButtonsFrame"
buttonsFrame.Size = UDim2.new(0, 140, 0, 110)
buttonsFrame.Position = UDim2.new(0, 15, 0.5, -55)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = hudGui

local function createActionButton(name, text, bgColor, pos)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.Position = pos
    btn.BackgroundColor3 = bgColor
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.FredokaOne
    btn.TextSize = 18
    btn.Text = text
    btn.AutoButtonColor = true
    btn.Parent = buttonsFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(255, 255, 255)
    btnStroke.Transparency = 0.6
    btnStroke.Thickness = 1.5
    btnStroke.Parent = btn

    return btn
end

local shopBtn = createActionButton("ShopButton", "🛒 TIENDA", Color3.fromRGB(240, 140, 20), UDim2.new(0, 0, 0, 0))
local resetBtn = createActionButton("ResetButton", "🔄 REINICIAR", Color3.fromRGB(50, 150, 230), UDim2.new(0, 0, 0, 55))

-- Evento Botón Reset
resetBtn.MouseButton1Click:Connect(function()
    ResetToCheckpoint:FireServer()
end)

-- Evento Botón Tienda (Abrir ventana de tienda)
shopBtn.MouseButton1Click:Connect(function()
    local storeGui = playerGui:FindFirstChild("StoreGui")
    if storeGui then
        local mainFrame = storeGui:FindFirstChild("MainFrame")
        if mainFrame then
            mainFrame.Visible = not mainFrame.Visible
        end
    end
end)

-- =========================================================
-- 3. SINCRONIZACIÓN REACTIVA DE DATOS
-- =========================================================
local function updateUI()
    local coins = localPlayer:GetAttribute("Coins") or 0
    local stage = localPlayer:GetAttribute("Stage") or 1
    local isVip = localPlayer:GetAttribute("VIP")

    local vipTag = isVip and " [VIP]" or ""
    coinLabel.Text = string.format("🪙 Monedas: %d%s", coins, vipTag)
    stageLabel.Text = string.format("🚩 Nivel: %d / 5", stage)
end

localPlayer:GetAttributeChangedSignal("Coins"):Connect(updateUI)
localPlayer:GetAttributeChangedSignal("Stage"):Connect(updateUI)
localPlayer:GetAttributeChangedSignal("VIP"):Connect(updateUI)

updateUI()
print("[HUD] Interfaz gráfica cargada correctamente.")
