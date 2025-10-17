AddCSLuaFile()
SWEP.ViewModel = "models/weapons/darky_m/rust/c_ak47u.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_ak47u.mdl"
SWEP.DrawCrosshair = false
SWEP.UseHands = true
SWEP.Automatic = false
function SWEP:Initialize()
    self:SetHoldType("smg")
    self.delay = 0
    self.Clicked = false
end

function SWEP:PrimaryAttack()
    local pl = self:GetOwner()
    if not IsValid(pl) then return end
    pl:SetAnimation(PLAYER_ATTACK1)
    self:EmitSound("tools/rock_swing.mp3")
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    self.delay = CurTime() + 0.5
    self:SetNextPrimaryFire(CurTime() + 0.2)
    local tr = pl:GetEyeTrace()
    self.Clicked = true
    local bullet = {}
    bullet.Num = 1
    bullet.Src = pl:GetShootPos()
    bullet.Dir = pl:GetForward()
    bullet.Spread = Vector(0.01, 0.01, 0)
    bullet.Tracer = 1
    bullet.Force = 2
    bullet.Damage = 25
    pl:FireBullets(bullet)
end

function SWEP:Think()
end

function SWEP:SecondaryAttack()
end