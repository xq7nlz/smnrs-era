local HERO_EFFECT_PATH = "csv/client/hero_effect_config.json"

--- @class HeroEffectConfig
HeroEffectConfig = Class(HeroEffectConfig)

function HeroEffectConfig:Ctor()
    --- @type Dictionary
    self.effectDict = nil
    self:Init()
end

function HeroEffectConfig:Init()
    require "lua.client.battleShow.ClientHero.ClientHeroEffectFileConfig"
    local decodeData = CsvReaderUtils.ReadAndParseLocalFile(HERO_EFFECT_PATH, nil, true)
    --- @type Dictionary<number, ClientHeroEffectFileConfig>
    self.effectDict = Dictionary()
    for _, data in ipairs(decodeData) do
        local heroId = data['heroId']
        local clientHeroEffectFileConfig = ClientHeroEffectFileConfig(heroId)
        clientHeroEffectFileConfig:AddGeneralEffectFile(data['effectConfigs'])
        self.effectDict:Add(heroId, clientHeroEffectFileConfig)
    end
end

--- @return ClientHeroEffectFileConfig
function HeroEffectConfig:Get(heroId)
    return self.effectDict:Get(heroId)
end

return HeroEffectConfig