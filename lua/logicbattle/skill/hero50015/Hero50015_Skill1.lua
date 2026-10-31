--- @class Hero50015_Skill1 Navro
Hero50015_Skill1 = Class(Hero50015_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50015_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type number percent of damage deal by attack
    self.damage = 0

    --- @type number
    self.effectFaction = 0

    --- @type number
    self.effectAmount = 0

    --- @type number
    self.effectDuration = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50015_Skill1:CreateInstance(id, hero)
    return Hero50015_Skill1(id, hero)
end

--- @return void
function Hero50015_Skill1:Init()
    self.effectFaction = self.data.effectFaction
    self.effectAmount = self.data.effectAmount
    self.effectDuration = self.data.effectDuration

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

----------------------------------- Battle -------------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero50015_Skill1:UseActiveSkill()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero50015_Skill1:InflictEffect(target)
    if EffectUtils.CanAddEffect(target, EffectType.EXTRA_DAMAGE_TAKEN_BY_FACTION, false) == false then
        return
    end

    local effects = target.effectController:GetEffectWithType(EffectType.EXTRA_DAMAGE_TAKEN_BY_FACTION)
    local i = 1
    while i <= effects:Count() do
        local effectCurrent = effects:Get(i)
        if effectCurrent.initiator == self.myHero then
            effectCurrent:SetDuration(self.effectDuration)
            effectCurrent:SetInfo(self.effectFaction, self.effectAmount)
            return
        end
        i = i + 1
    end

    local effectNew = ExtraDamageTakenByFaction(self.myHero, target)
    effectNew:SetDuration(self.effectDuration)
    effectNew:SetInfo(self.effectFaction, self.effectAmount)

    target.effectController:AddEffect(effectNew)
end

return Hero50015_Skill1