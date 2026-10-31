--- @class Hero40016_Skill1 Roo
Hero40016_Skill1 = Class(Hero40016_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40016_Skill1:Ctor(id, hero)
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
function Hero40016_Skill1:CreateInstance(id, hero)
    return Hero40016_Skill1(id, hero)
end

--- @return void
function Hero40016_Skill1:Init()
    self.targetHpPercent = self.data.targetHpPercent
    self.dotType = self.data.dotType
    self.dotAmount = self.data.dotAmount
    self.dotDuration = self.data.dotDuration

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero40016_Skill1:UseActiveSkill()
    local affectedTargets = List()

    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        if target.hp:GetStatPercent() >= self.targetHpPercent then
            affectedTargets:Add(target)
        end
        i = i + 1
    end

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    i = 1
    while i <= affectedTargets:Count() do
        local target = affectedTargets:Get(i)

        local dotEffect = EffectUtils.CreateDotEffect(self.myHero, target, self.dotType, self.dotDuration, self.dotAmount)
        target.effectController:AddEffect(dotEffect)
        i = i + 1
    end

    return results, isEndTurn
end

return Hero40016_Skill1