--- @class Hero30005_Skill3 Jormungand
Hero30005_Skill3 = Class(Hero30005_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30005_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    ---@type number
    self.venomStackDamage = nil

    --- @type number
    self.venomStackDuration = nil

    --- @type number
    self.numberStack = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30005_Skill3:CreateInstance(id, hero)
    return Hero30005_Skill3(id, hero)
end

--- @return void
function Hero30005_Skill3:Init()
    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    self.myHero.attackController:SetSelector(targetSelector)

    self.venomStackDamage = self.data.venomStackDamage
    self.venomStackDuration = self.data.venomStackDuration
    self.numberStack = self.data.numberStack

    self.myHero.attackListener:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero30005_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        Hero30005_Utils.InflictVenomStack(self.myHero, enemyDefender,
                self.venomStackDamage, self.venomStackDuration, self.numberStack)
    end
end

return Hero30005_Skill3