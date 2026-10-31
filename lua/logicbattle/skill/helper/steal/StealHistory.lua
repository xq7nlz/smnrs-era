--- @class StealHistory
StealHistory = Class(StealHistory)

--- @return void
--- @param thief BaseHero
--- @param victim BaseHero
--- @param statChanger StatChanger
--- @param statDebuffEffect StatChangerEffect
--- @param statBuffEffect StatChangerEffect
--- @param amountStolen number
function StealHistory:Ctor(thief, victim, statChanger, statDebuffEffect, statBuffEffect, amountStolen)
    --- @type BaseHero
    self.thief = thief

    --- @type BaseHero
    self.victim = victim

    --- @type StatChanger
    self.statChanger = statChanger

    --- @type StatChangerEffect
    self.statDebuffEffect = statDebuffEffect

    --- @type StatChangerEffect
    self.statBuffEffect = statBuffEffect

    --- @type number
    self.amountStolen = amountStolen
end