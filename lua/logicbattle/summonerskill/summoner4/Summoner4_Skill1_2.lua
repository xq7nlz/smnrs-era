--- @class Summoner4_Skill1_2 : BaseSkill Assassin
Summoner4_Skill1_2 = Class(Summoner4_Skill1_2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner4_Skill1_2:Ctor(id, hero)
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
function Summoner4_Skill1_2:CreateInstance(id, hero)
    return Summoner4_Skill1_2(id, hero)
end

--- @return void
function Summoner4_Skill1_2:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.debuffChance = self.data.debuffChance
    self.debuffType = self.data.debuffType
    self.debuffDuration = self.data.debuffDuration
end

---------------------------------------- Calculate Active skill ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Summoner4_Skill1_2:UseActiveSkill()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Summoner4_Skill1_2:InflictEffect(target)
    if self.myHero.randomHelper:RandomRate(self.debuffChance) then
        local ccEffect = EffectUtils.CreateCCEffect(self.myHero, target, self.debuffType, self.debuffDuration)
        ccEffect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)

        target.effectController:AddEffect(ccEffect)
    end
end

return Summoner4_Skill1_2