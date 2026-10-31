--- @class Hero30022_Skill1 Dungan
Hero30022_Skill1 = Class(Hero30022_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30022_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type number
    self.effectChance = 0

    --- @type number
    self.effectType = 0

    --- @type number
    self.effectDuration = 0

    --- @type number
    self.effectAmount = 0

end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30022_Skill1:CreateInstance(id, hero)
    return Hero30022_Skill1(id, hero)
end

--- @return void
function Hero30022_Skill1:Init()
    self.effectChance = self.data.effectChance
    self.effectType = self.data.effectType

    self.effectDuration = self.data.effectDuration
    self.effectAmount = self.data.effectAmount

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero30022_Skill1:UseActiveSkill()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero30022_Skill1:InflictEffect(target)
    if self.myHero.randomHelper:RandomRate(self.effectChance) then
        local dotEffect = EffectUtils.CreateDotEffect(self.myHero, target, self.effectType, self.effectDuration, self.effectAmount)
        target.effectController:AddEffect(dotEffect)
    end
end

return Hero30022_Skill1