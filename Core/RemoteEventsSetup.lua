-- RemoteEventsSetup.lua – Crea carpeta y eventos en ReplicatedStorage
-- Colócalo en ServerScriptService/Core

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function initRemoteEvents()
    local eventsFolder = ReplicatedStorage:FindFirstChild("RemoteEvents")
    if not eventsFolder then
        eventsFolder = Instance.new("Folder")
        eventsFolder.Name = "RemoteEvents"
        eventsFolder.Parent = ReplicatedStorage
    end

    local function ensureEvent(name)
        local ev = eventsFolder:FindFirstChild(name)
        if not ev then
            ev = Instance.new("RemoteEvent")
            ev.Name = name
            ev.Parent = eventsFolder
        end
        return ev
    end

    ensureEvent("BuyGamePass")
    ensureEvent("BuyProduct")
    ensureEvent("Notify")
    ensureEvent("ResetToCheckpoint")
    ensureEvent("BuyTrail")
    ensureEvent("EquipTrail")
    ensureEvent("RequestRebirth")

    print("[RemoteEventsSetup] Todos los RemoteEvents creados con éxito.")
    return eventsFolder
end

initRemoteEvents()

return initRemoteEvents
