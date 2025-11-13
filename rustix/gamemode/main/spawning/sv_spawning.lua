-- Spawning System for gRust
-- Handles spawning of all entities on the map
local SpawningSystem = {}
-- Configuration
local SPAWN_DELAY = 5 -- Seconds to wait after map load
CreateConVar("gr_spawnsystem_creatures", "90", {FCVAR_ARCHIVE}, "Chickens that spawn")
CreateConVar("gr_spawnsystem_ores", "150", {FCVAR_ARCHIVE}, "Ores that spawn")
CreateConVar("gr_spawnsystem_hemp", "90", {FCVAR_ARCHIVE}, "Hemp that spawn")
CreateConVar("gr_spawnsystem_ore_pickups", "80", {FCVAR_ARCHIVE}, "Ore pickups that spawn")
local trees = 300
local creatureSpawns = GetConVar("gr_spawnsystem_creatures"):GetInt() * 2.5
local oreSpawns = GetConVar("gr_spawnsystem_ores"):GetInt() * 2.5
local hempSpawns = GetConVar("gr_spawnsystem_hemp"):GetInt() * 2.5
local orePickupSpawns = GetConVar("gr_spawnsystem_ore_pickups"):GetInt() * 2.5
-- Predefined spawn positions
-- Find random valid positions on the map
local function FindRandomPlacesOnMap(count)
    local positions = {}
    local attempts = 0
    local maxAttempts = count * 5
    while #positions < count and attempts < maxAttempts do
        attempts = attempts + 1
        local pos = Vector(math.Rand(-34000, 34000), math.Rand(-34000, 34000), 5000)
        local tr = util.TraceLine({
            start = pos,
            endpos = pos - Vector(0, 0, 10000),
            mask = MASK_SOLID_BRUSHONLY
        })

        if table.HasValue(positions, tr.HitPos + Vector(0, 0, 10)) then return end
        if tr.Hit and tr.HitPos.z > 50 and tr.HitPos.z < 1000 then table.insert(positions, tr.HitPos + Vector(0, 0, 10)) end
    end
    return positions
end

local function FindRandomPlacesOnMapRS(count)
    local positions = {}
    local attempts = 0
    local maxAttempts = count * 5
    for k, v in pairs(ents.GetAll()) do
        if util.GetSurfaceData(k) ~= nil and util.GetSurfaceData(k).material == 67 then table.insert(positions, v:GetPos()) end
    end

    while #positions < count and attempts < maxAttempts do
        attempts = attempts + 1
        local pos = Vector(math.Rand(-14000, 14000), math.Rand(-14000, 14000), 5000)
        local tr = util.TraceLine({
            start = pos,
            endpos = pos - Vector(0, 0, 10000),
            mask = MASK_SOLID_BRUSHONLY
        })

        if tr.Hit and tr.HitPos.z > 50 and tr.HitPos.z < 1000 then table.insert(positions, tr.HitPos + Vector(0, 0, 10)) end
    end
    return positions
end

concommand.Add("spawn_ore", function(ply)
    if not ply:IsAdmin() then return end
    local ent = ents.Create("rust_ores_spawn")
    if IsValid(ent) then
        local tbl = {
            [1] = "models/darky_m/rust/worldmodels/metal_ore.mdl",
            [2] = "models/darky_m/rust/worldmodels/sulfur_ore.mdl",
            [3] = "models/darky_m/rust/worldmodels/stone.mdl",
        }

        ent:SetModel("models/environment/ores/ore_node_stage1.mdl") --tbl[math.random(1, 3)])
        ent:SetPos(ply:GetEyeTrace().HitPos + ply:GetEyeTrace().HitNormal * 32)
        ent:SetSkin(math.random(1, 3))
        ent:Spawn()
        ent:Activate()
        ent:DropToFloor()
    end
end)

-- Spawn rocks/ore nodes
function SpawningSystem.SpawnRocks()
    local positions = FindRandomPlacesOnMap(oreSpawns)
    local spawnedCount = 0
    for _, pos in pairs(positions) do
        if not isvector(pos) then continue end
        local lowerPos = pos - Vector(0, 0, 20)
        local ent = ents.Create("rust_ores")
        if IsValid(ent) then
            ent:SetModel("models/environment/ores/ore_node_stage1.mdl")
            ent:SetPos(lowerPos)
            ent:SetSkin(math.random(1, 3))
            ent:Spawn()
            ent:Activate()
            ent:DropToFloor()
            spawnedCount = spawnedCount + 1
        end
    end

    Logger("[Spawning] Spawned " .. spawnedCount .. " rocks")
end

-- Spawn chickens
function SpawningSystem.SpawnChickens()
    local positions = FindRandomPlacesOnMap(creatureSpawns)
    local spawnedCount = 0
    for _, pos in pairs(positions) do
        local ent = ents.Create("sent_chicken")
        if IsValid(ent) then
            ent:SetPos(pos)
            ent:Spawn()
            ent:Activate()
            ent:SetModelScale(1.75, 0)
            ent:DropToFloor()
            spawnedCount = spawnedCount + 1
        end
    end

    Logger("[Spawning] Spawned " .. spawnedCount .. " chickens")
end

