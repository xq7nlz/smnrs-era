--- @class Hero10010_Skill2 Japulan
Hero10010_Skill2 = Class(Hero10010_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10010_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    ---@type number
    self.statBuffChance = nil
    ---@type EffectType
    self.statBuffType = nil
    ---@type number
    self.statBuffAmount = nil
    ---@type number
    self.statBuffDuration = nil

    --- @type StatChangerEffect
    self.statChangerEffect = nil
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero10010_Skill2:CreateInstance(id, hero)
    return Hero10010_Skill2(id, hero)
end

--- @return void
function Hero10010_Skill2:Init()
    self.statBuffChance = self.data.statBuffChance
    self.statBuffType = self.data.statBuffType
    self.statBuffAmount = self.data.statBuffAmount
    self.statBuffDuration = self.data.statBuffDuration

    local statChangerEffect = StatChanger(true)
    statChangerEffect:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)

    self.statChangerEffect = StatChangerEffect(self.myHero, self.myHero, true)
    self.statChangerEffect:AddStatChanger(statChangerEffect)

    self.myHero.attackListener:BindingWithSkill_2(self)
    self.myHero.skillListener:BindingWithSkill_2(self)
end

-----------------------------------------Battle---------------------------------------
--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero10010_Skill2:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if totalDamage > 0 then
        self:BuffStat(enemyAttacker)
    end
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero10010_Skill2:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if totalDamage > 0 then
        self:BuffStat(enemy)
    end
end

--- @return void
--- @param enemyAttacker BaseHero
function Hero10010_Skill2:BuffStat(enemyAttacker)
    if self.myHero.randomHelper:RandomRate(self.statBuffChance) then
        if self.myHero.effectController:IsContainEffect(self.statChangerEffect) == false then
            self.statChangerEffect:SetDuration(self.statBuffDuration)
            self.myHero.effectController:AddEffect(self.statChangerEffect)
        end
    end
end

return Hero10010_Skill2