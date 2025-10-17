print("Crafting")
local Width, Height = ScrW(), ScrH()
local Tbl = {}
Tbl[1] = {"Favorite", "icons/favorite_inactive.png"}
Tbl[2] = {"Construction", "icons/construction.png"}
Tbl[3] = {"Items", "icons/extinguish.png"}
Tbl[4] = {"Resources", "icons/servers.png"}
Tbl[5] = {"Clothing", "icons/servers.png"}
Tbl[6] = {"Tools", "icons/tools.png"}
Tbl[7] = {"Medical", "icons/medical.png"}
Tbl[8] = {"Weapons", "icons/weapon.png"}
Tbl[9] = {"Ammo", "icons/ammo.png"}
Tbl[11] = {"Fun", "icons/servers.png"}
Tbl[12] = {"Other", "icons/electric.png"}
Tbl[13] = {"Extra", "icons/electric.png"}
local tbl2 = {}
for k, v in pairs(Tbl) do
    tbl2[k] = Material(v[2], "noclamp smooth")
end

local function zSetHealth(icon, x, y, col)
    draw.RoundedBox(4, x, y, 300, 26, col)
    x = x or 0
    y = y or 0
    surface.SetMaterial(icon)
    surface.SetDrawColor(color_white)
    surface.DrawTexturedRect(x, y, 24, 24)
end

function drawFilledCircle(x, y, r, ang, color) --x, y being center of the circle, r being radius
    local verts = {
        {
            x = x, --add center point
            y = y
        }
    }

    for i = 0, ang do
        local xx = x + math.cos(math.rad(i)) * r
        local yy = y - math.sin(math.rad(i)) * r
        table.insert(verts, {
            x = xx,
            y = yy
        })
    end

    --the resulting table is a list of counter-clockwise vertices
    --surface.DrawPoly() needs clockwise list
    verts = table.Reverse(verts) --should do the job
    surface.SetDrawColor(color or color_white)
    draw.NoTexture()
    surface.DrawPoly(verts)
end

surface.CreateFont("gRustFont", {
    font = "Arial",
    extended = false,
    size = 21,
    weight = 500,
    bold = true,
})

surface.CreateFont("CraftingRustFont", {
    font = "Arial",
    extended = false,
    size = 22,
    weight = 500,
    bold = true,
})

