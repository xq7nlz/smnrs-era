--- @class Hero20008_Skill1 Moblin
Hero20008_Skill1 = Class(Hero20008_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20008_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type number percent of damage deal by attack
    self.damage = 0

    --- @type number
    self.statDebuffType = 0

    --- @type number
    self.statDebuffAmount = 0

    --- @type number
    self.statDebuffDuration = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20008_Skill1:CreateInstance(id, hero)
    return Hero20008_Skill1(id, hero)
end

--- @return void
function Hero20008_Skill1:Init()
    self.statDebuffType = self.data.statDebuffType
    self.statDebuffAmount = self.data.statDebuffAmount
    self.statDebuffDuration = self.data.statDebuffDuration

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

----------------------------------- Battle -------------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero20008_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)
    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero20008_Skill1:InflictEffect(target)
    local statChanger = StatChanger(false)
    statChanger:SetInfo(self.statDebuffType, StatChangerCalculationType.PERCENT_ADD, self.statDebuffAmount)

    local statChangerEffect = StatChangerEffect(self.myHero, target, false)
    statChangerEffect:AddStatChanger(statChanger)
    statChangerEffect:SetDuration(self.statDebuffDuration)

    target.effectController:AddEffect(statChangerEffect)
end

return Hero20008_Skill1