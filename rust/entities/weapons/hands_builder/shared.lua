AddCSLuaFile()
if CLIENT then
    SWEP.Author = "TheFreeCode"
    SWEP.Slot = 3
    SWEP.SlotPos = 0
    SWEP.IconLetter = "b"
    killicon.AddFont("hands_builder", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

SWEP.PrintName = "Builder"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Category = "gRust"
SWEP.UseHands = true
SWEP.ViewModel = ""
SWEP.WorldModel = "models/darky_m/rust/w_buildingplan.mdl"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.HoldType = "ar2"
SWEP.LoweredHoldType = "passive"
SWEP.Primary.Sound = Sound("Weapon_AK47.Single")
SWEP.Primary.Recoil = 1.5
SWEP.Primary.Damage = 40
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.002
SWEP.Primary.ClipSize = 30
SWEP.Primary.Delay = 0.08
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IronSightsPos = Vector(-6.6, -15, 2.6)
SWEP.IronSightsAng = Vector(2.6, -1, 0)
SWEP.HasIron = false
SWEP.DrawAmmo = false
function SWEP:Initialize()
    self:SetHoldType("melee")
end

if SERVER then net.Receive("gRust_ServerModel", function(len, ply) ply.Selected = net.ReadString() end) end
local Valid = {}
local function IsFloatingStrict(ent)
    local mins, maxs = ent:OBBMins(), ent:OBBMaxs()
    local corners = {Vector(mins.x, mins.y, mins.z), Vector(mins.x, maxs.y, mins.z), Vector(maxs.x, mins.y, mins.z), Vector(maxs.x, maxs.y, mins.z),}
    for _, offset in ipairs(corners) do
        local start = ent:LocalToWorld(offset + Vector(0, 0, 2))
        local tr = util.TraceLine({
            start = start,
            endpos = start - Vector(0, 0, 8),
            filter = ent
        })

        if tr.Hit then
            return false -- touching something
        end
    end
    return true -- all corners floating
end

if SERVER then
    hook.Add("Think", "NoFloatingProps", function(ply)
        for k, ent in pairs(ents.FindByClass("sent_foundation")) do
            if IsFloatingStrict(ent) then
                ent:Remove() -- or freeze, or snap-to-ground, etc.
            end
        end
    end)
end

function SWEP:PrimaryAttack()
    if not SERVER then return end
    self:SetNextPrimaryFire(CurTime() + 0.4)
    local ply = self:GetOwner()
    local eyet = ply:GetEyeTrace()
    local Position = math.Round(360 - ply:GetAngles().y % 360)
    local nearEnt = nil
    local tblOfEnts = {}
    for k, v in pairs(ents.FindByClass("sent_foundation")) do
        if v:GetPos():Distance(ply:GetPos()) <= 120 then tblOfEnts[#tblOfEnts + 1] = v end
    end

    local itemz = ITEMS:GetItem("Wood")
    local bool = false
    for k, v in pairs(itemz:Craft()) do
        -- bool = ply:TakeItem(v[k].ITEM, 25)
    end

    --if not bool then return end
    local canPlace = false
    nearEnt = tblOfEnts[1]
    local entOnGround = nearEnt --or ply:GetGroundEntity()
    local twig = ents.Create(ply.Selected ~= nil and ply.Selected or "sent_foundation")
    self.Pos = nil
    if not IsValid(twig) then return end
    if nearEnt ~= game.GetWorld() and IsValid(twig) and entOnGround and IsValid(entOnGround) then
        self.Pos, self.Ang = Rust.Nests[ply.Selected ~= nil and ply.Selected or "sent_foundation"].Pos(Position, entOnGround)
        --self.Pos, self.Ang = Rust.Nests[Rust.Selected ~= nil and Rust.Selected or "sent_foundation"].Pos(Position, entOnGround)
        canPlace = true
    else
        self.Pos, self.Ang = ply:GetEyeTrace().HitPos + ply:GetEyeTrace().HitNormal * 32 + ply:GetForward() * 32 + ply:GetUp() * 12, Angle(0, 0, 0)
        canPlace = true
    end

    if self.Pos then twig:SetPos(self.Pos) end
    if self.Ang then twig:SetAngles(self.Ang) end
    if self.Pos and entOnGround and IsValid(entOnGround) then
        for k, v in pairs(ents.FindInSphere(self.Pos, 3)) do
            if not v then
                Valid[k] = nil
                canPlace = false
            end
        end
    else
        canPlace = true
    end

    local countEnt = 0
    for i = 1, #Valid do
        if IsValid(Valid[i]) then
            for k, v in pairs(ents.FindInSphere(Valid[i]:GetPos(), 10)) do
                if twig == v and v:GetClass() == "sent_foundation" then countEnt = countEnt + 1 end
            end
        end
    end

    if countEnt > 0 then canPlace = false end
    if ply:GetPos():Distance(ply:GetEyeTrace().HitPos) >= 130 and ply.Selected == "sent_foundation" then canPlace = false end
    if canPlace == false then
        ply:EmitSound("common/wpn_denyselect.wav")
        return
    end

    --twig:SetAngles(Angle(0, self:GetAngles(), 0))
    twig:Spawn()
    twig:Activate()
    ply:EmitSound("building/hammer_saw_1.wav")
    if not table.HasValue(Valid, twig) then
        Valid[#Valid + 1] = twig
        net.Start("Rust_TableValid")
        net.WriteTable(Valid)
        net.Send(ply)
    end

    constraint.Weld(twig, Entity(0), 0, 0, 0, false, false)
end

function SWEP:SecondaryAttack()
    if self:GetOwner():IsPlayer() then self:GetOwner():LagCompensation(true) end
    self:SetNextSecondaryFire(CurTime() + 1)
    self:GetOwner():ConCommand("+azrm_showmenu")
    if self:GetOwner():IsPlayer() then self:GetOwner():LagCompensation(false) end
end

if CLIENT then
    hook.Add("Think", "whatamidoing", function()
        if not IsValid(LocalPlayer()) then return end
        local wep = LocalPlayer():GetActiveWeapon()
        if not IsValid(wep) then return end
        if wep:GetClass() ~= "hands_builder" then
            if IsValid(Rust.GhostEntity) then
                Rust.GhostEntity:Remove()
                Rust.GhostEntity = nil
            end
            return
        end
    end)

    function SWEP:DrawHUD()
    end

    local tbl = {}
    net.Receive("Rust_TableValid", function() tbl = net.ReadTable() end)
    function SWEP:Think()
        if SERVER then return end
        if not IsFirstTimePredicted() then return end
        if Rust.Selected == nil then
            Rust.GhostEntity:Remove()
            Rust.GhostEntity = nil
        end

        if not IsValid(Rust.GhostEntity) then
            Rust.GhostEntity = ents.CreateClientProp()
            print(Rust.Selected)
            Rust.GhostEntity:Spawn()
        end

        Rust.GhostEntity:SetModel(Rust.Nests[Rust.Selected].Model)
        local ply = self:GetOwner()
        if not IsValid(ply) then return end
        local Position = math.Round(360 - ply:GetAngles().y % 360)
        local nearEnt = nil
        local tblOfEnts = {}
        for k, v in pairs(ents.FindByClass("sent_foundation")) do
            if v:GetPos():Distance(ply:GetPos()) <= 120 then tblOfEnts[#tblOfEnts + 1] = v end
        end

        nearEnt = tblOfEnts[1]
        local entOnGround = nearEnt
        if nearEnt ~= game.GetWorld() and IsValid(Rust.GhostEntity) and entOnGround and IsValid(entOnGround) then
            self.Pos, self.Ang = Rust.Nests[Rust.Selected ~= nil and Rust.Selected or "sent_foundation"].Pos(Position, entOnGround)
        else
            self.Pos, self.Ang = ply:GetEyeTrace().HitPos + ply:GetEyeTrace().HitNormal * 32 + ply:GetForward() * 32 + ply:GetUp() * 12, Angle(0, 0, 0)
        end

        if self.Pos then Rust.GhostEntity:SetPos(self.Pos) end
        if self.Ang then Rust.GhostEntity:SetAngles(self.Ang) end
        if IsFloatingStrict(Rust.GhostEntity) then
            Rust.GhostEntity:SetColor(Color(255, 0, 0, 255))
        else
            Rust.GhostEntity:SetColor(Color(47, 47, 255))
        end
    end
end