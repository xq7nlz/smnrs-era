--- @class Hero20006_Skill2 Finde
Hero20006_Skill2 = Class(Hero20006_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20006_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    ---@type number
    self.effectChance = nil
    ---@type EffectType
    self.effectType = nil
    ---@type number
    self.effectDotAmount = nil
    ---@type StatType
    self.effectStatDebuffType = nil
    ---@type number
    self.effectStatDebuffAmount = nil
    ---@type number
    self.effectDuration = nil
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero20006_Skill2:CreateInstance(id, hero)
    return Hero20006_Skill2(id, hero)
end

--- @return void
function Hero20006_Skill2:Init()
    self.effectChance = self.data.effectChance
    self.effectType = self.data.effectType

    self.effectDotAmount = self.data.effectDotAmount

    self.effectStatDebuffType = self.data.effectStatDebuffType
    self.effectStatDebuffAmount = self.data.effectStatDebuffAmount
    self.effectDuration = self.data.effectDuration

    self.myHero.attackListener:BindingWithSkill_2(self)
    self.myHero.skillListener:BindingWithSkill_2(self)
end

-----------------------------------------Battle---------------------------------------
--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero20006_Skill2:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if totalDamage > 0 then
        self:BurningMarkTarget(enemyAttacker)
    end
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero20006_Skill2:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if totalDamage > 0 then
        self:BurningMarkTarget(enemy)
    end
end

--- @return void
--- @param enemyAttacker BaseHero
function Hero20006_Skill2:BurningMarkTarget(enemyAttacker)
    if self.myHero.randomHelper:RandomRate(self.effectChance) then
        local amount = self.effectDotAmount

        local dotEffect = BurningMark(self.myHero, enemyAttacker)
        dotEffect:SetDotAmount(amount)
        dotEffect:SetDuration(self.effectDuration)

        local statChanger = StatChanger(false)
        statChanger:SetInfo(self.effectStatDebuffType, StatChangerCalculationType.PERCENT_ADD, self.effectStatDebuffAmount)
        dotEffect:AddStatChanger(statChanger)
        dotEffect:SetPersistentType(self.myHero.effectController:GetPersistentTypeBurningMark())

        local isBurnMark = enemyAttacker.effectController:IsContainEffectType(EffectType.BURNING_MARK)
        if isBurnMark == false then
            enemyAttacker.effectController:AddEffect(dotEffect)
        end
    end
end

return Hero20006_Skill2