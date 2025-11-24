print("Inventory Loaded")
util.AddNetworkString("gRust_COD")
util.AddNetworkString("SendSlots")
util.AddNetworkString("DragNDropRust")
util.AddNetworkString("gRustWriteSlot")
resource.AddSingleFile("model/tree/treemarker.png")
hook.Add("InitPostEntity", "WipeStart", function() if game.GetMap() ~= "rust_fields" then game.ConsoleCommand("changelevel rust_fields\n") end end)
hook.Add("GetFallDamage", "CSSFallDamage", function(ply, speed) return math.max(0, math.ceil(0.2418 * speed - 141.75)) end)
function FindValidSlotBackWards(ply, select_Slot)
    if select_Slot then return select_Slot end
    local SlotByDefault = 1
    local FoundSlot = false
    for i = 1, 48 do
        if ply.tbl[i] == nil then
            ply.tbl[i] = {
                SlotFree = true
            }
        end
    end

    for i = 1, 7 do
        if ply.tbl[i] and ply.tbl[i].SlotFree == true then
            SlotByDefault = i
            FoundSlot = true
            break
        end
    end

    if FoundSlot == false then
        for i = 8, 48 do
            if ply.tbl[i].SlotFree == true then
                SlotByDefault = i
                FoundSlot = true
                break
            end
        end
    end
    return SlotByDefault
end

local FindSlot = function(ply, item)
    local itemz = ITEMS:GetItem(item)
    for k, v in pairs(ply.tbl) do
        if not istable(v) then continue end
        if v.Img == itemz.model then return v end
    end
    return nil
end

function PickleAdillyEdit(ply, wep, amount)
    if ply.Slots == nil then ply.Slotz = {} end
    if ply.tbl == nil then
        ply.tbl = {
            SlotFree = true
        }
    end

    local itemz = ITEMS:GetItem(wep)
    if not itemz then
        print("Cannot find", wep, " As an item!")
        return
    end

    if itemz.Weapon ~= "" then ply:Give(itemz.Weapon) end
    local slot = FindSlot(ply, wep)
    if slot == nil and amount > 0 then
        ply:SetNWFloat(wep, amount)
        local sloto = FindValidSlotBackWards(ply)
        ply.tbl[sloto] = {
            Slotz = sloto,
            Weapon = wep,
            Img = itemz.model,
            Amount = amount,
        }

        net.Start("DragNDropRust")
        net.WriteTable(ply.tbl)
        net.Send(ply)
        return
    end

    local slotss = 0
    local adding = false
    local editmode = false
    local CurrentAmount = 0
    for k, v in pairs(ply.tbl) do
        if not istable(v) then continue end
        if v.Weapon == itemz.Name then
            local amont = v.Amount or 0
            if amont ~= nil and amont >= 1000 then
                adding = true
                slotss = k
                CurrentAmount = amont
            elseif v.Weapon == itemz.Name and amont < 1000 then
                editmode = true
                slotss = k
                CurrentAmount = amont
                break
            end
        end
    end

    if editmode == true and slotss ~= 0 and CurrentAmount > 0 then
        ply:SetNWFloat(wep, CurrentAmount + amount)
        ply.tbl[slotss] = {
            Slotz = slotss,
            Weapon = wep,
            Img = itemz.model,
            Amount = math.Clamp(CurrentAmount + amount or 0, 0, itemz.StackSize or 1000),
            SlotFree = false,
        }

        net.Start("DragNDropRust")
        net.WriteTable(ply.tbl)
        net.Send(ply)
        return ply.tbl
    end

    if adding and amount > 0 then
        ply:SetNWFloat(wep, amount)
        local sloto = FindValidSlotBackWards(ply)
        ply.tbl[sloto] = {
            Slotz = sloto,
            Weapon = wep,
            Img = itemz.model,
            Amount = math.Clamp(amount or 0, 0, itemz.StackSize),
            SlotFree = false,
        }

        net.Start("DragNDropRust")
        net.WriteTable(ply.tbl)
        net.Send(ply)
        return ply.tbl
    end
end

local meta = FindMetaTable("Player")
function meta:GetItem(item)
    for k, v in pairs(self.tbl) do
        if not isstring(v.Weapon) then continue end
        if item == v.Weapon then return v end
    end
    return nil
end

function meta:GiveItem(item, amount)
    PickleAdillyEdit(self, item, amount)
    return true
end

function meta:CalcTotal(item)
    local total = 0
    for _, v in pairs(self.tbl) do
        if istable(v) and v.Weapon == item then
            total = total + (v.Amount or 0)
        end
    end
    return total
end


