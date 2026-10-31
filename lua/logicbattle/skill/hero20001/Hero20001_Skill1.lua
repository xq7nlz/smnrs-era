--- @class Hero20001_Skill1 Icarus
Hero20001_Skill1 = Class(Hero20001_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20001_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type number
    self.effectChance = nil
    --- @type number
    self.effectDuration = nil

    --- @type StatType
    self.statDebuffType = nil
    --- @type number
    self.statDebuffCalculationType = nil
    --- @type number
    self.statDebuffAmount = nil

    --- @type EffectType
    self.effectDebuffType = nil
    --- @type number
    self.effectDebuffAmount = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20001_Skill1:CreateInstance(id, hero)
    return Hero20001_Skill1(id, hero)
end

--- @return void
function Hero20001_Skill1:Init()
    self.effectChance = self.data.effectChance
    self.effectDuration = self.data.effectDuration

    self.statDebuffType = self.data.statDebuffType
    self.statDebuffCalculationType = self.data.statDebuffCalculationType
    self.statDebuffAmount = self.data.statDebuffAmount

    self.effectDebuffType = self.data.effectDebuffType
    self.effectDebuffAmount = self.data.effectDebuffAmount

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- Calculate Active skill ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero20001_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero20001_Skill1:InflictEffect(target)
    if self.myHero.randomHelper:RandomRate(self.effectChance) then
        local statChanger = StatChanger(false)
        statChanger:SetInfo(self.statDebuffType, self.statDebuffCalculationType, self.statDebuffAmount)

        local effect = StatChangerEffect(self.myHero, target, false)
        effect:SetDuration(self.effectDuration)
        effect:AddStatChanger(statChanger)

        target.effectController:AddEffect(effect)

        local dotEffect = EffectUtils.CreateDotEffect(self.myHero, target, self.effectDebuffType, self.effectDuration, self.effectDebuffAmount)
        target.effectController:AddEffect(dotEffect)
    end
end

return Hero20001_Skill1