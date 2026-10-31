--- @class Hero60024_Skill2 Dark Priest
Hero60024_Skill2 = Class(Hero60024_Skill2, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @param hero BaseHero
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60024_Skill2:CreateInstance(id, hero)
    return Hero60024_Skill2(id, hero)
end

--- @return void
function Hero60024_Skill2:Init()
    local listener = EventListener(self.myHero, self, self.OnHpChange)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return number
--- @param eventData table
function Hero60024_Skill2:OnHpChange(eventData)
    if self.myHero:IsDead() == false then
        local target = eventData.target
        if target == self.myHero then
            if self.myHero.randomHelper:RandomRate(self.data.healChance) then
                local damage = eventData.damage
                local healAmount = damage * self.data.healAmount

                HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_SKILL)
            end
        end
    end
end

return Hero60024_Skill2