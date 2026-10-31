--- @class Hero30024_Skill3 Ozroth
Hero30024_Skill3 = Class(Hero30024_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30024_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    ---@type number
    self.statBuffChance = nil
    ---@type EffectType
    self.statBuffType = nil
    ---@type number
    self.statBuffAmount = nil
    ---@type number
    self.statBuffDuration = nil
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero30024_Skill3:CreateInstance(id, hero)
    return Hero30024_Skill3(id, hero)
end

--- @return void
function Hero30024_Skill3:Init()
    self.statBuffChance = self.data.statBuffChance
    self.statBuffType = self.data.statBuffType
    self.statBuffAmount = self.data.statBuffAmount
    self.statBuffDuration = self.data.statBuffDuration

    self.myHero.attackListener:BindingWithSkill_3(self)
    self.myHero.skillListener:BindingWithSkill_3(self)
end

-----------------------------------------Battle---------------------------------------
--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero30024_Skill3:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if totalDamage > 0 then
        self:InflictEffect(enemyAttacker)
    end
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero30024_Skill3:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if totalDamage > 0 then
        self:InflictEffect(enemy)
    end
end

--- @return void
--- @param enemyAttacker BaseHero
function Hero30024_Skill3:InflictEffect(enemyAttacker)
    if self.myHero.randomHelper:RandomRate(self.statBuffChance) then
        local effectBuffStat = StatChangerEffect(self.myHero, self.myHero, true)
        effectBuffStat:SetDuration(self.statBuffDuration)

        local effectBuff = StatChanger(true)
        effectBuff:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)
        effectBuffStat:AddStatChanger(effectBuff)

        self.myHero.effectController:AddEffect(effectBuffStat)
    end
end

return Hero30024_Skill3