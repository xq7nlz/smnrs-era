--- @class Summoner5_Skill1_3 : BaseSkill Ranger
Summoner5_Skill1_3 = Class(Summoner5_Skill1_3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner5_Skill1_3:Ctor(id, hero)
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
function Summoner5_Skill1_3:CreateInstance(id, hero)
    return Summoner5_Skill1_3(id, hero)
end

--- @return void
function Summoner5_Skill1_3:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.debuffChance = self.data.debuffChance
    self.debuffType = self.data.debuffType
    self.debuffAmount = self.data.debuffAmount
    self.debuffDuration = self.data.debuffDuration
end

---------------------------------------- Calculate Active skill ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Summoner5_Skill1_3:UseActiveSkill()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Summoner5_Skill1_3:InflictEffect(target)
    if self.myHero.randomHelper:RandomRate(self.debuffChance) then
        ---@type DotEffect
        local dotEffect = EffectUtils.CreateDotEffect(self.myHero, target, self.debuffType, self.debuffDuration, self.debuffAmount)
        dotEffect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)

        target.effectController:AddEffect(dotEffect)
    end
end

return Summoner5_Skill1_3