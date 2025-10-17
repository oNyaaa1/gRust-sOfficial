ITEMS:RegisterItem("AK47", {
    Name = "AK47",
    Info = "AK47 KAKAKAKAKAA",
    Category = "Weapons",
    model = "materials/items/weapons/assault_rifle.png",
    Weapon = "rust_ak47",
    Count = 1,
    Craft = function()
        return {
            {
                Time = 5,
                CanCraft = true,
                {
                    ITEM = "Stone",
                    AMOUNT = 10,
                },
            },
        }
    end,
}, "Weapons")
