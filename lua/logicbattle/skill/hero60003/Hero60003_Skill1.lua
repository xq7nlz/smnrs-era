--- @class Hero60003_Skill1 ShadowBlade
Hero60003_Skill1 = Class(Hero60003_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60003_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.firstChance = 0

    --- @type number
    self.firstMultiDamage = 0

    --- @type number
    self.secondChance = 0

    --- @type number
    self.secondMultiDamage = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60003_Skill1:CreateInstance(id, hero)
    return Hero60003_Skill1(id, hero)
end

--- @return void
function Hero60003_Skill1:Init()
    self.firstChance = self.data.firstChance
    self.firstMultiDamage = self.data.firstMultiDamage
    self.secondChance = self.data.secondChance
    self.secondMultiDamage = self.data.secondMultiDamage

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.myHero.battleHelper:BindingWithSkill_1(self)
end

---------------------------------------- BATTLE -----------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero60003_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)
    local result = self.damageSkillHelper:UseDamageSkill(targetList)

    local isEndTurn = true

    return result, isEndTurn
end

--- @return number
function Hero60003_Skill1:GetBonusMultiplierSkill()
    local multiplier = 1

    local totalRate = self.firstChance + self.secondChance
    if self.myHero.randomHelper:RandomRate(totalRate) then
        --- damage can be multiplied
        local modifiedFirstChance = self.firstChance / totalRate
        if self.myHero.randomHelper:RandomRate(modifiedFirstChance) then
            multiplier = self.firstMultiDamage
        else
            multiplier = self.secondMultiDamage
        end
    end

    return multiplier
end

return Hero60003_Skill1