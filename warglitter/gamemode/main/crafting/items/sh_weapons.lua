ITEMS:RegisterItem("Wand", {
    Name = "Wand",
    Info = "Wand Avadacobra",
    Category = "Weapons",
    model = "materials/tree/wand.png",
    Weapon = "rust_wand",
    Count = 1,
    StackSize = 1,
    Stackable = false,
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