local btn = {}
local right = right or nil
local dpanel = dpanel or nil
local dpnl = nil
local function RightPanelInfo(pnl, ITEM)
    if IsValid(dpanel) then dpanel:Remove() end
    dpanel2 = vgui.Create("DPanel", pnl)
    dpanel2:Dock(TOP)
    dpanel2:SetSize(pnl:GetWide() / 2, Height)
    dpanel2.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(94, 94, 94, 255))
        draw.DrawText(ITEM.Name, "CraftingRustFont", Width * 0.2, 50, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    end

    local DLabel = vgui.Create("DLabel", dpanel2)
    DLabel:Dock(FILL)
    DLabel:SetSize(280, 50)
    DLabel:SetText(ITEM.Info)
    DLabel:SetFont("CraftingRustFont")
    DLabel:SizeToContents()
    DLabel:DockMargin(0, 1, 0, Height / 2 + 200)
    DLabel:SetWrap(true)
    local Buttonz = vgui.Create("DImageButton", dpanel2)
    Buttonz:SetImage(ITEM.model)
    Buttonz:SetPos(10, 20)
    Buttonz:SetSize(80, 80)
    dpanel = vgui.Create("DPanel", pnl)
    dpanel:Dock(BOTTOM)
    dpanel:DockPadding(0, 1, 0, 0)
    dpanel:SetSize(Width * 0.10, Height * 0.22)
    dpanel.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(94, 94, 94, 150)) end
    local AppList = vgui.Create("DListView", dpanel)
    AppList:Dock(FILL)
    AppList:SetMultiSelect(false)
    AppList:AddColumn("Amount")
    AppList:AddColumn("Item Type")
    AppList:AddColumn("Total")
    AppList:AddColumn("Have")
    AppList:AddColumn("Create Time")
    AppList:AddColumn("Can Craft")
    for k, v in ipairs(ITEM.Craft()) do
        if istable(v) then
            for i, j in ipairs(v) do
                if istable(j) then
                    local time = string.FormattedTime(v.Time, "%02i:%02i")
                    AppList:AddLine(tostring(j.AMOUNT), tostring(j.ITEM), "2", "321", tostring(time) .. " Seconds", tostring(v.CanCraft))
                end
            end
        end
    end
    //pnl:GetColumnText(1) index
    AppList.OnRowSelected = function(lst, index, pnl) end
    local Buttonzz = vgui.Create("DButton", dpanel)
    Buttonzz:Dock(BOTTOM)
    Buttonzz:DockMargin(400, 0, 0, 0)
    Buttonzz:SetSize(80, 80)
    Buttonzz:SetText("")
    Buttonzz.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(66, 66, 66))
        draw.DrawText("CRAFT", "CraftingRustFont", 110, 25, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    end
    return dpanel2
end

local CraftingInventory = function()
    local dpanel = vgui.Create("DPanel")
    dpanel:SetPos(50, 50)
    dpanel:SetSize(Width * 0.93, Height * 0.8)
    dpanel.Paint = function(s, w, h) end
    local left = vgui.Create("DPanel", dpanel)
    left:Dock(LEFT)
    left:SetSize(Width * 0.1, Height * 0.8)
    left.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(94, 94, 94, 150)) end
    local Timmeh = 360
    local MyTime = 0
    local Bottom = vgui.Create("DPanel", dpanel)
    Bottom:Dock(BOTTOM)
    Bottom:SetSize(0, Height * 0.11)
    Bottom:DockMargin(0, 0, Width * 0.43, 0)
    Bottom.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(94, 94, 94, 255))
        draw.DrawText("CRAFTING QUEUE", "gRustColorFont", 0, h * 0.2, Color(255, 255, 255, 40), TEXT_ALIGN_LEFT)
        if Timmeh <= 0 then Timmeh = 360 end
        if MyTime <= CurTime() then
            MyTime = CurTime() + 0.1
            Timmeh = Timmeh - 1
        end

        local time = math.Round(1 % CurTime() + Timmeh - 1)
        --drawFilledCircle(14, 14, 13, time, Color(255, 255, 255, 255))
    end

    local middleleft = vgui.Create("DPanel", dpanel)
    middleleft:Dock(LEFT)
    middleleft:SetSize(Width * 0.4, Height * 0.8)
    middleleft.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(94, 94, 94, 150)) end
    local grid2 = vgui.Create("ThreeGrid", middleleft)
    grid2:Dock(FILL)
    grid2:DockMargin(4, 4, 4, 4)
    grid2:SetColumns(6)
    grid2:SetHorizontalMargin(2)
    grid2:SetVerticalMargin(2)
    grid2:InvalidateParent(true)
    grid2:InvalidateLayout(true)
    for k, v in pairs(Tbl) do
        local DButtons = vgui.Create("DButton", left)
        DButtons:Dock(TOP)
        DButtons:SetTall(50)
        DButtons:SetText("")
        DButtons.DoClick = function(me)
            grid2:Clear()
            for _, vk in pairs(ITEMS) do
                if type(vk) == "function" then continue end
                if type(vk) == "table" and vk.Category == v[1] and not IsValid(btn[_]) then
                    btn[_] = vgui.Create("DImageButton")
                    btn[_]:SetImage(vk.model)
                    btn[_]:Dock(FILL)
                    btn[_]:SetTall(80)
                    btn[_]:Droppable("myDNDname")
                    btn[_].DoClick = function()
                        if IsValid(dpnl) then dpnl:Remove() end
                        dpnl = RightPanelInfo(right, vk)
                    end

                    grid2:AddCell(btn[_])
                end
            end
        end

        local xd = COUNT[v[1]]
        DButtons.Paint = function(s, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(94, 94, 94, 160))
            zSetHealth(tbl2[k], 0, 10, Color(0, 0, 0, 0))
            draw.DrawText(v[1], "gRustFont", w * 0.2, h * 0.2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
            draw.DrawText(xd ~= nil and xd or "0", "gRustFont", w * 0.9, h * 0.2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
        end
    end

    right = vgui.Create("DPanel", dpanel)
    right:Dock(LEFT)
    right:SetSize(Width * 0.43, Height * 0.8)
    right.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(94, 94, 94, 150)) end
    return dpanel
end

local pnl = pnl or nil
function GM:OnSpawnMenuOpen()
    pnl = CraftingInventory()
    gui.EnableScreenClicker(true)
end

function GM:OnSpawnMenuClose()
    gui.EnableScreenClicker(false)
    pnl:Remove()
end