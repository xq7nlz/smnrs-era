--- @class HeroesConfig
HeroesConfig = Class(HeroesConfig)

function HeroesConfig:Ctor()
    --- @type Dictionary
    self.dataDict = Dictionary()
end

function HeroesConfig:GetCsv(class)
    local data = self.dataDict:Get(class)
    if data == nil then
        if type(class) == "boolean" then
            XDebug.Error("NEED RETURN CLASS ")
        end
        data = class()
        self.dataDict:Add(class, data)
    end
    return data
end

--- @return HeroLuaConfig
function HeroesConfig:GetHeroLua()
    return self:GetCsv(require("lua.client.data.Hero.HeroLuaConfig"))
end

--- @return HeroTierConfig
function HeroesConfig:GetHeroTier()
    return self:GetCsv(require("lua.client.data.Hero.HeroTierConfig"))
end

--- @return HeroEffectConfig
function HeroesConfig:GetHeroEffect()
    return self:GetCsv(require("lua.client.data.Hero.HeroEffectConfig"))
end

--- @return HeroImpactConfig
function HeroesConfig:GetHeroEffectImpact()
    return self:GetCsv(require("lua.client.data.Hero.HeroEffectImpactConfig"))
end

--- @return HeroSfxImpactConfig
function HeroesConfig:GetHeroSfxImpact()
    return self:GetCsv(require("lua.client.data.Hero.HeroSfxImpactConfig"))
end

--- @return HeroAnimSoundConfig
function HeroesConfig:GetHeroAnimSound()
    return self:GetCsv(require("lua.client.data.Hero.HeroAnimSoundConfig"))
end

--- @return HeroAnimEffectConfig
function HeroesConfig:GetHeroAnimEffect()
    return self:GetCsv(require("lua.client.data.Hero.HeroAnimEffectConfig"))
end

--- @return EffectLuaConfig
function HeroesConfig:GetEffectLua()
    return self:GetCsv(require("lua.client.data.Hero.EffectLuaConfig"))
end

--- @return HeroCsvConfig
function HeroesConfig:GetHeroCsv()
    return self:GetCsv(require("lua.client.data.Hero.HeroCsvConfig"))
end

--- @return HeroSkillPassiveConfig
function HeroesConfig:GetHeroSkillPassive()
    return self:GetCsv(require("lua.client.data.Hero.HeroSkillPassiveConfig"))
end

--- @return SummonerCsvConfig
function HeroesConfig:GetSummonerCsv()
    return self:GetCsv(require("lua.client.data.Hero.Summoner.SummonerCsvConfig"))
end

--- @return SummonerCsvConfig
function HeroesConfig:GetSummonerSkillPassive()
    return self:GetCsv(require("lua.client.data.Hero.Summoner.SummonerSkillPassiveConfig"))
end

return HeroesConfig



