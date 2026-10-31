--- @class Hero50007_Skill3 Celestia
Hero50007_Skill3 = Class(Hero50007_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50007_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.healthTrigger = nil

    --- @type number
    self.healAmount = nil

    --- @type List<BaseHero>
    self.heroTriggerList = List()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50007_Skill3:CreateInstance(id, hero)
    return Hero50007_Skill3(id, hero)
end

--- @return void
function Hero50007_Skill3:Init()
    self.healthTrigger = self.data.healthTrigger
    self.healAmount = self.data.healAmount

    local listener = EventListener(self.myHero, self, self.OnHeroTakeDamage)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Hero50007_Skill3:OnHeroTakeDamage(eventData)
    if self.myHero:IsDead() == false then
        local target = eventData.target
        if self.myHero:IsAlly(target) then
            if target.hp:GetStatPercent() < self.healthTrigger then
                local healAmount = self.healAmount * self.myHero.attack:GetValue()
                if self.heroTriggerList:IsContainValue(target) == false then
                    HealUtils.Heal(self.myHero, target, healAmount, HealReason.HEAL_SKILL)
                    self.heroTriggerList:Add(target)
                end
            end
        end
    end
end

return Hero50007_Skill3