--- @class Hero40002_Skill2 Yggra
Hero40002_Skill2 = Class(Hero40002_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40002_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type EffectType
    self.effectType = nil
    --- @type number
    self.effectDuration = nil
    --- @type StatType
    self.effectAffectStat = nil
    --- @type number
    self.effectAmount = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40002_Skill2:CreateInstance(id, hero)
    return Hero40002_Skill2(id, hero)
end

--- @return void
function Hero40002_Skill2:Init()
    self.effectType = self.data.effectType
    self.effectDuration = self.data.effectDuration
    self.effectAffectStat = self.data.effectAffectStat
    self.effectAmount = self.data.effectAmount

    self.myHero.attackListener:BindingWithSkill_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero40002_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        local statChanger = StatChanger(false)
        statChanger:SetInfo(self.effectAffectStat, StatChangerCalculationType.PERCENT_ADD, self.effectAmount)

        local effect = StatChangerEffect(self.myHero, enemyDefender, false)
        effect:SetDuration(self.effectDuration)
        effect:AddStatChanger(statChanger)

        enemyDefender.effectController:AddEffect(effect)
    end
end

return Hero40002_Skill2