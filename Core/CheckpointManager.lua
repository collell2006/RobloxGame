-- CheckpointManager.lua – Gestión de checkpoints, respawn y teletransporte
-- Colócalo en ServerScriptService/Core

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local Notify = RemoteEvents:WaitForChild("Notify")
local ResetToCheckpoint = RemoteEvents:WaitForChild("ResetToCheckpoint")

local CheckpointsFolder = nil

local function getCheckpointsFolder()
    if not CheckpointsFolder then
        local obby = Workspace:WaitForChild("Obby", 10)
        if obby then
            CheckpointsFolder = obby:WaitForChild("Checkpoints", 10)
        end
    end
    return CheckpointsFolder
end

-- Teletransportar al checkpoint correspondiente
local function teleportToCheckpoint(player, character)
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not rootPart or not humanoid or humanoid.Health <= 0 then return end

    local currentStage = player:GetAttribute("Stage") or 1
    local folder = getCheckpointsFolder()
    if not folder then return end

    local targetPad = folder:FindFirstChild("Checkpoint_" .. tostring(currentStage))
    if not targetPad then
        targetPad = folder:FindFirstChild("Checkpoint_1")
    end

    if targetPad and rootPart then
        task.wait(0.1)
        rootPart.CFrame = targetPad.CFrame + Vector3.new(0, 3.5, 0)
    end
end

-- Vincular personaje al checkpoint al reaparecer
local function onCharacterAdded(player, character)
    teleportToCheckpoint(player, character)
end

-- Manejo al tocar un checkpoint
local function setupCheckpointPad(pad, stageNumber)
    pad.Touched:Connect(function(hit)
        local character = hit.Parent
        local player = Players:GetPlayerFromCharacter(character)
        if not player then return end

        local currentStage = player:GetAttribute("Stage") or 1
        if stageNumber > currentStage then
            player:SetAttribute("Stage", stageNumber)

            -- Recompensa por avanzar de nivel (+15 monedas)
            local currentCoins = player:GetAttribute("Coins") or 0
            player:SetAttribute("Coins", currentCoins + 15)

            -- Notificación
            Notify:FireClient(player, {
                text = string.format("¡Nivel %d alcanzado! +15 Monedas", stageNumber),
                type = "Success"
            })

            -- Efecto visual temporal en el checkpoint
            pad.Material = Enum.Material.Neon
            pad.Color = Color3.fromRGB(0, 255, 100)
            task.delay(1, function()
                if pad then
                    pad.Material = Enum.Material.Plastic
                    pad.Color = Color3.fromRGB(0, 200, 80)
                end
            end)
        end
    end)
end

local function init(checkpointsFolder)
    CheckpointsFolder = checkpointsFolder

    for _, pad in ipairs(checkpointsFolder:GetChildren()) do
        local stageNum = pad:GetAttribute("StageNumber")
        if stageNum then
            setupCheckpointPad(pad, stageNum)
        end
    end

    -- Escuchar a los jugadores
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(char)
            onCharacterAdded(player, char)
        end)
    end)

    -- Para jugadores que ya estén en la partida
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            onCharacterAdded(player, player.Character)
        end
        player.CharacterAdded:Connect(function(char)
            onCharacterAdded(player, char)
        end)
    end

    -- Evento para teletransportar voluntariamente desde el botón de la UI
    ResetToCheckpoint.OnServerEvent:Connect(function(player)
        if player.Character then
            teleportToCheckpoint(player, player.Character)
        end
    end)

    print("[CheckpointManager] Sistema de Checkpoints y Respawn inicializado.")
end

local CheckpointManager = {}
CheckpointManager.Init = init
CheckpointManager.TeleportToCheckpoint = teleportToCheckpoint
return CheckpointManager
