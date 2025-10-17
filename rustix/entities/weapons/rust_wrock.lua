AddCSLuaFile()
SWEP.ViewModel = "models/weapons/darky_m/rust/c_rock.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_rock.mdl"
SWEP.DrawCrosshair = false
SWEP.UseHands = true
SWEP.Automatic = false
function SWEP:Initialize()
    self:SetHoldType("melee")
    self.delay = 0
    self.Clicked = false
end

function SWEP:PrimaryAttack()
    local pl = self:GetOwner()
    if not IsValid(pl) then return end
    pl:SetAnimation(PLAYER_ATTACK1)
    self:EmitSound("tools/rock_swing.mp3")
    self:SendWeaponAnim(ACT_VM_SWINGMISS)
    self.delay = CurTime() + 0.5
    self:SetNextPrimaryFire(CurTime() + 1)
    local tr = pl:GetEyeTrace()
    self.Clicked = true
end

function SWEP:Think()
    local pl = self:GetOwner()
    if not IsValid(pl) then return end
    if self.delay < CurTime() then
        self.delay = CurTime() + 0.5
        local tr = {
            start = pl:EyePos(),
            endpos = pl:EyePos() + pl:GetAimVector() * 30
        }

        tr = util.TraceHull(tr)
        if tr.HitPos:Distance(pl:GetEyeTrace().HitPos) <= 120 and self.Clicked == true then
            local ent = tr.Entity
            if ent != NULL then
                local bullet = {}
                bullet.Num = 1
                bullet.Src = pl:GetShootPos()
                bullet.Dir = ent:GetAngles():Forward()
                bullet.Spread = Vector(0.01, 0.01, 0)
                bullet.Tracer = 1
                bullet.Force = 2
                bullet.Damage = 25
                ent:FireBullets(bullet)
            end

            self:SendWeaponAnim(ACT_VM_SWINGHIT)
            self.Clicked = false
        end
    end
end

function SWEP:SecondaryAttack()
end