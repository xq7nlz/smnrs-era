--- @class Hero50007_BattleListener
Hero50007_BattleListener = Class(Hero50007_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Hero50007_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero50007_BattleListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param round BattleRound
function Hero50007_BattleListener:OnEndBattleRound(round)
    if self.skill_2 ~= nil then
        self.skill_2:OnEndBattleRound()
    end
end
