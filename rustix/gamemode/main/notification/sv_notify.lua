util.AddNetworkString("gRust.Notify")

local NotificationCooldowns = {}

local function SendNotification(player, text, notificationType, icon, side)
    if not IsValid(player) or not player:IsPlayer() then
        return
    end

    local steamID = player:SteamID64()
    local notifKey = steamID .. "_" .. text .. "_" .. notificationType .. "_" .. (side or "")
    local currentTime = CurTime()

    if NotificationCooldowns[notifKey] and (currentTime - NotificationCooldowns[notifKey]) < 0.5 then
        return
    end

    NotificationCooldowns[notifKey] = currentTime

    net.Start("gRust.Notify")
    net.WriteString(tostring(text or ""))
    net.WriteUInt(notificationType, 4)
    net.WriteString(tostring(icon or ""))
    net.WriteString(tostring(side or ""))
    net.Send(player)
end
local PLAYER = FindMetaTable("Player")
function PLAYER:SendNotification(text, notificationType, icon, side)
    SendNotification(self, text, notificationType, icon, side)
end