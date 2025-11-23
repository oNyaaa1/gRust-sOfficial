util.AddNetworkString("f1MenuGRust")
hook.Add("ShowHelp", "gRust_F1MenuYes", function(ply)
    if not ply:IsAdmin() then return true end
    net.Start("f1MenuGRust")
    net.Send(ply)
    return true
end)