--- @class Hero20014_Skill1 Khezzec
Hero20014_Skill1 = Class(Hero20014_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20014_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type BaseTargetSelector
    self.powerBuffTargetSelector = nil
    --- @type number
    self.powerBuffAmount = nil

end

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20014_Skill1:CreateInstance(id, hero)
    return Hero20014_Skill1(id, hero)
end

--- @return void
function Hero20014_Skill1:Init()
    self.powerBuffAmount = self.data.powerBuffAmount

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.powerBuffTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.powerBuffTargetPosition,
            TargetTeamType.ALLY, self.data.powerBuffTargetNumber)
    self.powerBuffTargetSelector:SetIncludeSelf(false)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero20014_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)
    local result = self.damageSkillHelper:UseDamageSkill(targetList)

    self:PowerBuff()
    local isEndTurn = true

    return result, isEndTurn
end

--- @return void
function Hero20014_Skill1:PowerBuff()
    --- buff power
    local targetList = self.powerBuffTargetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        PowerUtils.GainPower(self.myHero, target, self.powerBuffAmount, false)
        i = i + 1
    end
end

return Hero20014_Skill1