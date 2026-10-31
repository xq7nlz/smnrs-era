--- @class Hero10011_Skill2 Jeronim
Hero10011_Skill2 = Class(Hero10011_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10011_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    ---@type number
    self.statBuffChance = nil
    ---@type EffectType
    self.statBuffType = nil
    ---@type number
    self.statBuffAmount = nil

    ---@type StatChanger
    self.statChanger = nil
    --- @type StatChangerEffect
    self.statChangerEffect = nil
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero10011_Skill2:CreateInstance(id, hero)
    return Hero10011_Skill2(id, hero)
end

--- @return void
function Hero10011_Skill2:Init()
    self.statBuffChance = self.data.statBuffChance
    self.statBuffType = self.data.statBuffType
    self.statBuffAmount = self.data.statBuffAmount

    self.statChanger = StatChanger(true)
    self.statChanger:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)

    self.statChangerEffect = StatChangerEffect(self.myHero, self.myHero, true)
    self.statChangerEffect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL)
    self.statChangerEffect:AddStatChanger(self.statChanger)

    self.myHero.attackListener:BindingWithSkill_2(self)
    self.myHero.attackController:BindingWithSkill_2(self)
    self.myHero.skillListener:BindingWithSkill_2(self)
end

-----------------------------------------Battle---------------------------------------
--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero10011_Skill2:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if totalDamage > 0 then
        self:BuffStat(enemyAttacker)
    end
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero10011_Skill2:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if totalDamage > 0 then
        self:BuffStat(enemy)
    end
end

--- @return void
function Hero10011_Skill2:AfterAttack()
    self:RemoveBuff()
end

--- @return void
function Hero10011_Skill2:AfterSkill()
    self:RemoveBuff()
end

--- @return void
function Hero10011_Skill2:RemoveBuff()
    self.myHero.effectController:ForceRemove(self.statChangerEffect)
end

--- @return void
--- @param enemyAttacker BaseHero
function Hero10011_Skill2:BuffStat(enemyAttacker)
    if self.myHero.randomHelper:RandomRate(self.statBuffChance) then
        if self.myHero.effectController:IsContainEffect(self.statChangerEffect) == false then
            self.statChanger:SetAmount(self.statBuffAmount)
            self.myHero.effectController:AddEffect(self.statChangerEffect)
        else
            self.statChanger:SetAmount(self.statChanger:GetAmount() + self.statBuffAmount)
            self.statChangerEffect:Recalculate()
        end
    end
end

return Hero10011_Skill2