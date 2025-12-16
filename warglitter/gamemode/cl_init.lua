include("config.lua")
include("shared.lua")
surface.CreateFont("gRustColorFont", {
	font = "Arial",
	extended = false,
	size = 60,
	weight = 500,
	bold = true,
})

surface.CreateFont("GRustHUDLOW", {
	font = "Arial",
	extended = false,
	size = 25,
	weight = 1800,
	bold = true,
})

function GM:PostDrawViewModel(vm, ply, weapon)
	if weapon.UseHands or not weapon:IsScripted() then
		local hands = LocalPlayer():GetHands()
		if IsValid(hands) then hands:DrawModel() end
	end
end