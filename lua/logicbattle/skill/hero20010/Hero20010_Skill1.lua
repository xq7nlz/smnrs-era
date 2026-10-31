--- @class Hero20010_Skill1 Ungoliant
Hero20010_Skill1 = Class(Hero20010_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20010_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type StatType
    self.statDebuffType = nil
    --- @type number
    self.statDebuffAmount = 0
    --- @type number
    self.statDebuffCalculationType = 0
    --- @type number
    self.statDebuffDuration = 0
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20010_Skill1:CreateInstance(id, hero)
    return Hero20010_Skill1(id, hero)
end

--- @return void
function Hero20010_Skill1:Init()
    self.statDebuffDuration = self.data.statDebuffDuration

    self.statDebuffType = self.data.statDebuffType
    self.statDebuffAmount = self.data.statDebuffAmount
    self.statDebuffCalculationType = self.data.statDebuffCalculationType

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero20010_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero20010_Skill1:InflictEffect(target)
    local statDebuff = StatChanger(false)
    statDebuff:SetInfo(self.statDebuffType, self.statDebuffCalculationType, self.statDebuffAmount)

    local effectDebuff = StatChangerEffect(self.myHero, target, false)
    effectDebuff:SetDuration(self.statDebuffDuration)
    effectDebuff:AddStatChanger(statDebuff)
    target.effectController:AddEffect(effectDebuff)
end

return Hero20010_Skill1