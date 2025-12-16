--fuck
local DermaPanel
surface.CreateFont("Font", {
    font = "Arial",
    extended = true,
    size = 20
})

net.Receive("Wand_Spells", function() WH.Spells = net.ReadTable() end)
local mat2 = Material("cable/xbeam")
local glob_ply = nil
net.Receive("SendLightNing", function() glob_ply = net.ReadEntity() end)
hook.Add("PostDrawOpaqueRenderables", "SpawnLightning", function()
    if not IsValid(glob_ply) then return end
    local ply = glob_ply
    local start_pos = ply:GetViewModel():GetPos()
    local end_pos = ply:GetEyeTrace().HitPos
    local dir = end_pos - start_pos
    local increment = dir:Length() / 12
    dir:Normalize()
    -- set material
    render.SetMaterial(mat2)
    -- start the beam with 14 points
    render.StartBeam(14)
    -- add start
    render.AddBeam(start_pos, -- Start position
        1, -- Width
        CurTime(), -- Texture coordinate
        Color(64, 255, 64, 255))

    -- Color
    --
    local i
    for i = 1, 12 do
        -- get point
        local point = (start_pos + dir * (i * increment)) + VectorRand() * math.random(1, 16)
        -- texture coords
        local tcoord = CurTime() + (1 / 12) * i
        -- add point
        render.AddBeam(point, 32, tcoord, Color(64, 255, 64, 255))
    end

    -- add the last point
    render.AddBeam(end_pos, 32, CurTime() + 1, Color(64, 255, 64, 255))
    -- finish up the beam
    render.EndBeam()
    glob_ply = nil
end)

local faded_black = Color(0, 0, 0, 200)
function WandMenu(ent, ply)
    if IsValid(DermaPanel) then DermaPanel:Remove() end
    DermaPanel = vgui.Create("DFrame") -- The name DermaPanel to store the value DFrame.
    DermaPanel:SetSize(ScrW() * 0.4, ScrH() * 0.6) -- Sets the size to 500x by 300y.
    DermaPanel:Center() -- Centers the panel.
    DermaPanel:SetTitle("") -- Set the title to nothing.
    DermaPanel:SetDraggable(false) -- Makes it so you can't drag it.
    DermaPanel:MakePopup() -- Makes it so you can move your mouse on it.
    -- Paint function w, h = how wide and tall it is.
    DermaPanel.Paint = function(self, w, h)
        faded_black = Color(math.sin(CurTime() * 1) * 200, math.cos(CurTime() * 1) * 200, math.sin(CurTime() * 180) * 200, 200)
        draw.RoundedBox(2, 0, 0, w, h, faded_black)
        -- Draws text in the color white.
        draw.SimpleText("Magic Wand Menu", "Font", DermaPanel:GetWide() * 0.5, 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    local ugleh2 = vgui.Create("DPanel", DermaPanel)
    ugleh2:Dock(LEFT)
    ugleh2:SetSize(200, DermaPanel:GetTall())
    ugleh2:DockMargin(20, 20, 20, 20)
    for k, v in pairs(WH:GetSpells()) do
        local dButton = vgui.Create("DButton", ugleh2)
        dButton:Dock(TOP)
        dButton:DockMargin(0, 0, 0, 2)
        dButton:SetText("")
        dButton:SetSize(0, 50)
        dButton.Paint = function(s, w, h)
            draw.RoundedBox(2, 0, 0, w, h, faded_black)
            surface.SetDrawColor(0, 0, 255, 255)
            surface.DrawOutlinedRect(0, 0, w, h, 5)
            draw.SimpleText(tostring(v), "Font", dButton:GetWide() * 0.5, dButton:GetTall() * 0.25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        end

        dButton.DoClick = function()
            net.Start("Wand_Spells_Remake")
            net.WriteString(v)
            net.SendToServer()
        end
    end

    local ugleh = vgui.Create("DPanel", DermaPanel)
    ugleh:Dock(LEFT)
    ugleh:SetSize(340, DermaPanel:GetTall() - 30)
    ugleh:DockMargin(20, 20, 20, 20)
end