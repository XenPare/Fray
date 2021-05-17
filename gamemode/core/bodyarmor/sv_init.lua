AddCSLuaFile("parts.lua")

util.AddNetworkString("Body Armor AddCSModel")
util.AddNetworkString("Body Armor RemoveCSModel")

local pl = FindMetaTable("Player")
function pl:SetBodyArmor(id, bool)
	self:SetNWBool("BA #" .. id, bool)
	timer.Simple(0.6, function()
		if not IsValid(self) then
			return
		end
		net.Start("Body Armor " .. (bool and "Add" or "Remove") .. "CSModel")
			net.WriteEntity(self)
			net.WriteString(id)
		net.Broadcast()
	end)
end

hook.Add("ScalePlayerDamage", "Fray Body Armor", function(pl, hit, dmg)
	if hit == HITGROUP_HEAD then
		dmg:ScaleDamage(1.3)
	end
	if (hit == HITGROUP_CHEST or hit == HITGROUP_STOMACH) then
		dmg:ScaleDamage(pl:GetNWBool("BA #chest") and 0.6 or 1.1) 
	end
	if hit == HITGROUP_LEFTARM or hit == HITGROUP_RIGHTARM then
		local res = 1
		if pl:GetNWBool("BA #bicep") then
			res = res - 0.2
		end
		if pl:GetNWBool("BA #forearm") then
			res = res - 0.2
		end
		dmg:ScaleDamage(res)
	end
	if hit == HITGROUP_LEFTLEG or hit == HITGROUP_RIGHTLEG then
		local res = 1
		if pl:GetNWBool("BA #calf") then
			res = res - 0.2
		end
		if pl:GetNWBool("BA #thigh") then
			res = res - 0.2
		end
		dmg:ScaleDamage(res)
	end
end)