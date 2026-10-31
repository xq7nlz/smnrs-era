--- @class Hero30013_Skill2 Minimanser
Hero30013_Skill2 = Class(Hero30013_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30013_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type number
    self.healChance = nil

    --- @type number
    self.healAmount = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30013_Skill2:CreateInstance(id, hero)
    return Hero30013_Skill2(id, hero)
end

--- @return void
function Hero30013_Skill2:Init()
    self.healChance = self.data.healChance
    self.healAmount = self.data.healAmount

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ALLY, self.data.targetNumber)

    self.myHero.battleListener:BindingWithSkill_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param turn BattleTurn
function Hero30013_Skill2:OnEndBattleTurn(turn)
    if turn.actionType == ActionType.BASIC_ATTACK and self.myHero.randomHelper:RandomRate(self.healChance) then
        local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
        local i = 1
        while i <= targetList:Count() do
            local target = targetList:Get(i)
            local healAmount = self.myHero.attack:GetValue() * self.healAmount
            HealUtils.Heal(self.myHero, target, healAmount, HealReason.HEAL_SKILL)
            i = i + 1
        end
    end
end

return Hero30013_Skill2