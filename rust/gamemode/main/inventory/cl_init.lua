print("Inventory Loaded")
local w, h = ScrW(), ScrH()
hook.Add("OnScreenSizeChanged", "FixEdWidTh", function(_, _, nw, nh) w, h = ScrW(), ScrH() end)
gRustJas = gRustJas or {}
gRustJas.Inventory = {}
local frame2 = nil
local DermaImageButton = {}
local pnl1 = {}
local pnl2 = {}
local fram1 = nil
local function DoDrop(self, droppedPanels, bDoDrop)
    local dragged = droppedPanels[1] -- panel being dragged
    local target = self -- slot receiving the drop
    -- If dropped on a valid slot and target.CodeSortID > 0 
    if dragged.HasDropped then return end
    local isOutside = self.Drop == true and self.CodeSortID == -1
    if bDoDrop and isOutside then
        dragged.HasDropped = true
        net.Start("gRustDropInv")
        net.WriteFloat(-1) -- -1 = world
        net.WriteString(dragged.Weap)
        net.WriteFloat(dragged.OldSlot)
        net.SendToServer()
        dragged:Remove()
        timer.Simple(1, function() if IsValid(dragged) then dragged.HasDropped = false end end)
    end

    if bDoDrop then
        if dragged.OldSlot ~= target.CodeSortID then
            net.Start("gRustWriteSlot")
            net.WriteFloat(target.CodeSortID) -- new slot
            net.WriteString(dragged.Weap) -- weapon/item id
            net.WriteFloat(dragged.OldSlot) -- old slot
            net.SendToServer()
            dragged:SetParent(target)
            if IsValid(DermaImageButton[dragged.OldSlot]) then DermaImageButton[dragged.OldSlot] = nil end
        end
        return -- Exit here, don't drop to world
    end
end

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
        DermaImageButton[v.Slotz] = vgui.Create("DImageButton", pnl1[v.Slotz])
        DermaImageButton[v.Slotz]:SetSize(80, 66)
        DermaImageButton[v.Slotz]:SetPos(0, 0)
        DermaImageButton[v.Slotz]:SetImage(v.Img)
        DermaImageButton[v.Slotz]:Droppable("DroppableRust")
        DermaImageButton[v.Slotz].DoClick = function() MsgN("You clicked the image!") end
        DermaImageButton[v.Slotz].Model_IMG = v.Img
        DermaImageButton[v.Slotz].Weap = v.Weapon
        DermaImageButton[v.Slotz].OldSlot = v.Slotz
        DermaImageButton[v.Slotz]:SetMouseInputEnabled(true)
        DermaImageButton[v.Slotz].Paint = function(s, ww, hh)
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

surface.CreateFont("RustHudBig", {
    font = "Arial",
    extended = false,
    size = 20,
    weight = 2100,
    bold = true,
})

function DockInventory()
    if IsValid(fram1) then fram1:Remove() end
    fram1 = vgui.Create("DPanel", frame)
    fram1:SetSize(w, h)
    fram1:SetPos(0, 0)
    fram1.Drop = true
    fram1.CodeSortID = -1
    fram1:Receiver("DroppableRust", DoDrop)
    fram1.Paint = function(s, ww, hh) draw.RoundedBox(0, 0, 0, ww, hh, Color(65, 65, 65, 100)) end
    frame2 = vgui.Create("DPanel", fram1)
    frame2:SetSize(500, 417)
    frame2:SetPos(w * 0.35, h * 0.406)
    frame2.Paint = function(s, ww, hh) draw.RoundedBox(0, 0, 0, ww, hh, Color(65, 65, 65, 255)) end
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
        DermaImageButton[v.Slotz] = vgui.Create("DImageButton", pnl2[v.Slotz])
        DermaImageButton[v.Slotz]:SetSize(80, 66)
        DermaImageButton[v.Slotz]:SetPos(0, 0)
        DermaImageButton[v.Slotz]:SetImage(v.Img)
        DermaImageButton[v.Slotz]:Droppable("DroppableRust")
        DermaImageButton[v.Slotz].DoClick = function() MsgN("You clicked the image!") end
        DermaImageButton[v.Slotz].Model_IMG = v.Img
        DermaImageButton[v.Slotz]:SetMouseInputEnabled(true)
        DermaImageButton[v.Slotz].Weap = v.Weapon
        DermaImageButton[v.Slotz].OldSlot = v.Slotz
        DermaImageButton[v.Slotz].Paint = function(s, ww, hh)
            if s:IsHovered() then
                draw.RoundedBox(0, 0, 0, 80, 76, Color(5, 217, 255, 190))
            else
                draw.RoundedBox(0, 0, 0, 80, 76, Color(99, 99, 99, 190))
            end
        end
    end
    return {fram1, frame2}
end

local DockInventory1
function GM:ScoreboardShow()
    DockInventory1 = DockInventory
    DockInventory1()
    gui.EnableScreenClicker(true)
    return true
end

function GetFrameWorkFrame()
    return fram1
end

function GM:ScoreboardHide()
    local duckgo = DockInventory1()[1]
    if IsValid(duckgo) then duckgo:Remove() end
    gui.EnableScreenClicker(false)
    return true
end

hook.Add("PlayerBindPress", "Bindpressgturst", function(ply, bind, pressed)
    if not pressed then return end
    local sub = string.gsub(bind, "slot", "")
    local num = tonumber(sub)
    if not num or num <= 0 or num > 6 then return end
    if DermaImageButton[num] and num > 0 and num <= 6 then
        net.Start("gRustSelectWep")
        net.WriteFloat(num)
        net.WriteString(DermaImageButton[num].Weap or "")
        net.SendToServer()
    elseif DermaImageButton[num] == nil then
        net.Start("gRustSelectWep")
        net.WriteFloat(-1)
        net.WriteString("")
        net.SendToServer()
    end
end)