function SpawningSystem.SpawnTrees()
    local positions = FindRandomPlacesOnMap(trees)
    local spawnedCount = 0
    for _, pos in pairs(positions) do
        local ent = ents.Create("rust_trees")
        if IsValid(ent) then
            ent:SetPos(pos - Vector(0, 0, 50))
            ent:Spawn()
            ent:Activate()
            ent:SetModelScale(1.75, 0)
            ent:DropToFloor()
            spawnedCount = spawnedCount + 1
            local trace = util.TraceLine({
                start = ent:GetPos(),
                endpos = ent:GetPos() - Vector(0, 0, 1000), -- Trace 1000 units downwards
                filter = ent -- Filter out the entity so it doesn't hit itself
            })

            local floorNormal = trace.HitNormal
            local alignedAngles = Vector(1, 0, 0):AngleEx(floorNormal)
            ent:SetAngles(alignedAngles)
        end
    end

    Logger("[Spawning] Spawned " .. spawnedCount .. " Trees")
end

-- Spawn hemp plants
function SpawningSystem.SpawnHemp()
    local positions = FindRandomPlacesOnMap(hempSpawns)
    local spawnedCount = 0
    local pairCount = 0
    for _, pos in ipairs(positions) do
        local lowerPos = pos - Vector(0, 0, 10)
        local ent = ents.Create("rust_map_hemp")
        if IsValid(ent) then
            ent:SetPos(lowerPos)
            ent:Spawn()
            ent:Activate()
            ent:DropToFloor()
            spawnedCount = spawnedCount + 1
            if math.random(1, 100) <= 30 then
                local offset = Vector(math.random(-80, 80), math.random(-80, 80), 0)
                local nearbyPos = lowerPos + offset
                local ent2 = ents.Create("rust_map_hemp")
                if IsValid(ent2) then
                    ent2:SetPos(nearbyPos)
                    ent2:Spawn()
                    ent2:Activate()
                    ent2:DropToFloor()
                    spawnedCount = spawnedCount + 1
                    pairCount = pairCount + 1
                end
            end
        end
    end

    Logger("[Spawning] Spawned " .. spawnedCount .. " hemp plants (" .. pairCount .. " pairs)")
end

function SpawningSystem.SpawnOrePickups()
    local positions = FindRandomPlacesOnMap(orePickupSpawns)
    local spawnedCount = 0
    for _, pos in pairs(positions) do
        if not isvector(pos) then continue end
        local lowerPos = pos - Vector(0, 0, 15)
        local ent = ents.Create("rust_orespickup")
        if IsValid(ent) then
            ent:SetPos(lowerPos)
            ent:SetSkin(math.random(1, 3))
            ent:Spawn()
            ent:Activate()
            ent:DropToFloor()
            spawnedCount = spawnedCount + 1
        end
    end

    Logger("[Spawning] Spawned " .. spawnedCount .. " ore pickups")
end

-- Spawn roadsigns
function SpawningSystem.SpawnRoadSigns()
    local spawnedCount = 0
    local failedCount = 0
    local RoadSignSpawns = FindRandomPlacesOnMapRS(80)
    for i, spawn in ipairs(RoadSignSpawns) do
        local roadsign = ents.Create("rust_roadsign")
        if IsValid(roadsign) then
            roadsign:SetPos(spawn)
            roadsign:SetAngles(Angle(0, 0, 0))
            roadsign:Spawn()
            roadsign:Activate()
            roadsign:DropToFloor()
            spawnedCount = spawnedCount + 1
        else
            failedCount = failedCount + 1
        end
    end

    Logger("[Spawning] Roadsign spawning complete: " .. spawnedCount .. " spawned, " .. failedCount .. " failed")
end

local Recycler_SP = {{Vector(-4237.077148, 13651.231445, -234.182861), Angle(0.000, 0, 0.000)}, {Vector(-4452.064941, 11656.745117, -243.682877), Angle(0, 80, 0)}, {Vector(12810.703125, 3340.973145, 333.512268), Angle(0, -180, 0)}, {Vector(4762.88574, -7834.901855, -437.055786), Angle(0, 0, 0)}, {Vector(-10202.130859, 4582.346191, -11.468750), Angle(0, -90, 0)}}
function SpawningSystem.SpawnRecyclers()
    local spawnedCount = 0
    local failedCount = 0
    for i, spawn in ipairs(Recycler_SP) do
        local Recycler = ents.Create("rust_recycler")
        if IsValid(Recycler) then
            Recycler:SetPos(spawn[1])
            Recycler:SetAngles(spawn[2])
            Recycler:Spawn()
            Recycler:Activate()
            Recycler:DropToFloor()
            spawnedCount = spawnedCount + 1
        else
            failedCount = failedCount + 1
        end
    end

    Logger("[Spawning] Recycler spawning complete: " .. spawnedCount .. " spawned, " .. failedCount .. " failed")
end

-- Main spawning function
function SpawningSystem.SpawnAll()
    Logger("[Spawning] Starting entity spawning on map: " .. game.GetMap())
    
    SpawningSystem.SpawnTrees()
    timer.Simple(1, function() SpawningSystem.SpawnChickens() end)
    timer.Simple(2, function() SpawningSystem.SpawnHemp() end)
    timer.Simple(3, function() SpawningSystem.SpawnRoadSigns() end)
    timer.Simple(4, function() SpawningSystem.SpawnOrePickups() end)
    timer.Simple(4.5, function() SpawningSystem.SpawnRecyclers() end)
    timer.Simple(6, function() SpawningSystem.SpawnRocks() end)
    timer.Simple(5, function() Logger("[Spawning] All entity spawning completed!") end)
end

-- Initialize spawning system
hook.Add("InitPostEntity", "gRust.SpawningSystem", function() timer.Simple(SPAWN_DELAY, function() SpawningSystem.SpawnAll() end) end)
gRust.SpawningSystem = SpawningSystem
-- Add console command for manual spawning (admin only)
concommand.Add("grust_spawn_all", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    SpawningSystem.SpawnAll()
end)

Logger("Spawning system loaded")