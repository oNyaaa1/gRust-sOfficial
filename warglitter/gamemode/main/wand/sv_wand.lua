--Fuck double
util.AddNetworkString("Wand_Spells")
util.AddNetworkString("Wand_Spells_Remake")
util.AddNetworkString("SendLightNing")
WH = WH or {}
WH.SettedSpells = {}
function WH:RegisterSpells(name, func)
    WH.SettedSpells[#WH.SettedSpells + 1] = {name, func}
end

WH:RegisterSpells("Chopper", function(ply, ent, spell)
    if spell ~= "Chopper" then return end
    local ef = EffectData()
    ef:SetEntity(ply)
    ef:SetStart(Vector(255, 255, 255))
    ef:SetScale(0.4)
    util.Effect("EffectHpwRewriteSparks", ef, true, true)
    net.Start("SendLightNing")
    net.WriteEntity(ply)
    net.Broadcast()
    ply:EmitSound("ambient/wind/wind_snippet2.wav")
    local trace = ply:GetEyeTrace().Entity
    SendTreeHit(ply, trace, ply:GetActiveWeapon():GetClass(), trace.treeHealth)
end)

WH:RegisterSpells("Grider", function(ply, ent, spell)
    if spell ~= "Grider" then return end
    local ef = EffectData()
    ef:SetEntity(ply)
    ef:SetStart(Vector(255, 255, 255))
    ef:SetScale(0.4)
    util.Effect("EffectHpwRewriteSparks", ef, true, true)
    net.Start("SendLightNing")
    net.WriteEntity(ply)
    net.Broadcast()
    ply:EmitSound("ambient/wind/wind_snippet2.wav")
    local trace = ply:GetEyeTrace().Entity
    local wep = ply:GetActiveWeapon()
    gRust.Mining.MineOres(ply, trace, wep, ply:GetActiveWeapon():GetClass())
end)

function WH:GetSpell(ply, ent, name)
    local CurrSpell = name
    for k, v in pairs(WH.SettedSpells) do
        if name == v[1] then CurrSpell = v[2] end
    end

    if isstring(CurrSpell) then return end
    CurrSpell(ply, ent, name)
end

function WH:SetSpell(ply, tbls)
    local tbl = {}
    for k, v in pairs(WH.SettedSpells) do
        if v[1] == tbls[k] then tbl[k] = v[1] end
    end

    ply.HasSpell = tbl
    net.Start("Wand_Spells")
    net.WriteTable(tbl)
    net.Send(ply)
end

hook.Add("PlayerSpawn", "WandSpells", function(ply) WH:SetSpell(ply, {"Chopper", "Grider"}) end)
net.Receive("Wand_Spells_Remake", function(len, ply)
    local spell = net.ReadString()
    local Confirm = false
    for k, v in pairs(ply.HasSpell) do
        if v == spell then Confirm = true end
    end

    if Confirm == false then return end
    ply.SelectedSpell = spell
end)