--- @class Hero20006_Skill1 Finde
Hero20006_Skill1 = Class(Hero20006_Skill1, BaseSkill)

--- @return BaseSkill
function Hero20006_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    ---@type BaseTargetSelector
    self.targetSelector = nil

    ---@type EffectType
    self.effectType = nil

    ---@type number
    self.effectChance = nil

    ---@type number
    self.effectDuration = nil

    ---@type number
    self.powerReceiveAmount = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20006_Skill1:CreateInstance(id, hero)
    return Hero20006_Skill1(id, hero)
end

--- @return void
function Hero20006_Skill1:Init()
    self.effectType = self.data.effectType
    self.effectChance = self.data.effectChance
    self.effectDuration = self.data.effectDuration
    self.powerReceiveAmount = self.data.powerReceiveAmount

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.target_position,
            TargetTeamType.ENEMY, self.data.target_number)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

------------------------------------------Battle-----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero20006_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.target_position,
            TargetTeamType.ENEMY, self.data.target_number)
    local results = self.damageSkillHelper:UseDamageSkill(targetList)

    self:PowerBuff()

    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero20006_Skill1:InflictEffect(target)
    if self.myHero.randomHelper:RandomRate(self.effectChance) then
        local ccEffect = EffectUtils.CreateCCEffect(self.myHero, target, self.effectType, self.effectDuration)
        target.effectController:AddEffect(ccEffect)
    end
end

--- @return void
function Hero20006_Skill1:PowerBuff()
    PowerUtils.GainPower(self.myHero, self.myHero, self.powerReceiveAmount, false)
end

return Hero20006_Skill1