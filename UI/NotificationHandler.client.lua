-- NotificationHandler.client.lua – Banners de notificación animados en pantalla
-- Colócalo en StarterGui (se ejecuta como LocalScript en cada cliente)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local Notify = RemoteEvents:WaitForChild("Notify")

local notifGui = Instance.new("ScreenGui")
notifGui.Name = "NotificationGui"
notifGui.ResetOnSpawn = false
notifGui.Parent = playerGui

local function showBanner(message, notifType)
    local banner = Instance.new("Frame")
    banner.Name = "ToastBanner"
    banner.Size = UDim2.new(0, 360, 0, 50)
    -- Inicia fuera de la pantalla (arriba)
    banner.Position = UDim2.new(0.5, -180, 0, -60)
    banner.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
    banner.BorderSizePixel = 0
    banner.Parent = notifGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = banner

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Parent = banner

    if notifType == "Success" then
        stroke.Color = Color3.fromRGB(50, 220, 120)
    elseif notifType == "Error" then
        stroke.Color = Color3.fromRGB(230, 60, 60)
    else
        stroke.Color = Color3.fromRGB(50, 160, 240)
    end

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 1, 0)
    textLabel.Position = UDim2.new(0, 10, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = message
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.FredokaOne
    textLabel.TextSize = 16
    textLabel.TextWrapped = true
    textLabel.Parent = banner

    -- Animación de entrada hacia abajo
    local tweenIn = TweenService:Create(
        banner,
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, -180, 0, 20)}
    )
    tweenIn:Play()

    -- Esperar 3.5 segundos y desvanecer
    task.delay(3.5, function()
        if banner and banner.Parent then
            local tweenOut = TweenService:Create(
                banner,
                TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {Position = UDim2.new(0.5, -180, 0, -70)}
            )
            tweenOut:Play()
            tweenOut.Completed:Connect(function()
                banner:Destroy()
            end)
        end
    end)
end

Notify.OnClientEvent:Connect(function(payload)
    local msg = (type(payload) == "table" and payload.text) or tostring(payload)
    local typ = (type(payload) == "table" and payload.type) or "Info"
    showBanner(msg, typ)
end)

print("[NotificationHandler] Sistema de avisos emergentes listo.")
