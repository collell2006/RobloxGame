-- ObbySetup.lua – Genera un circuito de obstáculos avanzado con trampolines, boosters y portal de renacimiento
-- Colócalo en ServerScriptService/Core

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local ObbySetup = {}

function ObbySetup.buildObby()
    local existing = Workspace:FindFirstChild("Obby")
    if existing then
        existing:Destroy()
    end

    local obbyFolder = Instance.new("Folder")
    obbyFolder.Name = "Obby"
    obbyFolder.Parent = Workspace

    local checkpointsFolder = Instance.new("Folder")
    checkpointsFolder.Name = "Checkpoints"
    checkpointsFolder.Parent = obbyFolder

    local platformsFolder = Instance.new("Folder")
    platformsFolder.Name = "Platforms"
    platformsFolder.Parent = obbyFolder

    local interactiveFolder = Instance.new("Folder")
    interactiveFolder.Name = "Interactives"
    interactiveFolder.Parent = obbyFolder

    -- =========================================================
    -- 1. PISO DE LAVA (Kill Floor)
    -- =========================================================
    local killFloor = Instance.new("Part")
    killFloor.Name = "KillFloor"
    killFloor.Size = Vector3.new(1200, 4, 1200)
    killFloor.Position = Vector3.new(0, -10, 250)
    killFloor.Anchored = true
    killFloor.CanCollide = true
    killFloor.Material = Enum.Material.Neon
    killFloor.Color = Color3.fromRGB(255, 30, 30)
    killFloor.Parent = obbyFolder

    killFloor.Touched:Connect(function(hit)
        local character = hit.Parent
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            humanoid.Health = 0
        end
    end)

    -- =========================================================
    -- FUNCIONES AUXILIARES: Checkpoints, JumpPads y SpeedBoosters
    -- =========================================================
    local function createCheckpoint(stageNumber, position)
        local pad = Instance.new("Part")
        pad.Name = "Checkpoint_" .. tostring(stageNumber)
        pad.Size = Vector3.new(12, 1.5, 12)
        pad.Position = position
        pad.Anchored = true
        pad.Material = Enum.Material.SmoothPlastic
        pad.Color = Color3.fromRGB(0, 200, 80)
        pad:SetAttribute("StageNumber", stageNumber)
        pad.Parent = checkpointsFolder

        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 120, 0, 45)
        billboard.StudsOffset = Vector3.new(0, 3.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = pad

        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = "NIVEL " .. tostring(stageNumber)
        text.TextColor3 = Color3.fromRGB(255, 255, 255)
        text.TextStrokeTransparency = 0
        text.Font = Enum.Font.FredokaOne
        text.TextSize = 22
        text.Parent = billboard

        return pad
    end

    -- Trampolín / Salto Propulsado (Jump Pad)
    local function createJumpPad(position, forwardVelocity, upVelocity)
        local pad = Instance.new("Part")
        pad.Name = "JumpPad"
        pad.Size = Vector3.new(6, 1, 6)
        pad.Position = position
        pad.Anchored = true
        pad.Material = Enum.Material.Neon
        pad.Color = Color3.fromRGB(50, 255, 120)
        pad.Parent = interactiveFolder

        local arrow = Instance.new("BillboardGui")
        arrow.Size = UDim2.new(0, 50, 0, 50)
        arrow.StudsOffset = Vector3.new(0, 1.5, 0)
        arrow.AlwaysOnTop = true
        arrow.Parent = pad

        local icon = Instance.new("TextLabel")
        icon.Size = UDim2.new(1, 0, 1, 0)
        icon.BackgroundTransparency = 1
        icon.Text = "⬆️"
        icon.TextSize = 26
        icon.Parent = arrow

        local debounce = false
        pad.Touched:Connect(function(hit)
            local char = hit.Parent
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root and not debounce then
                debounce = true
                root.AssemblyLinearVelocity = Vector3.new(0, upVelocity or 65, forwardVelocity or 20)
                task.wait(0.5)
                debounce = false
            end
        end)
        return pad
    end

    -- Cinta de Aceleración (Speed Booster)
    local function createSpeedBooster(position)
        local pad = Instance.new("Part")
        pad.Name = "SpeedBooster"
        pad.Size = Vector3.new(6, 0.8, 12)
        pad.Position = position
        pad.Anchored = true
        pad.Material = Enum.Material.Neon
        pad.Color = Color3.fromRGB(255, 160, 20)
        pad.Parent = interactiveFolder

        pad.Touched:Connect(function(hit)
            local char = hit.Parent
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed <= 16 then
                hum.WalkSpeed = 32
                task.delay(3, function()
                    if hum and hum.Parent then
                        hum.WalkSpeed = 16
                    end
                end)
            end
        end)
        return pad
    end

    -- =========================================================
    -- ETAPA 1: Saltos básicos y Speed Booster
    -- =========================================================
    local startPos = Vector3.new(0, 5, 0)
    createCheckpoint(1, startPos)

    local spawnLoc = Instance.new("SpawnLocation")
    spawnLoc.Name = "StartSpawn"
    spawnLoc.Size = Vector3.new(6, 1, 6)
    spawnLoc.Position = startPos + Vector3.new(0, 1, 0)
    spawnLoc.Anchored = true
    spawnLoc.CanCollide = false
    spawnLoc.Transparency = 1
    spawnLoc.Duration = 0
    spawnLoc.Parent = obbyFolder

    local zOffset = startPos.Z + 15
    for i = 1, 4 do
        local p = Instance.new("Part")
        p.Name = "Stage1_Platform_" .. i
        p.Size = Vector3.new(8, 2, 8)
        p.Position = Vector3.new((i % 2 == 0) and 4 or -4, 5, zOffset)
        p.Anchored = true
        p.Material = Enum.Material.Slate
        p.Color = Color3.fromRGB(130, 140, 150)
        p.Parent = platformsFolder
        zOffset = zOffset + 14
    end

    createSpeedBooster(Vector3.new(0, 5, zOffset))
    zOffset = zOffset + 14

    -- =========================================================
    -- ETAPA 2: Cilindros con Jump Pad
    -- =========================================================
    createCheckpoint(2, Vector3.new(0, 6, zOffset))
    zOffset = zOffset + 16

    for i = 1, 4 do
        local cyl = Instance.new("Part")
        cyl.Name = "Stage2_Cylinder_" .. i
        cyl.Shape = Enum.PartType.Cylinder
        cyl.Size = Vector3.new(2, 6, 6)
        cyl.Orientation = Vector3.new(0, 0, 90)
        cyl.Position = Vector3.new(math.sin(i * 1.3) * 8, 6 + (i * 0.8), zOffset)
        cyl.Anchored = true
        cyl.Material = Enum.Material.WoodPlanks
        cyl.Color = Color3.fromRGB(180, 120, 70)
        cyl.Parent = platformsFolder
        zOffset = zOffset + 14
    end

    -- Trampolín hacia la siguiente etapa
    createJumpPad(Vector3.new(0, 9.5, zOffset), 28, 65)
    zOffset = zOffset + 24

    -- =========================================================
    -- ETAPA 3: Plataformas desvanecientes (Fading Blocks)
    -- =========================================================
    createCheckpoint(3, Vector3.new(0, 11, zOffset))
    zOffset = zOffset + 16

    for i = 1, 4 do
        local fadePart = Instance.new("Part")
        fadePart.Name = "Stage3_FadingPlatform_" .. i
        fadePart.Size = Vector3.new(7, 2, 7)
        fadePart.Position = Vector3.new((i % 2 == 0) and 3 or -3, 11, zOffset)
        fadePart.Anchored = true
        fadePart.Material = Enum.Material.Neon
        fadePart.Color = Color3.fromRGB(0, 180, 255)
        fadePart.Parent = platformsFolder

        local isFading = false
        fadePart.Touched:Connect(function(hit)
            local char = hit.Parent
            if char and char:FindFirstChildOfClass("Humanoid") and not isFading then
                isFading = true
                task.wait(0.35)
                for transparency = 0, 1, 0.2 do
                    fadePart.Transparency = transparency
                    task.wait(0.04)
                end
                fadePart.CanCollide = false
                task.wait(2)
                fadePart.CanCollide = true
                fadePart.Transparency = 0
                isFading = false
            end
        end)
        zOffset = zOffset + 16
    end

    -- =========================================================
    -- ETAPA 4: Rayos Láser y Trampolín Final
    -- =========================================================
    createCheckpoint(4, Vector3.new(0, 12, zOffset))
    zOffset = zOffset + 16

    for i = 1, 3 do
        local bridge = Instance.new("Part")
        bridge.Name = "Stage4_Bridge_" .. i
        bridge.Size = Vector3.new(6, 2, 14)
        bridge.Position = Vector3.new(0, 12, zOffset)
        bridge.Anchored = true
        bridge.Material = Enum.Material.DiamondPlate
        bridge.Color = Color3.fromRGB(80, 80, 85)
        bridge.Parent = platformsFolder

        local laser = Instance.new("Part")
        laser.Name = "Laser"
        laser.Size = Vector3.new(6.2, 1.2, 1.2)
        laser.Position = bridge.Position + Vector3.new(0, 1.6, 0)
        laser.Anchored = true
        laser.CanCollide = false
        laser.Material = Enum.Material.Neon
        laser.Color = Color3.fromRGB(255, 20, 20)
        laser.Parent = bridge

        laser.Touched:Connect(function(hit)
            local char = hit.Parent
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                hum.Health = 0
            end
        end)
        zOffset = zOffset + 18
    end

    -- =========================================================
    -- ETAPA 5: Isla de Victoria y Portal de Renacimiento
    -- =========================================================
    local cp5Pos = Vector3.new(0, 13, zOffset)
    local winPad = createCheckpoint(5, cp5Pos)
    winPad.Size = Vector3.new(24, 2, 24)
    winPad.Color = Color3.fromRGB(255, 215, 0)
    winPad.Material = Enum.Material.Neon

    -- Trofeo Central
    local trophy = Instance.new("Part")
    trophy.Name = "VictoryTrophy"
    trophy.Size = Vector3.new(4, 8, 4)
    trophy.Position = cp5Pos + Vector3.new(0, 5, 0)
    trophy.Anchored = true
    trophy.CanCollide = false
    trophy.Material = Enum.Material.Neon
    trophy.Color = Color3.fromRGB(255, 220, 50)
    trophy.Parent = obbyFolder

    -- Emisor de Confetti de Victoria
    local confetti = Instance.new("ParticleEmitter")
    confetti.Name = "VictoryConfetti"
    confetti.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 150)),
    })
    confetti.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.6),
        NumberSequenceKeypoint.new(1, 0.4),
    })
    confetti.Speed = NumberRange.new(10, 20)
    confetti.Lifetime = NumberRange.new(2, 3)
    confetti.Rate = 25
    confetti.Parent = trophy

    -- Portal de Renacimiento Físico
    local rebirthPortal = Instance.new("Part")
    rebirthPortal.Name = "RebirthPortalPad"
    rebirthPortal.Size = Vector3.new(8, 1, 8)
    rebirthPortal.Position = cp5Pos + Vector3.new(0, 1.2, 7)
    rebirthPortal.Anchored = true
    rebirthPortal.Material = Enum.Material.Neon
    rebirthPortal.Color = Color3.fromRGB(180, 0, 255)
    rebirthPortal.Parent = obbyFolder

    local pBillboard = Instance.new("BillboardGui")
    pBillboard.Size = UDim2.new(0, 140, 0, 40)
    pBillboard.StudsOffset = Vector3.new(0, 2.5, 0)
    pBillboard.AlwaysOnTop = true
    pBillboard.Parent = rebirthPortal

    local pLabel = Instance.new("TextLabel")
    pLabel.Size = UDim2.new(1, 0, 1, 0)
    pLabel.BackgroundTransparency = 1
    pLabel.Text = "🌀 PISA PARA RENACER"
    pLabel.TextColor3 = Color3.fromRGB(230, 150, 255)
    pLabel.Font = Enum.Font.FredokaOne
    pLabel.TextSize = 16
    pLabel.Parent = pBillboard

    -- Detección de contacto con el portal de renacimiento
    local debounce = false
    rebirthPortal.Touched:Connect(function(hit)
        local character = hit.Parent
        local player = Players:GetPlayerFromCharacter(character)
        if player and not debounce then
            debounce = true
            local RebirthManager = require(script.Parent:WaitForChild("RebirthManager"))
            RebirthManager.ProcessRebirth(player)
            task.wait(2)
            debounce = false
        end
    end)

    print("[ObbySetup] Circuito avanzado con trampolines, boosters y portal de renacimiento generado.")
    return checkpointsFolder
end

return ObbySetup
