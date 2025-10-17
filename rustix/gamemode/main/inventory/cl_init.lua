print("Inventory Loaded")
local w, h = ScrW(), ScrH()
hook.Add("OnScreenSizeChanged", "FixEdWidTh", function(_, _, nw, nh) w, h = ScrW(), ScrH() end)
gRustJas = gRustJas or {}
gRustJas.Inventory = {}
local pnl2 = nil
local frame2 = nil
function DoDrop(self, panels, bDoDrop, Command, x, y)
    if bDoDrop and panels[1].OldSlot ~= self.CodeSortID then
        net.Start("gRustWriteSlot")
        net.WriteFloat(self.CodeSortID or -1)
        net.WriteFloat(self.CodeID or -1)
        net.WriteString(panels[1].Weap)
        net.WriteFloat(panels[1].OldSlot or -1)
        net.SendToServer()
        panels[1]:SetParent(self)
    end
end

local pnl1 = {}
local function ClearSlots(tbl2)
    if IsValid(pnl2) then pnl2:Remove() end
    pnl1 = {}
    pnl2 = vgui.Create("DPanel")
    pnl2:SetPos(w * 0.35, h * 0.9)
    pnl2:SetSize(500, 90)
    pnl2.Paint = function(s, ww, hh) draw.RoundedBox(0, 0, 0, ww, hh, Color(99, 99, 99, 0)) end
    local grid = vgui.Create("ThreeGrid", pnl2)
    grid:Dock(FILL)
    grid:SetSize(100, 78)
    grid:DockMargin(4, 4, 4, 4)
    grid:InvalidateParent(true)
    grid:SetColumns(6)
    grid:SetHorizontalMargin(2)
    grid:SetVerticalMargin(2)
    for i = 1, 6 do
        if not IsValid(pnl1[i]) then
            pnl1[i] = vgui.Create("DPanel")
            pnl1[i]:SetTall(80)
            pnl1[i]:SetWide(180)
            pnl1[i].CodeSortID = i
            pnl1[i]:Receiver("DroppableRust", DoDrop)
            pnl1[i].Paint = function(s, ww, hh)
                if s:IsHovered() then
                    draw.RoundedBox(0, 0, 0, ww, hh, Color(5, 217, 255, 190))
                else
                    draw.RoundedBox(0, 0, 0, ww, hh, Color(99, 99, 99, 190))
                end
            end

            grid:AddCell(pnl1[i])
        end
    end

    for k, v in pairs(tbl2) do
        if v.Img == nil then continue end
        if pnl1[v.Slotz] == nil then continue end
        local DermaImageButton = vgui.Create("DImageButton", pnl1[v.Slotz])
        DermaImageButton:SetSize(80,80)
        DermaImageButton:SetPos(0, 0)
        DermaImageButton:SetImage(v.Img)
        DermaImageButton:Droppable("DroppableRust")
        DermaImageButton.DoClick = function() MsgN("You clicked the image!") end
        DermaImageButton.Model_IMG = v.Img
        DermaImageButton.Weap = v.Weapon
        DermaImageButton.OldSlot = v.Slotz
        DermaImageButton.Paint = function(s, ww, hh)
            if s:IsHovered() then
                draw.RoundedBox(0, 0, 0, ww, hh, Color(5, 217, 255, 190))
            else
                draw.RoundedBox(0, 0, 0, ww, hh, Color(99, 99, 99, 190))
            end

            draw.DrawText(tostring(v.Amount), "Default", 0, 0, Color(0, 0, 0), TEXT_ALIGN_LEFT)
        end
    end
end

net.Receive("DragNDropRust", function()
    gRustJas.Inventory = net.ReadTable()
    local en = net.ReadBool()
    ClearSlots(gRustJas.Inventory)
end)

function GM:ScoreboardShow()
    local pnl2 = {}
    frame2 = vgui.Create("DPanel", frame)
    frame2:SetSize(500, 500)
    frame2:SetPos(w * 0.35, h * 0.40)
    frame2.Paint = function(s, ww, hh) draw.RoundedBox(0, 0, 0, ww, hh, Color(65, 65, 65, 0)) end
    local grid2 = vgui.Create("ThreeGrid", frame2)
    grid2:Dock(FILL)
    grid2:DockMargin(4, 4, 4, 4)
    grid2:InvalidateParent(true)
    grid2:SetColumns(6)
    grid2:SetHorizontalMargin(2)
    grid2:SetVerticalMargin(2)
    for i = 7, 36 do
        if not IsValid(pnl2[i]) then
            pnl2[i] = vgui.Create("DPanel")
            pnl2[i]:SetTall(80)
            pnl2[i]:SetWide(180)
            pnl2[i].CodeSortID = i
            pnl2[i]:Receiver("DroppableRust", DoDrop)
            pnl2[i].Paint = function(s, ww, hh)
                if s:IsHovered() then
                    draw.RoundedBox(0, 0, 0, ww, hh, Color(5, 217, 255, 190))
                else
                    draw.RoundedBox(0, 0, 0, ww, hh, Color(99, 99, 99, 190))
                end
            end

            grid2:AddCell(pnl2[i])
        end
    end

    for k, v in pairs(gRustJas.Inventory) do
        if v.Img == nil then continue end
        if pnl2[v.Slotz] == nil then continue end
        local DermaImageButton = vgui.Create("DImageButton", pnl2[v.Slotz])
        DermaImageButton:SetSize(80,80)
        DermaImageButton:SetPos(0, 0)
        DermaImageButton:SetImage(v.Img)
        DermaImageButton:Droppable("DroppableRust")
        DermaImageButton.DoClick = function() MsgN("You clicked the image!") end
        DermaImageButton.Model_IMG = v.Img
        DermaImageButton.Weap = v.Weapon
        DermaImageButton.OldSlot = v.Slotz
        DermaImageButton.Paint = function(s, ww, hh)
            if s:IsHovered() then
                draw.RoundedBox(0, 0, 0, ww, hh, Color(5, 217, 255, 190))
            else
                draw.RoundedBox(0, 0, 0, ww, hh, Color(99, 99, 99, 190))
            end

            draw.DrawText(tostring(v.Amount), "Default", 0, 0, Color(0, 0, 0), TEXT_ALIGN_LEFT)
        end
    end

    gui.EnableScreenClicker(true)
    return true
end

function GM:ScoreboardHide()
    gui.EnableScreenClicker(false)
    if IsValid(frame2) then frame2:Remove() end
    return true
end