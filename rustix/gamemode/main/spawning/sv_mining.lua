local ORE_WEAPONS = {
    ["rust_wrock"] = {
        ["Metal Ore"] = 1,
        ["Sulfur Ore"] = 1,
        ["Stone"] = 1
    },
    ["rust_stonepickaxe"] = {
        ["Metal Ore"] = 1.94,
        ["Sulfur Ore"] = 2.57,
        ["Stone"] = 2.11733
    },
    ["rust_pickaxe"] = {
        ["Metal Ore"] = 2.4,
        ["Sulfur Ore"] = 3,
        ["Stone"] = 2.667
    },
    ["rust_jackhammer"] = {
        ["Metal Ore"] = 2.4,
        ["Sulfur Ore"] = 3,
        ["Stone"] = 2.667
    }
}

local ORE_SEQ = {
    [1] = {
        item = "Metal Ore",
        seq = {25, 25, 25, 25, 25, 25, 25, 25, 25, 25}
    },
    [2] = {
        item = "Sulfur Ore",
        seq = {10, 10, 10, 10, 10, 10, 10, 10, 10, 10}
    },
    [3] = {
        item = "Stone",
        seq = {39, 39, 38, 38, 38, 37, 37, 37, 36, 36}
    }
}

-- Function to check if a weapon is a valid mining tool
gRust.Mining.IsValidMiningTool = function(weaponClass)
    return ORE_WEAPONS[weaponClass] ~= nil
end

gRust.Items = {
    ["Stone"] = "Stone",
    ["Metal Ore"] = "Metal Ore",
    ["Sulfur Ore"] = "Sulfur Ore",
}

gRust.Mining.MineOres = function(ply, ent, weapon, class)
     if not ply.Wood_Cutting_Tool then ply.Wood_Cutting_Tool = 0 end
    if ply.Wood_Cutting_Tool > CurTime() then return end
    ply.Wood_Cutting_Tool = CurTime() + 1
    local tool = ORE_WEAPONS[class]
    if not tool then return end
    local seq = ORE_SEQ[ent:GetSkin()] or ORE_SEQ[1]
    if not ent.oreHealth then ent.oreHealth, ent.oreHits = #seq.seq, 0 end
    ent.oreHealth, ent.oreHits = ent.oreHealth - 1, ent.oreHits + 1
    local idx = math.min(ent.oreHits, #seq.seq)
    local multForOre = tool[seq.item] or 1
    local reward = math.Round(seq.seq[idx] * multForOre)
    local itemClass = seq.item
    local itemData = gRust.Items[itemClass]
    local itemName = itemData and itemClass
    ply:GiveItem(seq.item, reward)
    ply:SendNotification(itemName, NOTIFICATION_PICKUP, "materials/icons/pickup.png", "+" .. reward)

     if ent.oreHealth <= 0 then
        local pos = ent:GetPos()
        ent:Remove()
        timer.Simple(math.random(300, 600), function()
            local e = ents.Create("rust_ore")
            if IsValid(e) then
                e:SetPos(pos)
                e:SetSkin(math.random(1, 3))
                e:Spawn()
                e:Activate()
            end
        end)
    end
end
