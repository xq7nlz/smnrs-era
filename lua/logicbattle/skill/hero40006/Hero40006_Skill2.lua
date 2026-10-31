--- @class Hero40006_Skill2 Oropher
Hero40006_Skill2 = Class(Hero40006_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40006_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type number
    self.effectChance = nil

    --- @type number
    self.effectBonusPercent = nil

    --- @type number
    self.totalDamageAttackEnemy = nil

    --- @type BaseSkill
    self.skill_3 = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40006_Skill2:CreateInstance(id, hero)
    return Hero40006_Skill2(id, hero)
end

--- @return void
function Hero40006_Skill2:Init()
    self.effectChance = self.data.effectChance
    self.effectBonusPercent = self.data.effectBonusPercent

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    self.myHero.attackListener:BindingWithSkill_2(self)
    self.myHero.battleListener:BindingWithSkill_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param turn BattleTurn
function Hero40006_Skill2:OnStartBattleTurn(turn)
    if turn.actionType == ActionType.BASIC_ATTACK then
        self.totalDamageAttackEnemy = 0
    end
end

--- @return void
--- @param turn BattleTurn
function Hero40006_Skill2:OnEndBattleTurn(turn)
    if turn.actionType == ActionType.BASIC_ATTACK then
        if self.myHero.randomHelper:RandomRate(self.effectChance) then
            local targetList = self.targetSelector:SelectTarget(self.myHero.battle)

            local healAmount = self.totalDamageAttackEnemy * self.effectBonusPercent
            local i = 1
            while i <= targetList:Count() do
                local target = targetList:Get(i)
                HealUtils.Heal(self.myHero, target, healAmount, HealReason.HEAL_SKILL)

                if self.skill_3 ~= nil then
                    self.skill_3:OnHeal(self.myHero, HealReason.HEAL_SKILL, healAmount)
                end
                i = i + 1
            end
        end
    end
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero40006_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    self.totalDamageAttackEnemy = self.totalDamageAttackEnemy + totalDamage
end

--- @return void
--- @param skill BaseSkill
function Hero40006_Skill2:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

return Hero40006_Skill2