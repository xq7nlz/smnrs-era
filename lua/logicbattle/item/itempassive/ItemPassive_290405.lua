--- @class ItemPassive_290405:BaseItemPassiveSkill  --Talent passive First round benefit
ItemPassive_290405 = Class(ItemPassive_290405, BaseItemPassiveSkill)

--- @return void
--- @param id number id of talent level 10, 11, 12
--- @param hero BaseHero
function ItemPassive_290405:Ctor(id, hero)
	BaseItemPassiveSkill.Ctor(self, id, hero)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function ItemPassive_290405:CreateInstance(id, hero)
	return ItemPassive_290405(id, hero)
end

--- @return void
function ItemPassive_290405:Init()
	self.healPercent = tonumber(self.data.fields.heal_percent)

	local listener = EventListener(self.myHero, self, self.TriggerEventRoundStart)
	self.myHero.battle.eventManager:AddListener(EventType.START_ROUND, listener)
end

--- @return void
--- @param data table
function ItemPassive_290405:TriggerEventRoundStart(data)
	if data.initiator ~= self.myHero then
		return
	end

	--- @param v BaseEffect
	for k,v in pairs(self.myHero.effectController.effectList:GetItems()) do
		if v.isBuff and v.persistentType == EffectPersistentType.NON_PERSISTENT then
			local healAmount = self.myHero.hp:GetMax() * self.healPercent
			HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_ITEM_EFFECT)
			return
		end
	end
end

return ItemPassive_290405