--- @class ItemPassive_2000601 Talent passive Stronger Crit
ItemPassive_2000601 = Class(ItemPassive_2000601, BaseItemPassiveSkill)

--- @return void
--- @param id number id of talent level 10, 11, 12
--- @param hero BaseHero
function ItemPassive_2000601:Ctor(id, hero)
    BaseItemPassiveSkill.Ctor(self, id, hero)

    --- @type number
    self.triggerChance = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function ItemPassive_2000601:CreateInstance(id, hero)
    return ItemPassive_2000601(id, hero)
end

--- @return void
function ItemPassive_2000601:Init()
    self.triggerChance = tonumber(self.data.fields.trigger_chance)

    local basicCriticalListener = EventListener(self.myHero, self, self.CalculateTriggerSilence)
    self.myHero.battle.eventManager:AddListener(EventType.DEAL_BASIC_ATTACK_DAMAGE, basicCriticalListener)

    local activeSkillCriticalListener = EventListener(self.myHero, self, self.CalculateTriggerSilence)
    self.myHero.battle.eventManager:AddListener(EventType.DEAL_SKILL_DAMAGE, activeSkillCriticalListener)

    local critEffect = TalentCriticalSilentEffect(self.myHero, self.myHero)
    self.myHero.effectController:AddEffect(critEffect)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function ItemPassive_2000601:CalculateTriggerSilence(eventData)
    local dodgeType = eventData.dodgeType
    local isCrit = eventData.isCrit
    local target = eventData.target
    local initiator = eventData.initiator

    if initiator ~= self.myHero then
        return
    end

    if dodgeType ~= DodgeType.MISS and isCrit == true then
        if self.myHero.randomHelper:RandomRate(self.triggerChance) then
            local silenceEffect = SilenceEffect(self.myHero, target, 1)

            if target.effectController:IsSilenced() == false then
                target.effectController:AddEffect(silenceEffect)
            end
        end
    end
end

return ItemPassive_2000601