--- @class Summoner3_Skill4_3 : BaseSkill Priest
Summoner3_Skill4_3 = Class(Summoner3_Skill4_3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner3_Skill4_3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type List<BaseHero>
    self.listTrigger = List()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner3_Skill4_3:CreateInstance(id, hero)
    return Summoner3_Skill4_3(id, hero)
end

--- @return void
function Summoner3_Skill4_3:Init()
    local listener = EventListener(self.myHero, self, self.OnHeroTakeDamage)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)

    self.healTrigger = self.data.healTrigger
    self.healChance = self.data.healChance
    self.healAmount = self.data.healAmount
end

-----------------------------------------------------------------------------------------------
--- @return void
--- @param eventData table
function Summoner3_Skill4_3:OnHeroTakeDamage(eventData)
    --- @type BaseHero
    local target = eventData.target
    if target:IsDead() == false
            and self.listTrigger:IsContainValue(target) == false
            and self.myHero:IsAlly(target)
            and target.hp:GetStatPercent() < self.healTrigger then
        self:TriggerHeal(target)
    end
end

--- @return void
--- @param target BaseHero
function Summoner3_Skill4_3:TriggerHeal(target)
    self.listTrigger:Add(target)
    local amount = self.myHero.attack:GetValue() * self.healAmount
    HealUtils.Heal(self.myHero, target, amount, HealReason.SUMMONER_HEAL)
end

return Summoner3_Skill4_3