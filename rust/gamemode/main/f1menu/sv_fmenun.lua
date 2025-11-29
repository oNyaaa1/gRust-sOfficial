util.AddNetworkString("f1MenuGRust")
util.AddNetworkString("f1MenuGRustAdmin")
net.Receive("f1MenuGRustAdmin", function(len, pl)
    if not pl:IsAdmin() then return end
    local itemName = net.ReadString()
    local stack = ITEMS:GetItem(itemName)
    pl:GiveItem(itemName, stack.StackSize or stack.Count)
end)

hook.Add("ShowHelp", "gRust_F1MenuYes", function(ply)
    if not ply:IsAdmin() then return true end
    net.Start("f1MenuGRust")
    net.Send(ply)
    return true
end)