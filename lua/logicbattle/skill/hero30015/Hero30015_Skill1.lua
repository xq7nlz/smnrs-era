--- @class Hero30015_Skill1 Fang
Hero30015_Skill1 = Class(Hero30015_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30015_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type number
    self.dotChance = 0

    --- @type number
    self.dotType = 0

    --- @type number
    self.dotDuration = 0

    --- @type number
    self.dotAmount = 0
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30015_Skill1:CreateInstance(id, hero)
    return Hero30015_Skill1(id, hero)
end

--- @return void
function Hero30015_Skill1:Init()
    self.dotChance = self.data.dotChance
    self.dotType = self.data.dotType

    self.dotDuration = self.data.dotDuration
    self.dotAmount = self.data.dotAmount

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero30015_Skill1:UseActiveSkill()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero30015_Skill1:InflictEffect(target)
    if self.myHero.randomHelper:RandomRate(self.dotChance) then
        local dotEffect = EffectUtils.CreateDotEffect(self.myHero, target, self.dotType, self.dotDuration, self.dotAmount)
        target.effectController:AddEffect(dotEffect)
    end
end

return Hero30015_Skill1