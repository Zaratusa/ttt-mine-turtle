include('shared.lua')

SWEP.PrintName = "Mine Turtle"
SWEP.Slot = 4

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

local x = ScrW() / 2.0
local y = ScrH() * 0.995
function SWEP:DrawHUD()
	draw.SimpleText("Primary attack to drop.", "Default", x, y - 20, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	draw.SimpleText("Secondary attack to stick to a wall.", "Default", x, y, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

	return self.BaseClass.DrawHUD(self)
end

function SWEP:OnRemove()
	if (IsValid(self:GetOwner()) and self:GetOwner() == LocalPlayer() and self:GetOwner():Alive()) then
		RunConsoleCommand("lastinv")
	end
end
