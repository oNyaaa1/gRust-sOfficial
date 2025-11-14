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

surface.CreateFont("RustHudBig", {
    font = "Arial",
    extended = false,
    size = 20,
    weight = 2100,
    bold = true,
})

local DermaImageButton = {}
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

                if tbl2[i] and tbl2[i].Amount ~= nil then
                    draw.DrawText(tostring(tbl2[i].Amount), "RustHudBig", ww / 2 + 40, hh - 15, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
                else
                    draw.DrawText("", "RustHudBig", ww / 2 + 40, hh - 15, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
                end

            end

            grid:AddCell(pnl1[i])
        end
    end

    for k, v in pairs(tbl2) do
        if not istable(v) then continue end
        if v.Img == nil then continue end
        if pnl1[v.Slotz] == nil then continue end
        DermaImageButton[k] = vgui.Create("DImageButton", pnl1[v.Slotz])
        DermaImageButton[k]:SetSize(80, 66)
        DermaImageButton[k]:SetPos(0, 0)
        DermaImageButton[k]:SetImage(v.Img)
        DermaImageButton[k]:Droppable("DroppableRust")
        DermaImageButton[k].DoClick = function() MsgN("You clicked the image!") end
        DermaImageButton[k].Model_IMG = v.Img
        DermaImageButton[k].Weap = v.Weapon
        DermaImageButton[k].OldSlot = v.Slotz
        DermaImageButton[k].Paint = function(s, ww, hh)
            if s:IsHovered() then
                draw.RoundedBox(0, 0, 0, 80, 76, Color(5, 217, 255, 190))
            else
                draw.RoundedBox(0, 0, 0, 80, 76, Color(99, 99, 99, 190))
            end
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

                if gRustJas.Inventory[i] and gRustJas.Inventory[i].Amount ~= nil then
                    draw.DrawText(tostring(gRustJas.Inventory[i].Amount), "RustHudBig", ww / 2 + 40, hh - 15, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
                else
                    draw.DrawText("", "RustHudBig", ww / 2 + 40, hh - 15, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
                end
            end

            grid2:AddCell(pnl2[i])
        end
    end

    for k, v in pairs(gRustJas.Inventory) do
        if not istable(v) then continue end
        if v.Img == nil then continue end
        if pnl2[v.Slotz] == nil then continue end
        DermaImageButton[k] = vgui.Create("DImageButton", pnl2[v.Slotz])
        DermaImageButton[k]:SetSize(80, 66)
        DermaImageButton[k]:SetPos(0, 0)
        DermaImageButton[k]:SetImage(v.Img)
        DermaImageButton[k]:Droppable("DroppableRust")
        DermaImageButton[k].DoClick = function() MsgN("You clicked the image!") end
        DermaImageButton[k].Model_IMG = v.Img
        DermaImageButton[k].Weap = v.Weapon
        DermaImageButton[k].OldSlot = v.Slotz
        DermaImageButton[k].Paint = function(s, ww, hh)
            if s:IsHovered() then
                draw.RoundedBox(0, 0, 0, 80, 76, Color(5, 217, 255, 190))
            else
                draw.RoundedBox(0, 0, 0, 80, 76, Color(99, 99, 99, 190))
            end
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

hook.Add("PlayerBindPress", "Bindpressgturst", function(ply, bind, pressed)
    if not pressed then return end
    local sub = string.gsub(bind, "slot", "")
    local num = tonumber(sub)
    if not num or num <= 0 or num > 6 then return end
    if IsValid(DermaImageButton[num]) then
        net.Start("gRustSelectWep")
        net.WriteFloat(num)
        net.WriteFloat(-1)
        net.WriteString(DermaImageButton[num].Weap or "")
        net.WriteFloat(num)
        net.SendToServer()
    end
end)