local ORE_WEAPONS = {
    ["rust_wrock"] = {
        ["Metal Ore"] = 1,
        ["Sulfur Ore"] = 1,
        ["Stone"] = 1
    },
    ["tfa_rustalpha_stone_hatchet"] = {
        ["Metal Ore"] = 1.94,
        ["Sulfur Ore"] = 2.57,
        ["Stone"] = 2.11733
    },
    ["tfa_rustalpha_pickaxe"] = {
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
gRust.Mining.IsValidMiningTool = function(weaponClass) return ORE_WEAPONS[weaponClass] ~= nil end
local function GenerateTopWeakspot(ent)
    local mins, maxs = ent:OBBMins(), ent:OBBMaxs()
    for i = 1, 50 do -- up to 50 attempts
        local lx = math.Rand(mins.x, maxs.x)
        local ly = math.Rand(mins.y, maxs.y)
        -- Start WELL above the rock
        local start = ent:LocalToWorld(Vector(lx, ly, maxs.z + 50))
        local finish = ent:LocalToWorld(Vector(lx, ly, mins.z - 10))
        local tr = util.TraceLine({
            start = start,
            endpos = finish,
            filter = ent
        })

        if tr.Hit then
            -- Only accept surfaces facing upward
            if tr.HitNormal.z > 0.5 then return ent:WorldToLocal(tr.HitPos) end
        end
    end
    return nil
end

gRust.Mining.MineOres = function(ply, ent, weapon, class, dmg)
    if not ply.Wood_Cutting_Tool then ply.Wood_Cutting_Tool = 0 end
    if ply.Wood_Cutting_Tool > CurTime() then return end
    ply.Wood_Cutting_Tool = CurTime() + 0.2
    local tool = ORE_WEAPONS[class]
    if not tool then return end
    local seq = ORE_SEQ[ent:GetSkin()] or ORE_SEQ[1]
    if not ent.oreHealth then ent.oreHealth, ent.oreHits = #seq.seq, 0 end
    ent.oreHealth, ent.oreHits = ent.oreHealth - 1, ent.oreHits + 1
    local idx = math.min(ent.oreHits, #seq.seq)
    local multForOre = tool[seq.item] or 1
    local reward = math.Round(seq.seq[idx] * multForOre)
    local itemClass = seq.item
    local itemData = ITEMS:GetItem(itemClass)
    local itemName = itemData and itemData.Name
    if ent.AttacksRock == nil then ent.AttacksRock = 0 end
    ent.AttacksRock = ent.AttacksRock + 10
    if ent.AttacksRock >= 50 then
        ent:SetModel("models/environment/ores/ore_node_stage2.mdl")
        ent:EmitSound("tools/rock_strike_1.mp3")
    end

    if ent.AttacksRock >= 80 then
        ent:SetModel("models/environment/ores/ore_node_stage3.mdl")
        ent:EmitSound("tools/rock_strike_1.mp3")
    end

    local mins, maxs = ent:OBBMins(), ent:OBBMaxs()
    -- pick the top-center of the model
    local localPos = Vector((mins.x + maxs.x) * 0.5, (mins.y + maxs.y) * 0.5, maxs.z)
    -- top face
    -- convert to world space
    local worldPos = ent:LocalToWorld(localPos)
    ent:SetNW2Vector("Weakspot", worldPos)
    local weakspot = ent:LocalToWorld(worldPos)
    local hitpos = ply:GetEyeTrace().HitPos
    local dist = hitpos:Distance(worldPos)
    if dist < 20 then
        ent:EmitSound("farming/flare_hit.wav")
        ply:GiveItem(seq.item, reward * 2, seq.item)
    else
        ply:GiveItem(seq.item, reward, seq.item)
    end

    if ent.oreHealth <= 0 then
        ent:EmitSound("tools/rock_strike_1.mp3")
        local pos = ent:GetPos()
        ent:Remove()
        timer.Simple(math.random(300, 600), function()
            local e = ents.Create("rust_ores")
            if IsValid(e) then
                e:SetPos(pos)
                e:SetSkin(math.random(1, 3))
                e:Spawn()
                e:Activate()
            end
        end)
    end
end