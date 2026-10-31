--- @class Hero30024_Skill1 Ozroth
Hero30024_Skill1 = Class(Hero30024_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30024_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil
    --- @type DamageSkillHelper
    self.damageSkillHelper = nil
    --- @type number
    self.statDebuffChange = 0
    --- @type StatType
    self.statDebuffType = nil
    --- @type number
    self.statDebuffAmount = 0
    --- @type number
    self.statDebuffDuration = 0
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30024_Skill1:CreateInstance(id, hero)
    return Hero30024_Skill1(id, hero)
end

--- @return void
function Hero30024_Skill1:Init()
    self.statDebuffChange = self.data.statDebuffChange
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
function Hero30024_Skill1:UseActiveSkill()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero30024_Skill1:InflictEffect(target)
    if self.myHero.randomHelper:RandomRate(self.statDebuffChange) then
        local statDebuff = StatChanger(false)
        statDebuff:SetInfo(self.statDebuffType, StatChangerCalculationType.PERCENT_ADD, self.statDebuffAmount)

        local effectDebuffPassive = StatChangerEffect(self.myHero, target, false)
        effectDebuffPassive:SetDuration(self.statDebuffDuration)
        effectDebuffPassive:AddStatChanger(statDebuff)
        target.effectController:AddEffect(effectDebuffPassive)
    end
end

return Hero30024_Skill1