require "lua.logicBattle.skill.hero30011.Hero30011_Utils"

--- @class Hero30011_Skill1 Skaven
Hero30011_Skill1 = Class(Hero30011_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30011_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type number
    self.effectAmount = nil
    --- @type EffectType
    self.effectType = nil
    --- @type number
    self.effectDuration = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30011_Skill1:CreateInstance(id, hero)
    return Hero30011_Skill1(id, hero)
end

--- @return void
function Hero30011_Skill1:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.effectAmount = self.data.effectAmount
    self.effectType = self.data.effectType
    self.effectDuration = self.data.effectDuration
end

---------------------------------------- Calculate Active skill ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero30011_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)
    local results = self.damageSkillHelper:UseDamageSkill(targetList)

    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero30011_Skill1:InflictEffect(target)
    if Hero30011_Utils.IsContainSkavenPoison(target, 1) == false and target:IsBoss() == false then
        local amount = target.hp:GetMax() * self.effectAmount

        local dotEffect = Hero30011_PoisonEffect(self.myHero, target, 1)
        dotEffect:SetDuration(self.effectDuration)
        dotEffect:SetDotAmount(amount)

        target.effectController:AddEffect(dotEffect)
    end
end

return Hero30011_Skill1