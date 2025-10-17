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

local Valid = {}
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

    local canPlace = false
    nearEnt = tblOfEnts[1]
    local entOnGround = nearEnt --or ply:GetGroundEntity()
    local twig = ents.Create("sent_foundation")
    self.Pos = nil
    if not IsValid(twig) then return end
    if nearEnt ~= game.GetWorld() and IsValid(entOnGround) then
        if Position >= 1 and Position <= 40 or Position >= 320 and Position <= 360 then
            self.Pos = Vector(entOnGround:GetPos().x - entOnGround:OBBMins().x + 60, entOnGround:GetPos().y, entOnGround:GetPos().z)
            Angl = 0
            canPlace = true
        elseif Position > 50 and Position < 120 then
            self.Pos = Vector(entOnGround:GetPos().x, entOnGround:GetPos().y + entOnGround:OBBMins().y - 60, entOnGround:GetPos().z)
            canPlace = true
            Angl = 270
        elseif Position > 146 and Position < 217 then
            self.Pos = Vector(entOnGround:GetPos().x + entOnGround:OBBMins().x - 60, entOnGround:GetPos().y, entOnGround:GetPos().z)
            canPlace = true
            Angl = 0
        elseif Position > 234 and Position < 310 then
            self.Pos = Vector(entOnGround:GetPos().x, entOnGround:GetPos().y - entOnGround:OBBMins().y + 60, entOnGround:GetPos().z)
            canPlace = true
            Angl = 270
        end
    else
        twig:SetPos(ply:GetEyeTrace().HitPos)
        canPlace = true
        Angl = 0
    end

    if self.Pos then twig:SetPos(self.Pos) end
    if self.Pos then
        for k, v in pairs(ents.FindInSphere(self.Pos, 3)) do
            if not v then
                Valid[k] = nil
                canPlace = false
            end
        end
    end

    local countEnt = 0
    for i = 1, #Valid do
        if IsValid(Valid[i]) then
            for k, v in pairs(ents.FindInSphere(Valid[i]:GetPos(), 10)) do
                if twig == v and v:GetClass() == "sent_foundation" then
                    countEnt = countEnt + 1
                end
            end
        end
    end

    if countEnt > 0 then canPlace = false end
    if ply:GetPos():Distance(ply:GetEyeTrace().HitPos) >= 150 then canPlace = false end
    if canPlace == false then
        ply:EmitSound("common/wpn_denyselect.wav")
        return
    end

    twig:SetAngles(Angle(0, self:GetAngles(), 0))
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
    if twig:GetPos():Distance(ply:GetPos()) > 150 then twig:Remove() end
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
        if Rust.GhostEntity == nil and Rust.Nests[Rust.Selected] ~= nil then Rust.GhostEntity = ents.CreateClientProp(Rust.Nests[Rust.Selected].Model) end
        if not IsValid(Rust.GhostEntity) then
            Rust.GhostEntity = nil
            return
        end

        if not IsValid(Rust.GhostEntity) then return end
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
            if Position >= 1 and Position <= 40 or Position >= 320 and Position <= 360 then
                self.Pos = Vector(entOnGround:GetPos().x - entOnGround:OBBMins().x + 60, entOnGround:GetPos().y, entOnGround:GetPos().z)
                Rust.GhostEntity:SetPos(self.Pos)
            elseif Position > 50 and Position < 120 then
                self.Pos = Vector(entOnGround:GetPos().x, entOnGround:GetPos().y + entOnGround:OBBMins().y - 60, entOnGround:GetPos().z)
                Rust.GhostEntity:SetPos(self.Pos)
            elseif Position > 146 and Position < 217 then
                self.Pos = Vector(entOnGround:GetPos().x + entOnGround:OBBMins().x - 60, entOnGround:GetPos().y, entOnGround:GetPos().z)
                Rust.GhostEntity:SetPos(self.Pos)
            elseif Position > 234 and Position < 310 then
                self.Pos = Vector(entOnGround:GetPos().x, entOnGround:GetPos().y - entOnGround:OBBMins().y + 60, entOnGround:GetPos().z)
                Rust.GhostEntity:SetPos(self.Pos)
            end
        else
            Rust.GhostEntity:SetPos(ply:GetEyeTrace().HitPos)
        end

        Rust.GhostEntity:Spawn()
        Rust.GhostEntity:PhysicsDestroy()
        Rust.GhostEntity:SetMoveType(MOVETYPE_NONE)
        Rust.GhostEntity:SetNotSolid(true)
        for i = 1, #tbl do
            if ply:GetPos():Distance(ply:GetEyeTrace().HitPos) >= 150 or tbl[i] == Rust.GhostEntity:GetPos() then
                Rust.GhostEntity:SetColor(Color(255, 0, 0, 255))
                return
            else
                Rust.GhostEntity:SetColor(Color(47, 47, 255))
                return
            end
        end
    end
end