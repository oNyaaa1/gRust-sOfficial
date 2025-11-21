include("config.lua")
include("shared.lua")
surface.CreateFont("gRustColorFont", {
	font = "Arial",
	extended = false,
	size = 60,
	weight = 500,
	bold = true,
})

function GM:PostDrawViewModel(vm, ply, weapon)
	if weapon.UseHands or not weapon:IsScripted() then
		local hands = LocalPlayer():GetHands()
		if IsValid(hands) then hands:DrawModel() end
	end
end

hook.Add("HUDPaint", "HudAboveEnt", function()
	for k, v in pairs(ents.GetAll()) do
		if IsValid(v) and IsValid(LocalPlayer()) and v ~= LocalPlayer() and v:GetClass() == "npc_deer" or v:GetClass() == "prop_ragdoll" then
			local toscreen = v:GetPos():ToScreen()
			if v:GetPos():Distance(LocalPlayer():GetPos()) <= 100 then
				draw.RoundedBox(0, toscreen.x - 240, toscreen.y, 250, 60, Color(0, 0, 0, 100))
				draw.DrawText("Health: " .. tostring(v:Health()), "gRustColorFont", toscreen.x, toscreen.y, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
			end
		end
	end
end)