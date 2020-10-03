include('shared.lua')

LANG.AddToLanguage("english", "mine_turtle_name", "Mine Turtle")
LANG.AddToLanguage("english", "mine_turtle_desc", "HELLO!\n\nNOTE: Can be shot and destroyed by everyone.")

LANG.AddToLanguage("Русский", "mine_turtle_name", "Черепашья мина")
LANG.AddToLanguage("Русский", "mine_turtle_desc", "ПРИВЕТ!\n\nПРИМЕЧАНИЕ: может быть взорвана и уничтожена кем угодно.")

SWEP.PrintName = "mine_turtle_name"
SWEP.Slot = (!GetConVar("ttt_mineturtle_detective"):GetBool() and !GetConVar("ttt_mineturtle_traitor"):GetBool()) and 3 or 6
SWEP.Icon = "vgui/ttt/icon_mine_turtle"

SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 64

-- equipment menu information is only needed on the client
SWEP.EquipMenuData = {
	type = "item_weapon",
	desc = "mine_turtle_desc"
}

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
