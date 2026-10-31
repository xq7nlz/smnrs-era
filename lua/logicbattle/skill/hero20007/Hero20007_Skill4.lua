--- @class Hero20007_Skill4 Ninetales
Hero20007_Skill4 = Class(Hero20007_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20007_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type number
    self.healPerRound = nil

    --- @type number
    self.healIncreasePerRound = nil

    --- @type number
    self.numberStack = 0
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero20007_Skill4:CreateInstance(id, hero)
    return Hero20007_Skill4(id, hero)
end

--- @return void
function Hero20007_Skill4:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    self.healPerRound = self.data.healPerRound
    self.healIncreasePerRound = self.data.healIncreasePerRound

    self.myHero.battleListener:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param round BattleRound
function Hero20007_Skill4:OnStartBattleRound(round)
    if self.myHero:IsDead() == false then
        local healAmount = self.healPerRound + self.healIncreasePerRound * self.numberStack
        healAmount = healAmount * self.myHero.attack:GetValue()

        self.numberStack = self.numberStack + 1

        local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
        local i = 1
        while i <= targetList:Count() do
            local target = targetList:Get(i)
            HealUtils.Heal(self.myHero, target, healAmount, HealReason.HEAL_SKILL)
            i = i + 1
        end
    end
end

return Hero20007_Skill4