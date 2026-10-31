--- @class Hero50005_Skill3 GuardianOfLight
Hero50005_Skill3 = Class(Hero50005_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50005_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type number
    self.effectChance = nil

    --- @type number
    self.effectBonusPercent = nil

    --- @type number
    self.totalDamageAttackEnemy = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50005_Skill3:CreateInstance(id, hero)
    return Hero50005_Skill3(id, hero)
end

--- @return void
function Hero50005_Skill3:Init()
    self.effectChance = self.data.effectChance
    self.effectBonusPercent = self.data.effectBonusPercent

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ALLY, self.data.targetNumber)

    self.myHero.attackListener:BindingWithSkill_3(self)
    self.myHero.battleListener:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param turn BattleTurn
function Hero50005_Skill3:OnStartBattleTurn(turn)
    if turn.actionType == ActionType.BASIC_ATTACK then
        self.totalDamageAttackEnemy = 0
    end
end

--- @return void
--- @param turn BattleTurn
function Hero50005_Skill3:OnEndBattleTurn(turn)
    if turn.actionType == ActionType.BASIC_ATTACK then
        if self.myHero.randomHelper:RandomRate(self.effectChance) then
            local targetList = self.targetSelector:SelectTarget(self.myHero.battle)

            local healAmount = self.totalDamageAttackEnemy * self.effectBonusPercent
            local i = 1
            while i <= targetList:Count() do
                local target = targetList:Get(i)
                HealUtils.Heal(self.myHero, target, healAmount, HealReason.HEAL_SKILL)
                i = i + 1
            end
        end
    end
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero50005_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    self.totalDamageAttackEnemy = self.totalDamageAttackEnemy + totalDamage
end

return Hero50005_Skill3