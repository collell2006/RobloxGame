-- RebirthManager.lua – Sistema de Renacimientos (Rebirths / Prestigio) y multiplicadores
-- Colócalo en ServerScriptService/Core

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local RequestRebirth = RemoteEvents:WaitForChild("RequestRebirth")
local Notify = RemoteEvents:WaitForChild("Notify")

local RebirthManager = {}

local FINAL_STAGE = 5

-- Calcular multiplicador total del jugador (Rebirths + VIP)
function RebirthManager.GetPlayerMultiplier(player)
    local rebirths = player:GetAttribute("Rebirths") or 0
    -- Cada renacimiento añade +50% (+0.5x) al multiplicador base
    local rebirthMultiplier = 1 + (rebirths * 0.5)

    -- Si tiene el Game Pass VIP, duplica el total
    if player:GetAttribute("VIP") then
        rebirthMultiplier = rebirthMultiplier * 2
    end

    return rebirthMultiplier
end

-- Procesar renacimiento
function RebirthManager.ProcessRebirth(player)
    local currentStage = player:GetAttribute("Stage") or 1

    if currentStage < FINAL_STAGE then
        Notify:FireClient(player, {
            text = string.format("¡Debes completar el Nivel %d para poder Renacer!", FINAL_STAGE),
            type = "Error"
        })
        return false
    end

    -- Incrementar renacimientos
    local currentRebirths = player:GetAttribute("Rebirths") or 0
    local newRebirths = currentRebirths + 1
    player:SetAttribute("Rebirths", newRebirths)

    -- Recompensas de Renacimiento: Bonificación de 100 monedas de bienvenida
    local coins = player:GetAttribute("Coins") or 0
    player:SetAttribute("Coins", coins + 100)

    -- Reiniciar nivel a 1
    player:SetAttribute("Stage", 1)

    -- Teletransportar al inicio
    local obby = Workspace:FindFirstChild("Obby")
    if obby and obby:FindFirstChild("Checkpoints") then
        local cp1 = obby.Checkpoints:FindFirstChild("Checkpoint_1")
        if cp1 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = cp1.CFrame + Vector3.new(0, 3.5, 0)
        end
    end

    local multText = string.format("%.1fx", RebirthManager.GetPlayerMultiplier(player))
    Notify:FireClient(player, {
        text = string.format("🎉 ¡RENACIMIENTO #%d COMPLETADO! Multiplicador actual: %s (+100 Monedas)", newRebirths, multText),
        type = "Success"
    })

    print(string.format("[Rebirth] %s ha alcanzado el Renacimiento #%d.", player.Name, newRebirths))
    return true
end

function RebirthManager.Init()
    RequestRebirth.OnServerEvent:Connect(function(player)
        RebirthManager.ProcessRebirth(player)
    end)
    print("[RebirthManager] Sistema de Renacimientos activo.")
end

return RebirthManager
