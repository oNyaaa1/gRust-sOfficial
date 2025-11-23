local w, h = ScrW(), ScrH()
local ButttonsImage = {}
net.Receive("f1MenuGRust", function()
    local DFramegRust = vgui.Create("DFrame")
    DFramegRust:SetPos(0, 0)
    DFramegRust:SetSize(w, h)
    DFramegRust:SetTitle("gRust Items Menu")
    DFramegRust:MakePopup()
    DFramegRust.Paint = function(self, wh, hw) draw.RoundedBox(0, 0, 0, wh, hw, Color(0, 0, 0, 150)) end
    local copypaste = vgui.Create("DPanel", DFramegRust)
    copypaste:SetPos(0, 25)
    copypaste:SetSize(w, h)
    copypaste.Paint = function(self, wh, hw) draw.RoundedBox(0, 0, 0, wh, hw, Color(0, 0, 0, 200)) end
    local Panel_TOP_BarNoDock = vgui.Create("DPanel", DFramegRust)
    Panel_TOP_BarNoDock:SetPos(0, 25)
    Panel_TOP_BarNoDock:SetSize(w, 50)
    Panel_TOP_BarNoDock.Paint = function(self, wh, hw) draw.RoundedBox(0, 0, 0, wh, hw, Color(0, 0, 0, 200)) end
    local Panel_TOP_Bar = vgui.Create("DPanel", Panel_TOP_BarNoDock)
    Panel_TOP_Bar:SetPos(0, 25)
    Panel_TOP_Bar:Dock(FILL)
    Panel_TOP_Bar.Paint = function(self, wh, hw) draw.RoundedBox(0, 0, 0, wh, hw, Color(0, 0, 0, 200)) end
    local copypastez = vgui.Create("DPanel", DFramegRust)
    copypastez:SetPos(0, 100)
    copypastez:Dock(FILL)
    copypastez:DockMargin(0, 50, 0, 0)
    copypastez.Paint = function(self, wh, hw) draw.RoundedBox(0, 0, 0, wh, hw, Color(255, 0, 0, 200)) end
    for k, v in pairs(ITEMS:GetTbl()) do
        if type(v) == "table" then
            local Panel_TOP_BarDock = vgui.Create("DButton", Panel_TOP_BarNoDock)
            Panel_TOP_BarDock:SetPos(0, 25)
            Panel_TOP_BarDock:Dock(LEFT)
            Panel_TOP_BarDock:SetWide(70)
            Panel_TOP_BarDock:SetTall(40)
            Panel_TOP_BarDock:SetText("")
            Panel_TOP_BarDock.Paint = function(self, wh, hw)
                draw.RoundedBox(0, 0, 0, wh, hw, Color(0, 0, 255, 255))
                draw.DrawText(v[1] .. " - " .. tostring(COUNT[v[1]] or 0), "DermaDefault", 0, 15, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
            end

            Panel_TOP_BarDock.DoClick = function()
                for kk, vv in pairs(ButttonsImage) do
                    vv:Remove()
                end
                
                for _, j in pairs(ITEMS) do
                    if istable(j) and v[1] == j.Category then
                        ButttonsImage[_] = vgui.Create("DImageButton", copypastez)
                        ButttonsImage[_]:SetPos(0, 25)
                        ButttonsImage[_]:SetWide(140)
                        ButttonsImage[_]:SetTall(200)
                        ButttonsImage[_]:SetImage(j.model)
                        ButttonsImage[_]:Dock(LEFT)
                        ButttonsImage[_]:InvalidateParent(true)
                        ButttonsImage[_]:DockMargin(0, 0, 0, h / 2 + 100)
                        ButttonsImage[_].DoClick = function() print("hi") end
                        ButttonsImage[_].Paint = function(self, wh, hw) draw.DrawText(_, "DermaDefault", 15, 0, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT) end
                    end
                end
            end
        end
    end
end)