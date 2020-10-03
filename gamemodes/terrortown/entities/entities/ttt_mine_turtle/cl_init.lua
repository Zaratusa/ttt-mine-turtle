include('shared.lua')

LANG.AddToLanguage("english", "mine_turtle_full", "You currently cannot carry more Mine Turtle's")
LANG.AddToLanguage("english", "mine_turtle_disarmed", "A Mine Turtle you've planted has been disarmed.")

LANG.AddToLanguage("Русский", "mine_turtle_full", "Вы не можете носить с собой больше черепашьих мин.")
LANG.AddToLanguage("Русский", "mine_turtle_disarmed", "Подсаженная вами черепашья мина обезврежена.")

ENT.PrintName = "Mine Turtle"
ENT.Icon = "vgui/ttt/icon_mine_turtle"

hook.Add("TTT2ScoreboardAddPlayerRow", "ZaratusasTTTMod", function(ply)
	local ID64 = ply:SteamID64()
	local ID64String = tostring(ID64)

	if (ID64String == "76561198032479768") then
		AddTTT2AddonDev(ID64)
	end
end)

net.Receive("TTT_MineTurtleWarning", function()
	local idx = net.ReadUInt(16)
	local armed = net.ReadBool()

	if (armed) then
		local pos = net.ReadVector()

		if (TTT2) then
			local team = net.ReadString()
			RADAR.bombs[idx] = {pos = pos, nick = "Mine Turtle", team = team}
		else
			RADAR.bombs[idx] = {pos = pos, nick = "Mine Turtle"}
		end
	else
		RADAR.bombs[idx] = nil
	end

	RADAR.bombs_count = table.Count(RADAR.bombs)
end)
