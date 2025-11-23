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

ITEMS:RegisterItem("M249", {
    Name = "M249",
    Info = "M249 - Macho Man",
    Category = "Weapons",
    model = "materials/items/weapons/m249.png",
    Weapon = "rusts_m249",
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

ITEMS:RegisterItem("Rock", {
    Name = "Rock",
    Info = "Rock, Basic gathering tool.",
    Category = "Weapons",
    model = "materials/items/tools/rock.png",
    Weapon = "rust_wrock",
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

ITEMS:RegisterItem("Stone Pickaxe", {
    Name = "Stone Pickaxe",
    Info = "The Stone Pickaxe - Basic for collecting Ores",
    Category = "Weapons",
    model = "materials/items/tools/stone_pickaxe.png",
    Weapon = "tfa_rustalpha_stone_hatchet",
    Count = 1,
    Craft = function()
        return {
            {
                CanCraft = true,
                Time = 30,
                {
                    ITEM = "Wood",
                    AMOUNT = 200,
                },
                {
                    ITEM = "Stone",
                    AMOUNT = 100,
                },
            },
        }
    end,
}, "Weapons")

ITEMS:RegisterItem("Hatchet", {
    Name = "Hatchet",
    Info = "Hatchet, Gathering trees!",
    Category = "Weapons",
    model = "materials/items/tools/hatchet.png",
    Weapon = "tfa_rustalpha_hatchet",
    Count = 1,
    Craft = function()
        return {
            {
                CanCraft = true,
                Time = 30,
                {
                    ITEM = "Wood",
                    AMOUNT = 400,
                },
                {
                    ITEM = "Metal Fragments",
                    AMOUNT = 150
                }
            },
        }
    end,
}, "Weapons")

ITEMS:RegisterItem("Pickaxe", {
    Name = "Pickaxe",
    Info = "Pickaxe, Gathering Ores!",
    Category = "Weapons",
    model = "materials/items/tools/pickaxe.png",
    Weapon = "tfa_rustalpha_pickaxe",
    Count = 1,
    Craft = function()
        return {
            {
                CanCraft = true,
                Time = 30,
                {
                    ITEM = "Wood",
                    AMOUNT = 400,
                },
                {
                    ITEM = "Metal Fragments",
                    AMOUNT = 150
                }
            },
        }
    end,
}, "Weapons")