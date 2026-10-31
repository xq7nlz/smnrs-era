--- @class Hero30002_Skill4 En
Hero30002_Skill4 = Class(Hero30002_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30002_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.hpHeal = nil

    --- @type BaseTargetSelector
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, TargetPositionType.RANDOM, TargetTeamType.ALLY, 5)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30002_Skill4:CreateInstance(id, hero)
    return Hero30002_Skill4(id, hero)
end

--- @return void
function Hero30002_Skill4:Init()
    self.hpHeal = self.data.hpHeal

    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Hero30002_Skill4:OnHeroDead(eventData)
    if eventData.target == self.myHero then
        local targetList = self.targetSelector:SelectTarget(self.myHero.battle)

        local healValue = self.myHero.hp:GetMax() * self.hpHeal
        if targetList:Count() > 0 then
            local healAmount = healValue / targetList:Count()
            local i = 1
            while i <= targetList:Count() do
                local target = targetList:Get(i)
                HealUtils.Heal(self.myHero, target, healAmount, HealReason.HEAL_SKILL)
                i = i + 1
            end
        end
    end
end

return Hero30002_Skill4