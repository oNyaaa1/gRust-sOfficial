AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("config.lua")
include("config.lua")
include("shared.lua")
/*
Added colorization to inventory on hover
Swap to hands if there is no obj or wep in hands in inventory swap
Enlarged image and setpos-y = 0 so it's not off singly handed

*/
util.AddNetworkString("gRust_ServerModel_new")
util.AddNetworkString("gRust_ServerModel")
util.AddNetworkString("Rust_TableValid")
local AddItemWeps = {"wrock",}
hook.Add("PlayerSpawn", "PlayerModelSelector", function(ply)
    if IsValid(ply) then
        ply:SetModel("models/player/spike/rustguy_grust.mdl")
        for k, v in pairs(AddItemWeps) do
            print("Adding: " .. v)
            ply:Give("rust_" .. v)
        end

        ply:SetSkin(0)
        ply:SetBodygroup(3, 1)
        if Rust.KeepInventory == false then ply.Inventory = {} end
    end
end)

hook.Add("PlayerNoClip", "noclip", function(ply) return ply:IsAdmin() end)