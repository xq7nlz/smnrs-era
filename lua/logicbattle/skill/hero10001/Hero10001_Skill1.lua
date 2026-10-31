--- @class Hero10001_Skill1 ColdAxe
Hero10001_Skill1 = Class(Hero10001_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10001_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10001_Skill1:CreateInstance(id, hero)
    return Hero10001_Skill1(id, hero)
end

--- @return void
function Hero10001_Skill1:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- Calculate Active skill ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero10001_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero10001_Skill1:InflictEffect(target)
    if self.myHero.randomHelper:RandomRate(self.data.statDebuffChance) then
        local statChanger = StatChanger(false)
        statChanger:SetInfo(self.data.statDebuffType, StatChangerCalculationType.PERCENT_ADD, self.data.statDebuffAmount)

        local effect = StatChangerEffect(self.myHero, target, false)
        effect:SetDuration(self.data.statDebuffDuration)
        effect:AddStatChanger(statChanger)

        target.effectController:AddEffect(effect)
    end

    if self.myHero.randomHelper:RandomRate(self.data.effectChance) then
        local ccEffect = EffectUtils.CreateCCEffect(self.myHero, target, self.data.effectType, self.data.effectDuration)
        target.effectController:AddEffect(ccEffect)
    end
end

return Hero10001_Skill1