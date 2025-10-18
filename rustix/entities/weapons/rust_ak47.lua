AddCSLuaFile()
SWEP.ViewModel = "models/weapons/darky_m/rust/c_ak47u.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_ak47u.mdl"
SWEP.DrawCrosshair = false
SWEP.UseHands = true
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 120
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Ammo = "AK47_AMMO"
function SWEP:Initialize()
    self:SetHoldType("smg")
    self.delay = 0
    self.Clicked = false
    if SERVER then
        local pl = self:GetOwner()
        if IsValid(pl) then
            pl:GiveAmmo(120, self.Primary.Ammo, true)
            print(self.Primary.Ammo)
        end
    end
end

function SWEP:PrimaryAttack()
    local pl = self:GetOwner()
    if not IsValid(pl) then return end
    pl:SetAnimation(PLAYER_ATTACK1)
    self:EmitSound("weapons/rust_distant/ak74u-attack.mp3")
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    self.delay = CurTime() + 0.5
    self:SetNextPrimaryFire(CurTime() + 0.15)
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
    local fx = EffectData()
    fx:SetEntity(self)
    fx:SetOrigin(pl:GetShootPos())
    fx:SetNormal(pl:GetAimVector())
    fx:SetAttachment("1")
    util.Effect("muzzleflash", fx)
end

function SWEP:Think()
end

function SWEP:SecondaryAttack()
end