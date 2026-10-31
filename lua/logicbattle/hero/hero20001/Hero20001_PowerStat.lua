--- @class Hero20001_PowerStat
Hero20001_PowerStat = Class(Hero20001_PowerStat, PowerStat)

---------------------------------------- Setters ----------------------------------------
--- @return void
--- @param actionId number id of action that relates to powerGainEntry
function Hero20001_PowerStat:Regen(actionId)
    if self.myHero.effectController:IsContainEffectType(EffectType.REBORN) then
        self._totalValue = 0
    else
        PowerStat.Regen(self, actionId)
    end
end