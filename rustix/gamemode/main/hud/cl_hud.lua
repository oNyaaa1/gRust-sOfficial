local Hud = {}
local w, h = ScrW(), ScrH()
Hud.Posx, Hud.Posy = w * 0.8, h * 0.86
local health = Material("icons/health.png", "noclamp smooth")
local water = Material("icons/cup.png", "noclamp smooth")
local food = Material("icons/food.png", "noclamp smooth")
local function zSetHealth(icon, name, length, x, y, col)
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    local lgnth = 300
    draw.RoundedBox(4, Hud.Posx + x, Hud.Posy + y, lgnth, 26, Color(0, 0, 0, 255))
    draw.RoundedBox(4, Hud.Posx + x, Hud.Posy + y, lgnth * length, 26, col)
    x = x or 0
    y = y or 0
    surface.SetMaterial(icon)
    surface.SetDrawColor(color_white)
    surface.DrawTexturedRect(Hud.Posx + x, Hud.Posy + y, 24, 24)
end

hook.Add("HUDPaint", "MrRustHud", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    zSetHealth(health, "Health: ", ply:Health() / ply:GetMaxHealth(), 1, 1, Color(255, 0, 0, 200))
    zSetHealth(water, "Health: ", ply:GetThirst() / ply:GetMaxThirst(), 1, 30, Color(24, 24, 255, 200))
    zSetHealth(food, "Health: ", ply:GetHunger() / ply:GetMaxHunger(), 1, 60, Color(24, 255, 24, 200))
end)

local hide = {
    ["CHudHealth"] = true,
    ["CHudAmmo"] = true,
    ["CHudWeaponSelection"] = true
}

hook.Add("HUDShouldDraw", "rustHide", function(name) if hide[name] then return false end end)