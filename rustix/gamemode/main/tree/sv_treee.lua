util.AddNetworkString("gRust_Amount")
util.AddNetworkString("gRust.TreeEffects")
local function BackwardsEnums(enumname)
    local backenums = {}
    for k, v in pairs(_G) do
        if isstring(k) and string.find(k, "^" .. enumname) then backenums[v] = k end
    end
    return backenums
end

local meta = FindMetaTable("Player")
function meta:SendNotifyMsgLang(lang, amount)
    net.Start("gRust_Amount")
    net.WriteString(lang)
    net.WriteFloat(amount)
    net.Send(self)
end

function meta:NotifyWood(amount)
    self:SendNotifyMsgLang("WoodReceive", amount)
end

local function SendTreeHit(ply, ent)
    if ent == nil then
        net.Start("gRust.TreeEffects")
        net.WriteVector(Vector())
        net.WriteAngle(Angle())
        net.WriteEntity(nil)
        net.Broadcast()
        return
    end

    local tr = ply:GetEyeTrace()
    if not tr.Hit or tr.Entity ~= ent then return end
    local hitPos = tr.HitPos
    local radius = 1
    local randomOffset = VectorRand() * radius
    randomOffset.x = math.Rand(-5, 5)
    randomOffset.y = math.random(-1, 1)
    hitPos = hitPos + randomOffset
    if ent.LastPos == nil then ent.LastPos = hitPos end
    local dist = tr.HitPos:Distance(ent.LastPos)
    if not ent.NoMarker then
        ent.HotspotPos = hitPos
        ent.LastPos = hitPos
        net.Start("gRust.TreeEffects")
        net.WriteVector(ent.LastPos)
        net.WriteAngle(Angle(ply:GetAngles().x, ply:GetAngles().y, ply:GetAngles().z))
        net.WriteEntity(ent)
        net.Broadcast()
        ent.NoMarker = true
    end

    if dist <= 10 then
        ent.HotspotPos = hitPos
        ent.LastPos = hitPos
        net.Start("gRust.TreeEffects")
        net.WriteVector(ent.LastPos)
        net.WriteAngle(Angle(ply:GetAngles().x, ply:GetAngles().y, ply:GetAngles().z))
        net.WriteEntity(ent)
        net.Broadcast()
    end
end

local function MakeTreeFall(ent)
    if not IsValid(ent) then return end
    local treePos = ent:GetPos() -- Store tree information for respawn
    local treeAngles = ent:GetAngles()
    local treeModel = ent:GetModel()
    ent:SetMoveType(MOVETYPE_VPHYSICS) -- Convert to physics object and make it fall
    ent:SetSolid(SOLID_VPHYSICS) -- Keep solid for world collision
    ent:PhysicsInit(SOLID_VPHYSICS)
    ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS) -- Don't collide with players but still with world
    local phys = ent:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:SetMass(800) -- Realistic tree weight
        local fallDirection = Angle(0, math.random(0, 360), 0):Forward() -- Choose a random direction to fall (like wind direction)
        fallDirection.z = 0 -- Keep it horizontal
        fallDirection:Normalize()
        local torque = Vector(fallDirection.y, -fallDirection.x, 0) * 3000 -- Apply torque to make it tip over from the base (like a real tree)
        phys:ApplyTorqueCenter(torque)
        local push = fallDirection * 100 -- Small initial push in the fall direction
        push.z = -50 -- Slight downward force
        phys:ApplyForceCenter(push)
        phys:SetMass(800) -- Set the tree's center of mass higher to make it tip more naturally
    end

    ent.treeFallen = true
    timer.Simple(3, function()
        if IsValid(ent) then -- Start transparency fade after 3 seconds (give more time to see the fall)
            local alpha = 255
            local fadeTimer = "tree_fade_" .. ent:EntIndex()
            timer.Create(fadeTimer, 0.1, 40, function()
                if IsValid(ent) then -- Slower fade (4 seconds)
                    alpha = alpha - 6.375 -- Fade over 4 seconds (40 * 0.1 = 4s)
                    ent:SetColor(Color(255, 255, 255, math.max(0, alpha)))
                    ent:SetRenderMode(RENDERMODE_TRANSALPHA)
                    if alpha <= 0 then
                        timer.Remove(fadeTimer)
                        ent:Remove()
                    end
                else
                    timer.Remove(fadeTimer)
                end
            end)
        end
    end)

    timer.Simple(math.random(600, 900), function()
        local newTree = ents.Create("rust_trees") -- Respawn tree after 10-15 minutes
        if IsValid(newTree) then
            newTree:SetModel(treeModel)
            newTree:SetPos(treePos)
            newTree:SetAngles(treeAngles)
            newTree:Spawn()
            newTree:Activate()
            newTree.treeHealth = nil -- Reset tree health so it can be chopped again
            newTree.treeHits = nil
            newTree.treeFallen = false
        end
    end)
