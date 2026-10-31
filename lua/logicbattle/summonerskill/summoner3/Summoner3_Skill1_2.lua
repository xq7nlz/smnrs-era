--- @class Summoner3_Skill1_2 : BaseSkill Priest
Summoner3_Skill1_2 = Class(Summoner3_Skill1_2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner3_Skill1_2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type BaseTargetSelector
    self.targetSelector = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner3_Skill1_2:CreateInstance(id, hero)
    return Summoner3_Skill1_2(id, hero)

end

--- @return void
function Summoner3_Skill1_2:Init()
    self.effectChance = self.data.effectChance
    self.effectType = self.data.effectType
    self.effectDuration = self.data.effectDuration

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.SilenceTarget)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

----------------------------------- Battle -------------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Summoner3_Skill1_2:UseActiveSkill()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Summoner3_Skill1_2:SilenceTarget(target)
    if self.myHero.randomHelper:RandomRate(self.effectChance) then
        local silenceEffect = SilenceEffect(self.myHero, target, self.effectDuration)
        silenceEffect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)
        target.effectController:AddEffect(silenceEffect)
    end
end

return Summoner3_Skill1_2