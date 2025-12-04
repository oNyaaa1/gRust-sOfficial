AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("config.lua")
include("config.lua")
include("shared.lua")
for k, v in pairs(file.Find("sound/laced/*", "GAME")) do
    resource.AddFile("sound/laced/" .. v)
end

--[[
Fixed not being able to slot on hotbar
Fixed not being able to drag from hotbar to entity nests
Fixed not being able to swap to hands and item of weapon
Added Daddy mode
Fixed and repaired Recycler [Still in works]
]]
util.AddNetworkString("gRust_ServerModel_new")
util.AddNetworkString("gRust_ServerModel")
util.AddNetworkString("Rust_TableValid")
local valid = {
    ["sent_foundation"] = {true, "models/building_re/wood_foundation.mdl"},
    ["sent_wall"] = {true, "models/building_re/wood_wall.mdl"},
    ["sent_ceiling"] = {true, "models/building_re/wood_floor.mdl"},
    ["sent_doorway"] = {true, "models/building_re/wood_dframe.mdl"}
}

local rotation = -90
net.Receive("gRust_ServerModel_new", function(len, ply)
    local msg = net.ReadString()
    if msg == "Rotate" then
        local eye_t_e = ply:GetEyeTrace().Entity
        rotation = rotation + 90
        eye_t_e:SetAngles(Angle(0, rotation, 0))
    end

    if msg == "Wood" then
        local eye_t_e = ply:GetEyeTrace().Entity
        local valid_ent = valid[eye_t_e:GetClass()]
        if valid_ent[1] then
            local ent = eye_t_e
            ent:SetModel(valid_ent[2])
            ent:SetHealthz(250)
            ent:SetMaxHealthz(250)
            --ent:Remove()
            ply:EmitSound("zohart/building/hammer-saw-" .. math.random(1, 3) .. ".wav")
        end
    end
end)

hook.Add("PlayerSpawn", "PlayerModelSelector", function(ply)
    if IsValid(ply) then
        ply:SetModel("models/player/spike/rustguy_grust.mdl")
        local rnd = math.random(1, 3)
        ply:SetSkin(rnd)
        ply:SetBodygroup(3, 1)
        ply:SetRunSpeed(280)
        if Rust.KeepInventory == false then ply.Inventory = {} end
    end
end)

hook.Add("PlayerNoClip", "noclip", function(ply) return ply:IsAdmin() end)