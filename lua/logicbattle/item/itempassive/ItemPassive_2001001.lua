--- @class ItemPassive_2001001 Talent passive More power
ItemPassive_2001001 = Class(ItemPassive_2001001, BaseItemPassiveSkill)

--- @return void
--- @param id number id of talent level 10, 11, 12
--- @param hero BaseHero
function ItemPassive_2001001:Ctor(id, hero)
    BaseItemPassiveSkill.Ctor(self, id, hero)

    --- @type number
    self.powerBonus = nil

end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function ItemPassive_2001001:CreateInstance(id, hero)
    return ItemPassive_2001001(id, hero)
end

--- @return void
function ItemPassive_2001001:Init()
    self.powerBonus = tonumber(self.data.fields.power_bonus)

    local listener = EventListener(self.myHero, self, self.CalculatePowerBonus)
    self.myHero.battle.eventManager:AddListener(EventType.USE_ACTIVE_SKILL, listener)

    local effect = TalentMorePowerEffect(self.myHero, self.myHero)
    self.myHero.effectController:AddEffect(effect)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function ItemPassive_2001001:CalculatePowerBonus(eventData)
    local initiator = eventData.initiator
    if initiator ~= self.myHero then
        return
    end

    PowerUtils.GainPower(self.myHero, self.myHero, self.powerBonus, true)
end

return ItemPassive_2001001