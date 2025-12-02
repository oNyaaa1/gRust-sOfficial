local DPanel
local MapMaterial = Material("materials/ui/grust_map.png")
local PlayerMaterial = Material("icons/player_marker.png")
local function VectorToMap(vec)
	-- Map world coords to screen coords
	local x = math.Remap(vec.x, -14587, 14659, ScrW() / 2 / 2, ScrW() * 1.2)
	local y = math.Remap(vec.y, 15101, -14929, ScrH() * 0.0075, ScrH() * 0.98)
	return x, y
end

-- Draws a textured rect with custom pivot (x0, y0)
function DrawTexturedAngle(x, y, w, h, rot, x0, y0)
	local c = math.cos(math.rad(rot))
	local s = math.sin(math.rad(rot))
	-- Corrected rotation of pivot
	local newx = x0 * c - y0 * s
	local newy = x0 * s + y0 * c
	surface.DrawTexturedRectRotated(x + newx, y + newy, w, h, rot)
end

hook.Add("HUDPaint", "MiniMap", function()
	local w, h = ScrW() / 2 + 100, ScrH() / 2 + 100
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(MapMaterial)
	surface.DrawTexturedRect(0, 0, w / 2, h / 2)
	local ToPos = LocalPlayer():GetPos()
	local x, y = VectorToMap(ToPos)
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(PlayerMaterial)
	DrawTexturedAngle(x / 2 / 2 - 50, y / 2 / 2 + 10, 20, 20, LocalPlayer():GetAngles().y - 90, 0, 0)
end)