end

local WOOD_WEAPONS = {
    ["tfa_rustalpha_rocktool"] = {
        mult = 1
    },
    ["rust_stonehatchet"] = {
        mult = 1.3
    },
    ["rust_hatchet"] = {
        mult = 1.8
    }
}

local TREE_MODELS = {
    ["models/props_foliage/ah_super_large_pine002.mdl"] = 220,
    ["models/props_foliage/ah_large_pine.mdl"] = 190,
    ["models/props/cs_militia/tree_large_militia.mdl"] = 140,
    ["models/props_foliage/ah_medium_pine.mdl"] = 220,
    ["models/brg_foliage/tree_scotspine1.mdl"] = 160,
    ["models/props_foliage/ah_super_pine001.mdl"] = 180,
    ["models/props_foliage/ah_ash_tree001.mdl"] = 190,
    ["models/props_foliage/ah_ash_tree_cluster1.mdl"] = 140,
    ["models/props_foliage/ah_ash_tree_med.mdl"] = 170,
    ["models/props_foliage/ah_hawthorn_sm_static.mdl"] = 150,
    ["models/props_foliage/coldstream_cedar_trunk.mdl"] = 170,
    ["models/props_foliage/ah_ash_tree_lg.mdl"] = 190
}

local WOOD_SEQ = {6, 14, 22, 32, 43, 55, 68, 83, 99, 128}
hook.Add("EntityTakeDamage", "TakeWoodDmg", function(ent, dmginfo)
    local MAT = BackwardsEnums("MAT_")
    local ply = dmginfo:GetAttacker()
    if not IsValid(ply) then return end
    local wep = ply:GetActiveWeapon() --if not IsValid(ply) then return end
    if not IsValid(wep) then return end
    local found = string.find(wep:GetClass(), "hatchet") or string.find(wep:GetClass(), "pickaxe") or string.find(wep:GetClass(), "rock")
    if ent.treeFallen == nil then ent.treeFallen = false end
    if found and MAT[ent:GetMaterialType()] == "MAT_WOOD" and ent.treeFallen == false then
        if not ply:IsPlayer() then return end
        local class = wep:GetClass()
        if not class then return end
        local tool = WOOD_WEAPONS[class]
        local maxHP = TREE_MODELS[ent:GetModel()]
        if not ent.treeHealth then ent.treeHealth, ent.treeHits = maxHP, 0 end
        if ent.treeHealth == nil then return end
        ent.treeHealth, ent.treeHits = ent.treeHealth - 20, ent.treeHits + 1
        local idx = math.min(ent.treeHits, #WOOD_SEQ)
        local reward = math.Round(WOOD_SEQ[idx] * tool.mult)
        ply:SendNotification("Wood", NOTIFICATION_PICKUP, "materials/icons/pickup.png", "+" .. reward)
        PickleAdillyEdit(ply, "Wood", 300)
        if ent.treeHealth <= 0 then
            SendTreeHit(ply, nil)
            MakeTreeFall(ent)
            return
        end

        SendTreeHit(ply, ent)
    end

    if ent:GetClass() == "sent_rocks" then end
end)