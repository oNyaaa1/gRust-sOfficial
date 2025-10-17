net.Receive("gRust_Amount", function()
    local str1 = net.ReadString()
    local str2 = net.ReadFloat()
    if type(str1) ~= "string" then return end
    LocalPlayer():ChatPrint(string.format(LANG[gRust.Language][str1], str2))
end)

local hitPos = nil
local Angles = nil
local Ent = nil
local function TreeEffects(len)
    hitPos = net.ReadVector() or nil
    Angles = net.ReadAngle() or nil
    Ent = net.ReadEntity() or nil
end

net.Receive("gRust.TreeEffects", TreeEffects)
local tree = Material("tree/treemarker.png", "noclamp smooth")
hook.Add("PostDrawOpaqueRenderables", "DrawTreeXMarker", function()
    if not hitPos then return end
    if not Ent then return end
    cam.Start3D2D(hitPos, Angles - Angle(90, 0, 0), 0.4)
    surface.SetMaterial(tree)
    surface.SetDrawColor(color_white)
    surface.DrawTexturedRect(0, 0, 24, 24)
    cam.End3D2D()
end)