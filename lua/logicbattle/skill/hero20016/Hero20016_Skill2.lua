--- @class Hero20016_Skill2 Ifrit
Hero20016_Skill2 = Class(Hero20016_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20016_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type StatType
    self.statBuffType = nil
    --- @type number
    self.statBuffAmount = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
---
--- @param hero BaseHero
function Hero20016_Skill2:CreateInstance(id, hero)
    return Hero20016_Skill2(id, hero)
end

--- @return void
function Hero20016_Skill2:Init()
    self.statBuffType = self.data.statBuffType
    self.statBuffAmount = self.data.statBuffAmount

    self.myHero.attackListener:BindingWithSkill_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero20016_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    local statChanger = StatChanger(true)
    statChanger:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)

    local effect = StatChangerEffect(self.myHero, self.myHero, true)
    effect:SetPersistentType(EffectPersistentType.LOST_WHEN_DEAD)
    effect:AddStatChanger(statChanger)

    self.myHero.effectController:AddEffect(effect)
end

return Hero20016_Skill2