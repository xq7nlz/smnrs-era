--- @class Summoner1_Skill1_2 : BaseSkill Mage
Summoner1_Skill1_2 = Class(Summoner1_Skill1_2, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner1_Skill1_2:CreateInstance(id, hero)
    return Summoner1_Skill1_2(id, hero)
end

--- @return void
function Summoner1_Skill1_2:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- Calculate Active skill ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Summoner1_Skill1_2:UseActiveSkill()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Summoner1_Skill1_2:InflictEffect(target)
    if self.myHero.randomHelper:RandomRate(self.data.statDebuffChance) then
        local statChanger = StatChanger(false)
        statChanger:SetInfo(self.data.statDebuffType, StatChangerCalculationType.PERCENT_ADD, self.data.statDebuffAmount)

        local effect = StatChangerEffect(self.myHero, target, false)
        effect:SetDuration(self.data.statDebuffDuration)
        effect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)
        effect:AddStatChanger(statChanger)

        target.effectController:AddEffect(effect)
    end
end

return Summoner1_Skill1_2