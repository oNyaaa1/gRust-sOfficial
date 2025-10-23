print("Crafting")
util.AddNetworkString("BuildingCrafting")
net.Receive("BuildingCrafting", function(len, pl)
    local blueprint = net.ReadString()
    local itemz = ITEMS:GetItem(blueprint)
    local wep = itemz.Name
    local timerz = itemz:Craft()[1].Time
    local bool
    for k, v in pairs(itemz:Craft()) do
        bool = pl:TakeItem(v[k].ITEM, v[k].AMOUNT)
    end

    if not bool then return end
    timer.Simple(timerz, function() pl:GiveItem(wep, 1) end)
end)