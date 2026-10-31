--- @class Hero50006_BattleListener
Hero50006_BattleListener = Class(Hero50006_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Hero50006_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_3 = nil

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero50006_BattleListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return void
--- @param skill BaseSkill
function Hero50006_BattleListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param round BattleRound
function Hero50006_BattleListener:OnEndBattleRound(round)
    if self.skill_3 ~= nil then
        self.skill_3:OnEndBattleRound()
    end

    if self.skill_4 ~= nil then
        self.skill_4:OnEndBattleRound()
    end
end
