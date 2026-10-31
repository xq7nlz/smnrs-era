--- @class Hero60002_BattleListener
Hero60002_BattleListener = Class(Hero60002_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Hero60002_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_1 = nil
    --- @type BaseSkill
    self.skill_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero60002_BattleListener:BindingWithSkill_1(skill)
    self.skill_1 = skill
end

--- @return number
--- @param skill BaseSkill
function Hero60002_BattleListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return void
--- @param round BattleRound
function Hero60002_BattleListener:OnStartBattleRound(round)
    if self.skill_3 ~= nil then
        self.skill_3:OnStartBattleRound(round.round)
    end
end

--- @return void
--- @param turn BattleTurn
function Hero60002_BattleListener:OnStartBattleTurn(turn)
    if self.skill_3 ~= nil then
        self.skill_3:OnStartBattleTurn(turn.round)
    end
end

--- @return void
--- @param round BattleRound
function Hero60002_BattleListener:OnEndBattleRound(round)
    if self.skill_1 ~= nil then
        self.skill_1:OnEndBattleRound()
    end
end
