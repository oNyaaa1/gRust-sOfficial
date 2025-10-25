Rust = Rust or {}
Rust.KeepInventory = true -- Allow people to keep there inventory - true = keep, false = reset 
Rust.Dev = false -- true = sandbox, false = base
Rust.Selected = "sent_foundation"
Rust.GhostEntity = nil
Rust.Nests = {
    ["sent_foundation"] = {
        Class = "sent_foundation",
        Model = "models/building/twig_foundation.mdl",
        Pos = function(Position, entOnGround)
            if Position >= 1 and Position <= 40 or Position >= 320 and Position <= 360 then
                local Pos = Vector(entOnGround:GetPos().x + 120, entOnGround:GetPos().y, entOnGround:GetPos().z)
                return Pos, Angle(0, 0, 0)
            elseif Position > 50 and Position < 120 then
                local Pos = Vector(entOnGround:GetPos().x, entOnGround:GetPos().y - 120, entOnGround:GetPos().z)
                return Pos, Angle(0, 0, 0)
            elseif Position > 146 and Position < 217 then
                local Pos = Vector(entOnGround:GetPos().x - 120, entOnGround:GetPos().y, entOnGround:GetPos().z)
                return Pos, Angle(0, 0, 0)
            elseif Position > 234 and Position < 310 then
                local Pos = Vector(entOnGround:GetPos().x, entOnGround:GetPos().y + 120, entOnGround:GetPos().z)
                return Pos, Angle(0, 0, 0)
            end
        end,
    },
    ["sent_wall"] = {
        Class = "sent_wall",
        Model = "models/building/twig_wall.mdl",
        Pos = function(Position, entOnGround)
            if Position >= 1 and Position <= 40 or Position >= 320 and Position <= 360 then
                local Pos = Vector(entOnGround:GetPos().x + 60, entOnGround:GetPos().y, entOnGround:GetPos().z)
                return Pos, Angle(0, 90, 0)
            elseif Position > 50 and Position < 120 then
                local Pos = Vector(entOnGround:GetPos().x, entOnGround:GetPos().y - 60, entOnGround:GetPos().z)
                return Pos, Angle(0, 0, 0)
            elseif Position > 146 and Position < 217 then
                local Pos = Vector(entOnGround:GetPos().x - 60, entOnGround:GetPos().y, entOnGround:GetPos().z)
                return Pos, Angle(0, 90, 0)
            elseif Position > 234 and Position < 310 then
                local Pos = Vector(entOnGround:GetPos().x, entOnGround:GetPos().y + 60, entOnGround:GetPos().z)
                return Pos, Angle(0, 0, 0)
            end
        end,
    },
    ["sent_doorway"] = {
        Class = "sent_doorway",
        Model = "models/building/twig_foundation.mdl",
    },
    ["sent_door"] = {
        Class = "sent_door",
        Model = "models/building/twig_foundation.mdl",
    },
}