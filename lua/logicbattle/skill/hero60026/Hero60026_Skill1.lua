--- @class Hero60026_Skill1 Vampire
Hero60026_Skill1 = Class(Hero60026_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60026_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.damageTargetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60026_Skill1:CreateInstance(id, hero)
    return Hero60026_Skill1(id, hero)
end

--- @return void
function Hero60026_Skill1:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

----------------------------------- Battle -------------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero60026_Skill1:UseActiveSkill()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
    local results = self.damageSkillHelper:UseDamageSkill(targetList)

    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero60026_Skill1:InflictEffect(target)
    if self.myHero.randomHelper:RandomRate(self.data.statDebuffChance) then
        local statChanger = StatChanger(false)
        statChanger:SetInfo(self.data.statDebuffType, StatChangerCalculationType.PERCENT_ADD, self.data.statDebuffAmount)

        local effect = StatChangerEffect(self.myHero, target, false)
        effect:SetDuration(self.data.statDebuffDuration)
        effect:AddStatChanger(statChanger)

        target.effectController:AddEffect(effect)
    end
end

return Hero60026_Skill1