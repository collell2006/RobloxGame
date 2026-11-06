-- ObbySetup.lua – Genera un circuito de obstáculos (Obby) completo con obstáculos y lava
-- Colócalo en ServerScriptService/Core

local Workspace = game:GetService("Workspace")

local ObbySetup = {}

function ObbySetup.buildObby()
    -- Limpiar si ya existe para evitar duplicados
    local existing = Workspace:FindFirstChild("Obby")
    if existing then
        existing:Destroy()
    end

    local obbyFolder = Instance.new("Folder")
    -- Obby Folder
    obbyFolder.Name = "Obby"
    obbyFolder.Parent = Workspace

    local checkpointsFolder = Instance.new("Folder")
    checkpointsFolder.Name = "Checkpoints"
    checkpointsFolder.Parent = obbyFolder

    local platformsFolder = Instance.new("Folder")
    platformsFolder.Name = "Platforms"
    platformsFolder.Parent = obbyFolder

    -- =========================================================
    -- 1. PISO DE LAVA (Kill Floor)
    -- =========================================================
    local killFloor = Instance.new("Part")
    killFloor.Name = "KillFloor"
    killFloor.Size = Vector3.new(1000, 4, 1000)
    killFloor.Position = Vector3.new(0, -10, 200)
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

    -- Función auxiliar para crear checkpoints
    local function createCheckpoint(stageNumber, position)
        local pad = Instance.new("Part")
        pad.Name = "Checkpoint_" .. tostring(stageNumber)
        pad.Size = Vector3.new(10, 1.5, 10)
        pad.Position = position
        pad.Anchored = true
        pad.Material = Enum.Material.SmoothPlastic
        pad.Color = Color3.fromRGB(0, 200, 80)
        pad:SetAttribute("StageNumber", stageNumber)
        pad.Parent = checkpointsFolder

        -- Letrero indicador de nivel
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = pad

        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = "NIVEL " .. tostring(stageNumber)
        text.TextColor3 = Color3.fromRGB(255, 255, 255)
        text.TextStrokeTransparency = 0
        text.Font = Enum.Font.SourceSansBold
        text.TextSize = 22
        text.Parent = billboard

        return pad
    end

    -- =========================================================
    -- ETAPA 1: Inicio y saltos básicos
    -- =========================================================
    local startPos = Vector3.new(0, 5, 0)
    local cp1 = createCheckpoint(1, startPos)

    -- SpawnLocation en checkpoint 1
    local spawnLoc = Instance.new("SpawnLocation")
    spawnLoc.Name = "StartSpawn"
    spawnLoc.Size = Vector3.new(6, 1, 6)
    spawnLoc.Position = startPos + Vector3.new(0, 1, 0)
    spawnLoc.Anchored = true
    spawnLoc.CanCollide = false
    spawnLoc.Transparency = 1
    spawnLoc.Duration = 0
    spawnLoc.Parent = obbyFolder

    -- Plataformas etapa 1
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

    -- =========================================================
    -- ETAPA 2: Plataformas cilíndricas (Stepping Stones)
    -- =========================================================
    local cp2Pos = Vector3.new(0, 6, zOffset)
    createCheckpoint(2, cp2Pos)
    zOffset = zOffset + 15

    for i = 1, 5 do
        local cyl = Instance.new("Part")
        cyl.Name = "Stage2_Cylinder_" .. i
        cyl.Shape = Enum.PartType.Cylinder
        cyl.Size = Vector3.new(2, 6, 6)
        cyl.Orientation = Vector3.new(0, 0, 90)
        cyl.Position = Vector3.new(math.sin(i * 1.2) * 8, 6 + (i * 0.8), zOffset)
        cyl.Anchored = true
        cyl.Material = Enum.Material.WoodPlanks
        cyl.Color = Color3.fromRGB(180, 120, 70)
        cyl.Parent = platformsFolder
        zOffset = zOffset + 14
    end

    -- =========================================================
    -- ETAPA 3: Plataformas que desaparecen (Fading Blocks)
    -- =========================================================
    local cp3Pos = Vector3.new(0, 11, zOffset)
    createCheckpoint(3, cp3Pos)
    zOffset = zOffset + 16

    for i = 1, 4 do
        local fadePart = Instance.new("Part")
        fadePart.Name = "Stage3_FadingPlatform_" .. i
        fadePart.Size = Vector3.new(7, 2, 7)
        fadePart.Position = Vector3.new(0, 11, zOffset)
        fadePart.Anchored = true
        fadePart.Material = Enum.Material.Neon
        fadePart.Color = Color3.fromRGB(0, 180, 255)
        fadePart.Parent = platformsFolder

        -- Lógica de desvanecimiento al pisar
        local isFading = false
        fadePart.Touched:Connect(function(hit)
            local char = hit.Parent
            if char and char:FindFirstChildOfClass("Humanoid") and not isFading then
                isFading = true
                task.wait(0.4)
                for transparency = 0, 1, 0.2 do
                    fadePart.Transparency = transparency
                    task.wait(0.05)
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
    -- ETAPA 4: Rayos Láser / Barras de Lava
    -- =========================================================
    local cp4Pos = Vector3.new(0, 12, zOffset)
    createCheckpoint(4, cp4Pos)
    zOffset = zOffset + 16

    for i = 1, 4 do
        local bridge = Instance.new("Part")
        bridge.Name = "Stage4_Bridge_" .. i
        bridge.Size = Vector3.new(6, 2, 14)
        bridge.Position = Vector3.new(0, 12, zOffset)
        bridge.Anchored = true
        bridge.Material = Enum.Material.DiamondPlate
        bridge.Color = Color3.fromRGB(80, 80, 85)
        bridge.Parent = platformsFolder

        -- Láser en el medio
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
    -- ETAPA 5: Isla de Victoria (Meta Final)
    -- =========================================================
    local cp5Pos = Vector3.new(0, 13, zOffset)
    local winPad = createCheckpoint(5, cp5Pos)
    winPad.Size = Vector3.new(20, 2, 20)
    winPad.Color = Color3.fromRGB(255, 215, 0)
    winPad.Material = Enum.Material.Neon

    -- Trofeo en el centro
    local trophy = Instance.new("Part")
    trophy.Name = "VictoryTrophy"
    trophy.Size = Vector3.new(4, 8, 4)
    trophy.Position = cp5Pos + Vector3.new(0, 5, 0)
    trophy.Anchored = true
    trophy.CanCollide = false
    trophy.Material = Enum.Material.Neon
    trophy.Color = Color3.fromRGB(255, 220, 50)
    trophy.Parent = obbyFolder

    print("[ObbySetup] Obby con 5 niveles y piso de lava generado con éxito.")
    return checkpointsFolder
end

return ObbySetup
