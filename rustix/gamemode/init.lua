AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("config.lua")
include("config.lua")
include("shared.lua")
for k, v in pairs(file.Find("sound/laced/*", "GAME")) do
    resource.AddFile("sound/laced/" .. v)
end

--[[
Fixed serverside lag crafting
Fixed bugs and exploits

]]
util.AddNetworkString("gRust_ServerModel_new")
util.AddNetworkString("gRust_ServerModel")
util.AddNetworkString("Rust_TableValid")
local valid = {
    ["sent_foundation"] = true
}

net.Receive("gRust_ServerModel_new", function(len, ply)
    local msg = net.ReadString()
    if msg == "Wood" then
        local eye_t_e = ply:GetEyeTrace().Entity
        if not valid[eye_t_e:GetClass()] then return end
        local ent = eye_t_e
        ent:SetModel("models/building_re/wood_foundation.mdl")
        ent:SetMaxHealth(250)
        ent:SetHealth(250)
        //ent:Remove()
        ply:EmitSound("zohart/building/hammer-saw-" .. math.random(1, 3) .. ".wav")
    end
end)

hook.Add("PlayerSpawn", "PlayerModelSelector", function(ply)
    if IsValid(ply) then
        ply:SetModel("models/player/spike/rustguy_grust.mdl")
        local rnd = math.random(1, 3)
        ply:SetSkin(rnd)
        ply:SetBodygroup(3, 1)
        if Rust.KeepInventory == false then ply.Inventory = {} end
    end
end)

hook.Add("PlayerNoClip", "noclip", function(ply) return ply:IsAdmin() end)