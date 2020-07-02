if SERVER then
	AddCSLuaFile()
end

ENT.Type = "anim"
ENT.model = Model("models/props/cs_office/coffee_mug.mdl")
ENT.CanUseKey = true

function ENT:Initialize()
	self:SetModel(self.model)

	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
	end

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
	end
end

function ENT:Use(activator)
	if not IsValid(activator) then return end

	coffeeCup.PickupCup(self, activator)
end
