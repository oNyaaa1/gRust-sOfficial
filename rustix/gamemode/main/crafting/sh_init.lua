print("Crafting")
ITEMS = ITEMS or {}
COUNT = COUNT or {}
local Tbl = {}
Tbl[1] = {"Favorite", "icons/favorite_inactive.png"}
Tbl[2] = {"Construction", "icons/construction.png"}
Tbl[3] = {"Items", "icons/extinguish.png"}
Tbl[4] = {"Resources", "icons/servers.png"}
Tbl[5] = {"Clothing", "icons/servers.png"}
Tbl[6] = {"Tools", "icons/tools.png"}
Tbl[7] = {"Medical", "icons/medical.png"}
Tbl[8] = {"Weapons", "icons/weapon.png"}
Tbl[9] = {"Ammo", "icons/ammo.png"}
Tbl[11] = {"Fun", "icons/servers.png"}
Tbl[12] = {"Other", "icons/electric.png"}
Tbl[13] = {"Extra", "icons/electric.png"}
function ITEMS:RegisterItem(itemName, items, category)
    self[itemName] = items
    local countz = 0
    for k, v in pairs(ITEMS) do
        if type(v) == "table" and v.Category == category then countz = countz + 1 end 
    end

    COUNT[category] = countz
end

function ITEMS:GetItem(itemName)
    return self[itemName]
end