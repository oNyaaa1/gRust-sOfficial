gRust = gRust or {}
if Rust.Dev then
    DeriveGamemode("sandbox")
else
    DeriveGamemode("base")
end

GM.Name = "oNyaaaa's | gRust"
function GM:Initialize()
    game.AddAmmoType({
        name = "AK47_AMMO", -- '#BULLET_PLAYER_556MM_ammo'
        dmgtype = DMG_BULLET,
        tracer = TRACER_LINE,
        plydmg = 30,
        npcdmg = 30,
        force = 2000,
        maxcarry = 120,
        minsplash = 10,
        maxsplash = 5
    })
    
end

local IncludeDir = IncludeDir or {}
local meta = FindMetaTable("Player")
function meta:GetWood()
    return self:GetNWInt("Wood", 0)
end

function meta:GetHunger()
    return self:GetNWInt("Hunger", 0)
end

function meta:GetThirst()
    return self:GetNWInt("Thirst", 0)
end

function meta:GetMaxHunger()
    return 250
end

function meta:GetMaxThirst()
    return 300
end

function meta:SetHunger(amy)
    self:SetNWInt("Hunger", amy)
end

function meta:SetThirst(amy)
    self:SetNWInt("Thirst", amy)
end

local includes = function(f)
    if string.find(f, "sv_") then
        return SERVER and include(f)
    elseif string.find(f, "cl_") then
        return SERVER and AddCSLuaFile(f) or CLIENT and include(f)
    elseif string.find(f, "sh_") then
        if SERVER then
            AddCSLuaFile(f)
            return include(f)
        else
            return include(f)
        end
    end
end

IncludeDir = function(dir)
    local fol = dir .. '/'
    local files, folders = file.Find(fol .. '*', "LUA")
    for _, f in ipairs(files) do
        includes(fol .. f)
    end

    for _, f in ipairs(folders) do
        IncludeDir(dir .. '/' .. f)
    end
end

IncludeDir("rustix/gamemode/extra")
IncludeDir("rustix/gamemode/main")