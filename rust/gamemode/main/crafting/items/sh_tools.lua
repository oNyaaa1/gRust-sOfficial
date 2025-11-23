--[[

ITEMS:RegisterItem("Stone Hatchet", {
    Name = "Stone Hatchet",
    Info = "The Stone Hatchet - Basic for collecting Sheep cloths and tree gathering",
    Category = "Tools",
    model = "materials/items/tools/stone_hatchet.png",
    Weapon = "tfa_rustalpha_stone_hatchet",
    Count = 1,
    Craft = function()
        return {
            {
                Time = 30,
                CanCraft = true,
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
}, "Tools")

]]
ITEMS:RegisterItem("Building Plan", {
    Name = "Building Plan",
    Info = "The Building Plan, For building",
    Category = "Tools",
    model = "materials/items/tools/building_plan.png",
    Weapon = "hands_builder",
    Count = 1,
    Craft = function()
        return {
            {
                CanCraft = true,
                Time = 30,
                {
                    ITEM = "Wood",
                    AMOUNT = 20,
                },
            },
        }
    end,
}, "Tools")

ITEMS:RegisterItem("Hammer", {
    Name = "Hammer",
    Info = "Hammer, Upgrading ur base!",
    Category = "Tools",
    model = "materials/items/tools/hammer.png",
    Weapon = "hands_hammer",
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
            },
        }
    end,
}, "Tools")