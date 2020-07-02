--- Author informations ---
ENT.Author = "Zaratusa"
ENT.Contact = "http://steamcommunity.com/profiles/76561198032479768"

ENT.Type = "anim"

ENT.CanHavePrints = true
ENT.CanUseKey = true
ENT.Avoidable = true

ENT.BeepSound = Sound("weapons/c4/c4_beep1.wav")
ENT.PreExplosionSound = Sound("weapons/c4/c4_beep1.wav")
ENT.ExplosionSound = Sound("Weapon_SLAM.SatchelDetonate")
ENT.Model = Model("models/props/de_tides/vending_turtle.mdl")

ENT.BlastRadius = 200
ENT.BlastDamage = 1000

ENT.PreExplosionSound = Sound("")
ENT.ClickSound = Sound("weapons/mine_turtle/click.wav")
ENT.HelloSound = Sound("weapons/mine_turtle/hello.wav")
ENT.HelloTurtleSound = Sound("weapons/mine_turtle/hello_mine_turtle.wav")

ENT.ScanRadius = 100

AccessorFunc(ENT, "Placer", "Placer") -- using Placer instead of Owner, so everyone can damage the SLAM

function ENT:Initialize()
	if (IsValid(self)) then
		self:SetModel(self.Model)

		if SERVER then
			self:PhysicsInit(SOLID_VPHYSICS)
			self:SetMoveType(MOVETYPE_VPHYSICS)
		end
		self:SetSolid(SOLID_BBOX)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

		if SERVER then
			self:SetUseType(SIMPLE_USE)
			self:SetMaxHealth(10)
		end
		self:SetHealth(10)

		if (self:GetPlacer()) then
			if (!self:GetPlacer():IsActiveTraitor()) then
				self.Avoidable = false
			end
		else
			self:SetPlacer(nil)
		end

		self:SetDefusable(false)
		self.Exploding = false
		self.HelloPlayed = false

		if SERVER then
			self:SendWarn(true)
		end

		timer.Simple(1.5, function()
			if IsValid(self) then
				self:SetDefusable(true)
				sound.Play(self.BeepSound, self:GetPos(), 65, 110, 0.7)
			end
		end)
	end
end

-- function for better legibility
function ENT:IsActive()
	return self:GetDefusable()
end

-- function for defuser
function ENT:Defusable()
	return self:GetDefusable()
end

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Defusable") -- same as active on C4, just for defuser compatibility
end

function ENT:OnTakeDamage(dmginfo)
	if (IsValid(self)) then
		-- it can still explode, even if defused
		self:SetHealth(self:Health() - dmginfo:GetDamage())
		if (self:Health() <= 0) then
			-- the attacker should get the kill
			local attacker = dmginfo:GetAttacker()
			if (IsValid(attacker)) then
				self:SetPlacer(attacker)
			end
			self:StartExplode(false)
		end
	end
end

function ENT:StartExplode(checkActive)
	if (!self.Exploding) then
		self:EmitSound(self.PreExplosionSound)
		timer.Simple(0.15, function() if (IsValid(self)) then self:Explode(checkActive) end end)
	end
end

function ENT:Explode(checkActive)
	if (IsValid(self) and !self.Exploding) then
		if (checkActive and !self:IsActive()) then return end
		self.Exploding = true
		local pos = self:GetPos()
		local radius = self.BlastRadius
		local damage = self.BlastDamage

		self:EmitSound(self.ExplosionSound, 60, math.random(125, 150))

		util.BlastDamage(self, self:GetPlacer(), pos, radius, damage)

		local effect = EffectData()
		effect:SetStart(pos)
		effect:SetOrigin(pos)
		effect:SetScale(radius)
		effect:SetRadius(radius)
		effect:SetMagnitude(damage)
		util.Effect("Explosion", effect, true, true)

		self:Remove()
	end
end

function ENT:UseOverride(activator)
	if (IsValid(self) and (!self.Exploding) and IsValid(activator) and activator:IsPlayer()) then
		local owner = self:GetPlacer()
		if ((self:IsActive() and owner == activator) or (!self:IsActive())) then
			-- check if the user already has a mine turtle
			if (activator:HasWeapon("weapon_ttt_mine_turtle")) then
				local weapon = activator:GetWeapon("weapon_ttt_mine_turtle")
				weapon:SetClip1(weapon:Clip1() + 1)
			else
				local weapon = activator:Give("weapon_ttt_mine_turtle")
				weapon:SetClip1(1)
			end

			-- remove the entity
			if activator:HasWeapon("weapon_ttt_mine_turtle") then
				if (self:GetPlacer() ~= activator) then
					activator:EmitSound(self.HelloTurtleSound)
				end
				self:Remove()
			else
				LANG.Msg(activator, "mine_turtle_full")
			end
		end
	end
end
