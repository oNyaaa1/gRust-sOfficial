net.Receive("gRust_Amount", function()
    local str1 = net.ReadString()
    local str2 = net.ReadFloat()
    if type(str1) ~= "string" then return end
    LocalPlayer():ChatPrint(string.format(LANG[gRust.Language][str1], str2))
end)

local decal = Material("tree/treemarker.png")
local hitPos = nil
local Angles = nil
local Ent = nil
local function TreeEffects(len)
    hitPos = net.ReadVector() or nil
    Angles = net.ReadAngle() or nil
    Ent = net.ReadEntity() or nil
end

net.Receive("gRust.TreeEffects", TreeEffects)
hook.Add("PostDrawOpaqueRenderables", "DrawTreeXMarker", function()
    if not hitPos then return end
    if not IsValid(Ent) then return end
    util.DecalEx(decal, Ent, hitPos, hitPos:GetNormalized(), Color(0, 255, 0), 0.1, 0.1)
end)