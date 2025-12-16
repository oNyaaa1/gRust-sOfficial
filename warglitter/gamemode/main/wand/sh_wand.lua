-- fuck fuck double wand
WH = WH or {}
WH.Spells = {}
function WH:GetSpells()
    return WH.Spells
end

local meta = FindMetaTable("Player")
function meta:GetWandPos()
    return self:GetShootPos()
end