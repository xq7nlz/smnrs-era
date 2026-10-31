--- @class Hero40027_PowerStat : PowerStat
Hero40027_PowerStat = Class(Hero40027_PowerStat, PowerStat)

--- @return void
--- @param hero BaseHero
function Hero40027_PowerStat:Ctor(hero)
    PowerStat.Ctor(self, hero)
end

--- @return void
--- @param initiator BaseHero
--- @param amount number
function Hero40027_PowerStat:Gain(initiator, amount)
    if self.myHero.isDragonForm == true then
        return
    end

    PowerStat.Gain(self,initiator, amount)
end


---------------------------------------- Setters ----------------------------------------
--- @return void
--- @param actionId number id of action that relates to powerGainEntry
function Hero40027_PowerStat:Regen(actionId)
    if self.myHero.isDragonForm == true then
        return
    end
    PowerStat.Regen(self,actionId)
end