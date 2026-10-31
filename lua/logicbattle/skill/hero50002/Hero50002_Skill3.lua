--- @class Hero50002_Skill3 HolyKnight
Hero50002_Skill3 = Class(Hero50002_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50002_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.reviveChance = nil

    --- @type number
    self.reviveHpPercent = nil

    --- @type Dictionary<BaseHero, boolean>
    self.triggerDictionary = Dictionary()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50002_Skill3:CreateInstance(id, hero)
    return Hero50002_Skill3(id, hero)
end

--- @return void
function Hero50002_Skill3:Init()
    self.reviveChance = self.data.reviveChance
    self.reviveHpPercent = self.data.reviveHpPercent

    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Hero50002_Skill3:OnHeroDead(eventData)
    if eventData.target == self.myHero then
        local canRevive, hpPercent = self:TryRevive(eventData.initiator)
        hpPercent = math.min(hpPercent, 1)

        if canRevive == true then
            if self.myHero.hp:Revive(self.myHero) == true then
                self.myHero.hp:SetStatPercent(hpPercent)

                local result = RebornActionResult(self.myHero, self.myHero)
                ActionLogUtils.AddLog(self.myHero.battle, result)
            end
        end
    end
end

--- @return boolean, number
--- @param initiator BaseHero
function Hero50002_Skill3:TryRevive(initiator)
    local canRevive, hpPercent = false, 1

    local isTrigger = self.triggerDictionary:Get(initiator)
    if isTrigger == nil or isTrigger == false then
        if initiator.effectController:IsContainEffectType(EffectType.HOLY_MARK) then
            self.triggerDictionary:Add(initiator, true)

            if self.myHero.randomHelper:RandomRate(self.reviveChance) then
                canRevive, hpPercent = true, self.reviveHpPercent
            end
        end
    end

    return canRevive, hpPercent
end

return Hero50002_Skill3