--- @class Hero30027_Skill1 : BaseSkill Kazetsu
Hero30027_Skill1 = Class(Hero30027_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30027_Skill1:Ctor(id, hero)
    --- @type Hero30027_Skill1_Data
    self.data = nil
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.enemyTargetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type number
    self.healthTrigger = 0

    --- @type number
    self.healChance = 0

    --- @type number
    self.healAmount = 0
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30027_Skill1:CreateInstance(id, hero)
    return Hero30027_Skill1(id, hero)
end

--- @return void
function Hero30027_Skill1:Init()
    --- @type HighestAttackSelector
    self.enemyTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.enemyTargetPosition,
            TargetTeamType.ENEMY, self.data.enemyTargetNumber)

    self.statDebuffType = self.data.statDebuffType
    self.statDebuffDuration = self.data.statDebuffDuration
    self.statDebuffAmount = self.data.statDebuffAmount
    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.healthTrigger = self.data.healthTrigger
    self.healChance = self.data.healChance
    self.healAmount = self.data.healAmount
    self.myHero.skillListener:BindingWithSkill_1(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero30027_Skill1:UseActiveSkill()
    --- @type List
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.enemyTargetPosition,
            TargetTeamType.ENEMY, self.data.enemyTargetNumber)
    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true
    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero30027_Skill1:InflictEffect(target)
    local statChanger = StatChanger(false)
    statChanger:SetInfo(self.statDebuffType, StatChangerCalculationType.PERCENT_ADD, self.statDebuffAmount)
    local effect = StatChangerEffect(self.myHero, target, false)
    effect:SetDuration(self.statDebuffDuration)
    effect:AddStatChanger(statChanger)
    target.effectController:AddEffect(effect)
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero30027_Skill1:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    self:TriggerHeal(enemyTarget, totalDamage)
end

--- @return void
--- @param target BaseHero
--- @param totalDamage number
function Hero30027_Skill1:TriggerHeal(target, totalDamage)
    if self.myHero.hp:GetStatPercent() < self.healthTrigger and self.myHero.randomHelper:RandomRate(self.healChance) then
        local healAmount = self.healAmount * totalDamage
        HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_SKILL)
    end
end

return Hero30027_Skill1