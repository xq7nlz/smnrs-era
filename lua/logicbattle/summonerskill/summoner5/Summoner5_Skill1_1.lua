--- @class Summoner5_Skill1_1 : BaseSkill Ranger
Summoner5_Skill1_1 = Class(Summoner5_Skill1_1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner5_Skill1_1:Ctor(id, hero)
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
function Summoner5_Skill1_1:CreateInstance(id, hero)
    return Summoner5_Skill1_1(id, hero)
end

--- @return void
function Summoner5_Skill1_1:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.statDebuffType = self.data.statDebuffType
    self.statDebuffChance = self.data.statDebuffChance
    self.statDebuffDuration = self.data.statDebuffDuration
    self.statDebuffAmount = self.data.statDebuffAmount
end

---------------------------------------- Calculate Active skill ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Summoner5_Skill1_1:UseActiveSkill()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Summoner5_Skill1_1:InflictEffect(target)
    if self.myHero.randomHelper:RandomRate(self.statDebuffChance) then
        local statChanger = StatChanger(false)
        statChanger:SetInfo(self.statDebuffType, StatChangerCalculationType.PERCENT_ADD, self.statDebuffAmount)
        ---@type StatChangerEffect
        local effect = StatChangerEffect(self.myHero, target, false)
        effect:SetDuration(self.statDebuffDuration)
        effect:AddStatChanger(statChanger)
        effect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)

        target.effectController:AddEffect(effect)
    end
end

return Summoner5_Skill1_1
