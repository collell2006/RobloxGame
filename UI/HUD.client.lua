-- HUD.client.lua – Interfaz de usuario principal mejorada (Monedas, Nivel, Renacer y Multiplicador)
-- Colócalo en StarterGui (se ejecuta como LocalScript en cada cliente)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local ResetToCheckpoint = RemoteEvents:WaitForChild("ResetToCheckpoint")
local RequestRebirth = RemoteEvents:WaitForChild("RequestRebirth")

-- Crear ScreenGui principal del HUD
local hudGui = Instance.new("ScreenGui")
hudGui.Name = "MainHUD"
hudGui.ResetOnSpawn = false
hudGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
hudGui.Parent = playerGui

-- =========================================================
-- 1. PANEL DE ESTADÍSTICAS (Top Left)
-- =========================================================
local statsFrame = Instance.new("Frame")
statsFrame.Name = "StatsFrame"
statsFrame.Size = UDim2.new(0, 240, 0, 105)
statsFrame.Position = UDim2.new(0, 15, 0, 15)
statsFrame.BackgroundColor3 = Color3.fromRGB(24, 26, 34)
statsFrame.BackgroundTransparency = 0.15
statsFrame.BorderSizePixel = 0
statsFrame.Parent = hudGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = statsFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(70, 75, 95)
stroke.Thickness = 2
stroke.Parent = statsFrame

-- Label de Monedas
local coinLabel = Instance.new("TextLabel")
coinLabel.Name = "CoinLabel"
coinLabel.Size = UDim2.new(1, -20, 0, 26)
coinLabel.Position = UDim2.new(0, 12, 0, 8)
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
stageLabel.Size = UDim2.new(1, -20, 0, 24)
stageLabel.Position = UDim2.new(0, 12, 0, 36)
stageLabel.BackgroundTransparency = 1
stageLabel.TextColor3 = Color3.fromRGB(80, 220, 140)
stageLabel.Font = Enum.Font.FredokaOne
stageLabel.TextSize = 17
stageLabel.TextXAlignment = Enum.TextXAlignment.Left
stageLabel.Text = "🚩 Nivel: 1 / 5"
stageLabel.Parent = statsFrame

-- Label de Renacimientos y Multiplicador
local rebirthLabel = Instance.new("TextLabel")
rebirthLabel.Name = "RebirthLabel"
rebirthLabel.Size = UDim2.new(1, -20, 0, 22)
rebirthLabel.Position = UDim2.new(0, 12, 0, 62)
rebirthLabel.BackgroundTransparency = 1
rebirthLabel.TextColor3 = Color3.fromRGB(200, 130, 255)
rebirthLabel.Font = Enum.Font.FredokaOne
rebirthLabel.TextSize = 15
rebirthLabel.TextXAlignment = Enum.TextXAlignment.Left
rebirthLabel.Text = "🔁 Renacer: 0 | ⚡ 1.0x"
rebirthLabel.Parent = statsFrame

-- Indicador de Estela Activa (pequeño pill abajo)
local trailBadge = Instance.new("TextLabel")
trailBadge.Name = "TrailBadge"
trailBadge.Size = UDim2.new(0, 240, 0, 24)
trailBadge.Position = UDim2.new(0, 15, 0, 125)
trailBadge.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
trailBadge.BackgroundTransparency = 0.3
trailBadge.TextColor3 = Color3.fromRGB(180, 200, 220)
trailBadge.Font = Enum.Font.SourceSansBold
trailBadge.TextSize = 14
trailBadge.Text = "✨ Estela: Ninguna"
trailBadge.Parent = hudGui

local tbCorner = Instance.new("UICorner")
tbCorner.CornerRadius = UDim.new(0, 6)
tbCorner.Parent = trailBadge

-- =========================================================
-- 2. BOTONES LATERALES DE ACCIÓN (Izquierda centro)
-- =========================================================
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Name = "ButtonsFrame"
buttonsFrame.Size = UDim2.new(0, 150, 0, 170)
buttonsFrame.Position = UDim2.new(0, 15, 0.5, -85)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = hudGui

local function createActionButton(name, text, bgColor, pos)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, 0, 0, 48)
    btn.Position = pos
    btn.BackgroundColor3 = bgColor
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.FredokaOne
    btn.TextSize = 17
    btn.Text = text
    btn.AutoButtonColor = true
    btn.Parent = buttonsFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(255, 255, 255)
    btnStroke.Transparency = 0.65
    btnStroke.Thickness = 1.5
    btnStroke.Parent = btn

    return btn
end

local shopBtn = createActionButton("ShopButton", "🛒 TIENDA", Color3.fromRGB(240, 140, 20), UDim2.new(0, 0, 0, 0))
local rebirthBtn = createActionButton("RebirthButton", "🌀 RENACER", Color3.fromRGB(160, 50, 230), UDim2.new(0, 0, 0, 56))
local resetBtn = createActionButton("ResetButton", "🔄 REINICIAR", Color3.fromRGB(50, 150, 230), UDim2.new(0, 0, 0, 112))

-- Eventos de botones
resetBtn.MouseButton1Click:Connect(function()
    ResetToCheckpoint:FireServer()
end)

rebirthBtn.MouseButton1Click:Connect(function()
    RequestRebirth:FireServer()
end)

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
-- 3. ACTUALIZACIÓN REACTIVA
-- =========================================================
local function updateUI()
    local coins = localPlayer:GetAttribute("Coins") or 0
    local stage = localPlayer:GetAttribute("Stage") or 1
    local rebirths = localPlayer:GetAttribute("Rebirths") or 0
    local isVip = localPlayer:GetAttribute("VIP")
    local trail = localPlayer:GetAttribute("EquippedTrail") or "None"

    -- Multiplicador
    local mult = 1 + (rebirths * 0.5)
    if isVip then
        mult = mult * 2
    end

    local vipTag = isVip and " [VIP]" or ""
    coinLabel.Text = string.format("🪙 Monedas: %d%s", coins, vipTag)
    stageLabel.Text = string.format("🚩 Nivel: %d / 5", stage)
    rebirthLabel.Text = string.format("🔁 Renacer: %d | ⚡ %.1fx", rebirths, mult)

    -- Trail name display
    local trailNames = {
        ["Rainbow"] = "Arcoíris Cósmico",
        ["Fire"] = "Fuego Volcánico",
        ["Cyber"] = "Ciber Neón",
        ["Golden"] = "Oro Divino",
    }
    local displayName = trailNames[trail] or "Ninguna"
    trailBadge.Text = "✨ Estela: " .. displayName

    -- Iluminar botón de Renacer si está en Nivel 5
    if stage >= 5 then
        rebirthBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 255)
        rebirthBtn.Text = "⭐ ¡RENACER!"
    else
        rebirthBtn.BackgroundColor3 = Color3.fromRGB(140, 60, 200)
        rebirthBtn.Text = "🌀 RENACER"
    end
end

localPlayer:GetAttributeChangedSignal("Coins"):Connect(updateUI)
localPlayer:GetAttributeChangedSignal("Stage"):Connect(updateUI)
localPlayer:GetAttributeChangedSignal("Rebirths"):Connect(updateUI)
localPlayer:GetAttributeChangedSignal("VIP"):Connect(updateUI)
localPlayer:GetAttributeChangedSignal("EquippedTrail"):Connect(updateUI)

updateUI()
print("[HUD] Interfaz gráfica reactiva avanzada cargada.")
