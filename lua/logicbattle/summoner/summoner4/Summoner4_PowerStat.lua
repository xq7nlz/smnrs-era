--- @class Summoner4_PowerStat : Summoner_PowerStat
Summoner4_PowerStat = Class(Summoner4_PowerStat, Summoner_PowerStat)

--- @return void
--- @param hero BaseSummoner
function Summoner4_PowerStat:Ctor(hero)
    Summoner_PowerStat.Ctor(self, hero)

    --- @type BaseSkill
    self.skill4_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Summoner4_PowerStat:BindingWithSkill4_3(skill)
    self.skill4_3 = skill
end

--- @return void
--- reset value to minValue
function Summoner4_PowerStat:SetToMin()
    Summoner_PowerStat.SetToMin(self)

    if self.skill4_3 ~= nil then
        self.skill4_3:OnPowerChange()
    end
end

--- @return void
--- @param initiator BaseSummoner
--- @param amount number
function Summoner4_PowerStat:GainPowerFromHero(initiator, amount)
    Summoner_PowerStat.GainPowerFromHero(self, initiator, amount)

    if self.skill4_3 ~= nil then
        self.skill4_3:OnPowerChange()
    end
end