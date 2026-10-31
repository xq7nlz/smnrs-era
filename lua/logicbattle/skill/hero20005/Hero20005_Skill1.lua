--- @class Hero20005_Skill1 Yin
Hero20005_Skill1 = Class(Hero20005_Skill1, BaseSkill)

--- @return BaseSkill
function Hero20005_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type EffectType
    self.dotType = nil

    --- @type number
    self.dotAmount = nil

    --- @type number
    self.dotChance = nil

    --- @type number
    self.dotDuration = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20005_Skill1:CreateInstance(id, hero)
    return Hero20005_Skill1(id, hero)
end

--- @return void
function Hero20005_Skill1:Init()
    self.dotType = self.data.dotType
    self.dotAmount = self.data.dotAmount
    self.dotChance = self.data.dotChance
    self.dotDuration = self.data.dotDuration

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.BurnTarget)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

------------------------------------------Battle-----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero20005_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)
    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero20005_Skill1:BurnTarget(target)
    if self.myHero.randomHelper:RandomRate(self.dotChance) then
        local amount = self.dotAmount * self.myHero.skillController:GetBonusDotDamage()

        local dotEffect = EffectUtils.CreateDotEffect(self.myHero, target, self.dotType, self.dotDuration, amount)
        target.effectController:AddEffect(dotEffect)
    end
end

return Hero20005_Skill1