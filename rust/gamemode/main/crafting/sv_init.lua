print("Crafting")
util.AddNetworkString("BuildingCrafting")
util.AddNetworkString("crafting_Gear")
net.Receive("BuildingCrafting", function(len, pl)
    local blueprint = net.ReadString()
    local itemz = ITEMS:GetItem(blueprint)
    local wep = itemz.Name
    local timerz = itemz:Craft()[1].Time
    local bool
    if timer.Exists("TimerForCraft" .. tostring(pl:SteamID64())) then return end
    for k, v in pairs(itemz:Craft()) do
        bool = pl:TakeItem(v[k].ITEM, v[k].AMOUNT)
    end

    if not bool then return end
    pl.reached = timerz
    timer.Create("TimerForCraft" .. tostring(pl:SteamID64()), 1, 0, function()
        if not pl:Alive() then
            pl.reached = nil
            timer.Remove("TimerForCraft" .. tostring(pl:SteamID64()))
            print("Timer Reached")
            net.Start("crafting_Gear")
            net.WriteString("")
            net.WriteFloat(0)
            net.Send(pl)
            return
        end

        pl.reached = pl.reached - 1
        net.Start("crafting_Gear")
        net.WriteString(wep)
        net.WriteFloat(pl.reached)
        net.Send(pl)
        if pl.reached <= 0 then
            pl.reached = nil
            timer.Remove("TimerForCraft" .. tostring(pl:SteamID64()))
            print("Timer Reached")
            pl:GiveItem(wep, itemz.Count, true)
        end
    end)
end)

hook.Add("PlayerDeath", "PDRESET", function(ply, inf, attk)
    net.Start("crafting_Gear")
    net.WriteString("")
    net.WriteFloat(0)
    net.Send(ply)
    ply.reached = nil
    timer.Remove("TimerForCraft" .. tostring(ply:SteamID64()))
end)