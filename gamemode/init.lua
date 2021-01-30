AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("lang.lua")
include("shared.lua")
include("lang.lua")

CustomizableWeaponry.canDropWeapon = false

local CFG = Fray.Config

function GM:Initialize()
	local spawns = CFG.PlayerSpawns
	if not spawns then
		return
	end
	timer.Simple(0.4, function()
		for _, pos in pairs(spawns) do
			local spawn = ents.Create("fray_spawn")
			spawn:SetPos(pos)
			spawn:Spawn()
		end
	end)
end

function GM:PlayerLoadout(pl)
	pl:Give("cw_extrema_ratio_official")
end

local function hasDeathPointAround(pl, pos)
	local death = pl.DeathPos
	if death then
		if death:DistToSqr(pos) < 200000 then
			return true
		end
	end
	return false
end

local function hasPeopleAround(ent)
	local players_nearby = {}
	for _, _ent in pairs(ents.FindInSphere(ent:GetPos(), 500)) do
		if _ent:IsPlayer() then
			table.insert(players_nearby, _ent)
		end
	end
	return #players_nearby ~= 0
end

hook.Add("PlayerSelectSpawn", "Fray", function(pl)
	if not CFG.PlayerSpawns then
		return
	end

	local randomed
	local function getSpawner()
		local spawner = nil
		randomed = table.Random(ents.FindByClass("fray_spawn"))
		if hasDeathPointAround(pl, randomed:GetPos()) or hasPeopleAround(randomed) then
			getSpawner()
		else
			spawner = randomed
		end
	end

	getSpawner()
	if spawner == nil then
		return table.Random(ents.FindByClass("fray_spawn"))
	end
	return spawner
end)

hook.Add("PlayerInitialSpawn", "Fray", function(pl)
	pl:SetWalkSpeed(CFG.WalkSpeed)
	pl:SetRunSpeed(CFG.RunSpeed)
	pl:SetJumpPower(CFG.JumpPower)
	pl:SetModel(table.Random(CFG.Playermodels))

	pl:SetSimpleTimer(0.1, function()
		pl:SetTeam(TEAM_SURVIVOR)
	end)

	Fray.SetCountry(pl)
	pl:SetSimpleTimer(30, function()
		Fray.LanguagePropose(pl)
	end)
end)

hook.Add("PlayerSpawn", "Fray", function(pl)
	pl:SetWalkSpeed(CFG.WalkSpeed)
	pl:SetRunSpeed(CFG.RunSpeed)
	pl:SetJumpPower(CFG.JumpPower)
end)

hook.Add("GetFallDamage", "Fray", function(_, speed)
    return speed / 8
end)