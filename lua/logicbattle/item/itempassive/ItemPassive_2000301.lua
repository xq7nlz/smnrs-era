--- @class ItemPassive_2000301 Talent passive Reaper say hello
ItemPassive_2000301 = Class(ItemPassive_2000301, BaseItemPassiveSkill)

--- @return void
--- @param id number id of talent level 10, 11, 12
--- @param hero BaseHero
function ItemPassive_2000301:Ctor(id, hero)
    BaseItemPassiveSkill.Ctor(self, id, hero)

    --- @type number
    self.triggerChance = nil

    --- @type number
    self.triggerHpPercent = nil

    --- @type boolean
    self.isTrigger = false
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function ItemPassive_2000301:CreateInstance(id, hero)
    return ItemPassive_2000301(id, hero)
end

--- @return void
function ItemPassive_2000301:Init()
    self.triggerChance = tonumber(self.data.fields.trigger_chance)
    self.triggerHpPercent = tonumber(self.data.fields.trigger_hp_percent)

    local listener = EventListener(self.myHero, self, self.CalculateTriggerInstantKill)
    self.myHero.battle.eventManager:AddListener(EventType.USE_ACTIVE_SKILL, listener)

    local instantKillEffect = TalentInstantKillEffect(self.myHero, self.myHero)
    self.myHero.effectController:AddEffect(instantKillEffect)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function ItemPassive_2000301:CalculateTriggerInstantKill(eventData)
    local initiator = eventData.initiator
    local targets = eventData.targets

    if self.isTrigger == true then
        return
    end

    if initiator ~= self.myHero then
        return
    end

    if self.myHero:IsDead() == true then
        return
    end

    local isTrigger = self.myHero.randomHelper:RandomRate(self.triggerChance)
    if isTrigger == true then
        self.isTrigger = true

        local instantKillEffect = self.myHero.effectController:GetDistinctEffectWithType(EffectType.TALENT_INSTANT_KILL)
        if instantKillEffect ~= nil then
            self.myHero.effectController:ForceRemove(instantKillEffect)
        end

        local i = 1
        while i <= targets:Count() do
            local target = targets:Get(i)

            if target:IsBoss() == false
                    and target:IsDead() == false
                    and target:IsAlly(self.myHero) == false
                    and target.hp:GetStatPercent() <= self.triggerHpPercent then
                local result
                local instantKillResult = target.hp:Dead(self.myHero, TakeDamageReason.INSTANT_KILL)
                if instantKillResult == true then
                    result = TalentInstantKillResult(self.myHero, target)
                elseif target:IsDead() == false then
                    result = ResistInstantKillResult(self.myHero, target)
                end

                if result ~= nil then
                    ActionLogUtils.AddLog(self.myHero.battle, result)
                end
            end

            i = i + 1
        end
    end
end

return ItemPassive_2000301