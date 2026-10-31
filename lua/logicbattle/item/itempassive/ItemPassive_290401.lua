--- @class ItemPassive_290401:BaseItemPassiveSkill  --Talent passive First round benefit
ItemPassive_290401 = Class(ItemPassive_290401, BaseItemPassiveSkill)

--- @return void
--- @param id number id of talent level 10, 11, 12
--- @param hero BaseHero
function ItemPassive_290401:Ctor(id, hero)
	BaseItemPassiveSkill.Ctor(self, id, hero)
	--- @type number
	self.healPercent = nil

	--- @type Dictionary
	self.healRoundsDict = Dictionary()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function ItemPassive_290401:CreateInstance(id, hero)
	return ItemPassive_290401(id, hero)
end

--- @return void
function ItemPassive_290401:Init()
	self.healPercent = tonumber(self.data.fields.heal_percent)
	--- @type string
	local roundData = self.data.fields.round
	local rounds = roundData:Split(";")
	for i = 1, #rounds do
		self.healRoundsDict:Add(tonumber(rounds[i]),true)
	end

	local listener = EventListener(self.myHero, self, self.SelfHealing)
	self.myHero.battle.eventManager:AddListener(EventType.START_ROUND, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function ItemPassive_290401:SelfHealing(eventData)
	if eventData.initiator ~= self.myHero then
		return
	end

	if self.healRoundsDict:IsContainKey(eventData.round.round)then
		local healAmount = self.myHero.attack:GetValue() * self.healPercent
		HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_ITEM_EFFECT)
	end
end

return ItemPassive_290401