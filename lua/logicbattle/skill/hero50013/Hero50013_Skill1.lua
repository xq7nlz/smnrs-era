--- @class Hero50013_Skill1 Celes
Hero50013_Skill1 = Class(Hero50013_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50013_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type number percent of damage deal by attack
    self.damage = 0

    --- @type number
    self.statDebuffChance = 0

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
function Hero50013_Skill1:CreateInstance(id, hero)
    return Hero50013_Skill1(id, hero)

end

--- @return void
function Hero50013_Skill1:Init()
    self.statDebuffChance = self.data.statDebuffChance
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
function Hero50013_Skill1:UseActiveSkill()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero50013_Skill1:InflictEffect(target)
    if self.myHero.randomHelper:RandomRate(self.statDebuffChance) then
        local statChangerEffect = StatChangerEffect(self.myHero, target, false)
        statChangerEffect:SetDuration(self.statDebuffDuration)

        local statChanger = StatChanger(false)
        statChanger:SetInfo(self.statDebuffType, StatChangerCalculationType.PERCENT_ADD, self.statDebuffAmount)
        statChangerEffect:AddStatChanger(statChanger)

        target.effectController:AddEffect(statChangerEffect)
    end
end

return Hero50013_Skill1