function meta:TakeItem(item, amount)
    local itemz = ITEMS:GetItem(item)
    if not itemz then
        print("Cannot find", item, "As an item!")
        return false
    end

    -- Check total
    local total = self:CalcTotal(item)
    if total < amount then
        self:SendNotification("", NOTIFICATION_REMOVE, "materials/icons/bite.png",
            "Not enough " .. itemz.Name)
        return false
    end

    -- Remove amount from existing stacks
    local remaining = amount

    for k, v in pairs(self.tbl) do
        if istable(v) and v.Weapon == itemz.Name then
            local stack = v.Amount or 0

            if stack >= remaining then
                -- Take what we need and finish
                v.Amount = stack - remaining

                if v.Amount <= 0 then
                    self.tbl[k] = nil -- remove empty
                end

                remaining = 0
                break
            else
                -- Remove the whole stack
                remaining = remaining - stack
                self.tbl[k] = nil
            end
        end
    end

    -- Should be finished
    if remaining > 0 then
        print("ERROR: Remaining > 0 after removal (inventory corruption?)")
    end

    -- Notify + network sync
    self:SendNotification(item, NOTIFICATION_REMOVE,
        "materials/icons/bite.png", "Removed: " .. amount)

    net.Start("DragNDropRust")
    net.WriteTable(self.tbl)
    net.Send(self)

    return true
end


util.AddNetworkString("gRustSelectWep")
net.Receive("gRustSelectWep", function(len, ply)
    local id = net.ReadFloat()
    local proxy_wep = net.ReadString()
    local itemz = ITEMS:GetItem(proxy_wep)
    if not itemz then return end
    if id >= 1 and id <= 6 then
        ply:SelectWeapon(itemz.Weapon)
    else
        ply:SelectWeapon("rust_hands")
    end
end)

function IsSlotFull(ply, ns)
    for i = 1, #ply.tbl do
        if ply.tbl[i] and ply.tbl[i].Slotz == ns then return true end
    end
    return false
end

net.Receive("gRustWriteSlot", function(len, ply)
    local id = net.ReadFloat() -- target slot
    local proxy_wep = net.ReadString()
    local proxy_id = net.ReadFloat() -- slot currently dragging from
    local itemz = ITEMS:GetItem(proxy_wep)
    if not itemz then return end
    local fromItem = ply.tbl[proxy_id]
    if not fromItem then return end
    local targetItem = ply.tbl[id] -- item currently in target slot (if any)
    if id >= 1 and id <= 6 then
        ply:SelectWeapon(itemz.Weapon)
    else
        ply:SelectWeapon("rust_hands")
    end

    -- We are now replacing the target slot
    ply.tbl[id] = {
        Slotz = id,
        Weapon = itemz.Name,
        Img = itemz.model,
        Amount = fromItem.Amount,
        SlotFree = false
    }

    -- If item existed in target slot, move it to the old location (swap)
    if targetItem then
        ply.tbl[proxy_id] = {
            Slotz = proxy_id,
            Weapon = targetItem.Weapon,
            Img = targetItem.Img,
            Amount = targetItem.Amount,
            SlotFree = false
        }
    else
        -- otherwise just clear original slot
        ply.tbl[proxy_id] = nil
    end

    -- sync back to client
    net.Start("DragNDropRust")
    net.WriteTable(ply.tbl)
    net.Send(ply)
end)

hook.Add("PlayerSpawn", "GiveITem", function(ply)
    PickleAdillyEdit(ply, "Rock", 1)
    --PickleAdillyEdit(ply, "AK47", 1)
    ply:Give("rust_hands")
    ply:SetNWInt("Hunger", math.random(90, 120))
    ply:SetNWInt("Thirst", math.random(90, 100))
    local ITEM = nil
    for _, vk in pairs(ITEMS) do
        if type(vk) == "function" then continue end
        if type(vk) == "table" then ITEM = vk end
    end

    for k, v in ipairs(ITEM.Craft()) do
        if istable(v) then
            for i, j in ipairs(v) do
                if istable(j) then ply:GiveItem(j.ITEM, 0) end
            end
        end
    end
end)

hook.Add("PlayerDeath", "GiveITem", function(vic, inf, attacker)
    table.Empty(vic.tbl)
    net.Start("DragNDropRust")
    net.WriteTable(vic.tbl)
    net.Send(vic)
end)

hook.Add("PlayerButtonUp", "Inventory", function(ply, button)
    if button == 67 and ply then
        net.Start("DragNDropRust")
        net.WriteTable(ply.tbl)
        net.WriteBool(false)
        net.Send(ply)
    end
end)

hook.Add("PlayerButtonDown", "Inventory", function(ply, button)
    if button == 67 and ply then
        net.Start("DragNDropRust")
        net.WriteTable(ply.tbl)
        net.WriteBool(true)
        net.Send(ply)
    end
end)