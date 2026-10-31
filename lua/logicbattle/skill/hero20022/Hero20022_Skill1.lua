--- @class Hero20022_Skill1 Imp
Hero20022_Skill1 = Class(Hero20022_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20022_Skill1:Ctor(id, hero)
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
function Hero20022_Skill1:CreateInstance(id, hero)
    return Hero20022_Skill1(id, hero)
end

--- @return void
function Hero20022_Skill1:Init()
    self.statDebuffType = self.data.statDebuffType
    self.statDebuffCalculationType = self.data.statDebuffCalculationType
    self.statDebuffAmount = self.data.statDebuffAmount
    self.statDebuffDuration = self.data.statDebuffDuration

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero20022_Skill1:UseActiveSkill()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero20022_Skill1:InflictEffect(target)
    local statChanger = StatChanger(false)
    statChanger:SetInfo(self.statDebuffType, self.statDebuffCalculationType, self.statDebuffAmount)

    local effect = StatChangerEffect(self.myHero, target, false)
    effect:SetDuration(self.statDebuffDuration)
    effect:AddStatChanger(statChanger)

    target.effectController:AddEffect(effect)
end

return Hero20022_Skill1