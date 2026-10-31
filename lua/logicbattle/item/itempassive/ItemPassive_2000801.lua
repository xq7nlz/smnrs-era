--- @class ItemPassive_2000801 Talent passive reduce critical rate
ItemPassive_2000801 = Class(ItemPassive_2000801, BaseItemPassiveSkill)

--- @return void
--- @param id number id of talent level 10, 11, 12
--- @param hero BaseHero
function ItemPassive_2000801:Ctor(id, hero)
    BaseItemPassiveSkill.Ctor(self, id, hero)

    --- @type number
    self.statDeBuffType = nil

    --- @type number
    self.statDeBuffAmount = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function ItemPassive_2000801:CreateInstance(id, hero)
    return ItemPassive_2000801(id, hero)
end

--- @return void
function ItemPassive_2000801:Init()
    self.statDeBuffType = tonumber(self.data.fields.stat_debuff_type)
    self.statDeBuffAmount = tonumber(self.data.fields.stat_debuff_amount)

    local listener = EventListener(self.myHero, self, self.InflictDeBuffEffect)
    self.myHero.battle.eventManager:AddListener(EventType.DEAL_BASIC_ATTACK_DAMAGE, listener)

    local activeSkillListener = EventListener(self.myHero, self, self.InflictDeBuffEffect)
    self.myHero.battle.eventManager:AddListener(EventType.DEAL_SKILL_DAMAGE, activeSkillListener)

    local reduceCrit = TalentReduceCriticalEffect(self.myHero, self.myHero)
    self.myHero.effectController:AddEffect(reduceCrit)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function ItemPassive_2000801:InflictDeBuffEffect(eventData)
    local target = eventData.target
    local initiator = eventData.initiator
    local dodgeType = eventData.dodgeType

    if initiator ~= self.myHero then
        return
    end

    if self.myHero:IsAlly(target) == true then
        return
    end

    if dodgeType ~= DodgeType.MISS then
        local statChanger = StatChanger(false)
        statChanger:SetInfo(self.statDeBuffType, StatChangerCalculationType.PERCENT_ADD, self.statDeBuffAmount)

        local effect = StatChangerEffect(self.myHero, target, false)
        effect:SetDuration(1)
        effect:AddStatChanger(statChanger)
        effect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)

        target.effectController:AddEffect(effect)
    end
end

return ItemPassive_2000801