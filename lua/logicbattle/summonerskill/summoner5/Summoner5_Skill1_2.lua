--- @class Summoner5_Skill1_2 : BaseSkill Ranger
Summoner5_Skill1_2 = Class(Summoner5_Skill1_2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner5_Skill1_2:Ctor(id, hero)
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
function Summoner5_Skill1_2:CreateInstance(id, hero)
    return Summoner5_Skill1_2(id, hero)
end

--- @return void
function Summoner5_Skill1_2:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.damageReceiveDebuffAmount = self.data.damageReceiveDebuffAmount
    self.damageReceiveDebuffDuration = self.data.damageReceiveDebuffDuration
end

---------------------------------------- Calculate Active skill ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Summoner5_Skill1_2:UseActiveSkill()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Summoner5_Skill1_2:InflictEffect(target)
    ---@type ExtraDamageTaken
    local effect = ExtraDamageTaken(self.myHero, target)
    effect:SetDuration(self.damageReceiveDebuffDuration)
    effect:SetDamageReceiveDebuffAmount(self.damageReceiveDebuffAmount)
    effect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)

    target.effectController:AddEffect(effect)
end

return Summoner5_Skill1_2