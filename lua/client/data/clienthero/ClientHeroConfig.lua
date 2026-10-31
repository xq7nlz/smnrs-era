require "lua.client.data.ClientHero.ClientHeroFxAnimConfig"
require "lua.client.data.ClientHero.ClientHeroSfxAnimConfig"

--- @class ClientHeroConfig
ClientHeroConfig = Class(ClientHeroConfig)

function ClientHeroConfig:Ctor()
    --- @type Dictionary -- heroId, ClientHeroFxAnimConfig
    self.heroFxAnimConfigDict = Dictionary()

    --- @type Dictionary -- heroId, ClientHeroSfxAnimConfig
    self.heroSfxAnimConfigDict = Dictionary()
end

--- @return Dictionary
--- @param gameObject UnityEngine_GameObject
--- @param heroId number
--- @param skinName string
function ClientHeroConfig:GetFxAnimConfig(gameObject, heroId, skinName)
    --- @type ClientHeroFxAnimConfig
    local clientHeroAnimEffectConfig = self.heroFxAnimConfigDict:Get(heroId)
    if clientHeroAnimEffectConfig == nil then
        clientHeroAnimEffectConfig = ClientHeroFxAnimConfig()
        self.heroFxAnimConfigDict:Add(heroId, clientHeroAnimEffectConfig)
    end
    return clientHeroAnimEffectConfig:GetSkinFxAnimConfig(gameObject, skinName)
end

--- @return Dictionary
--- @param gameObject UnityEngine_GameObject
--- @param heroId number
--- @param skinName string
function ClientHeroConfig:GetSfxAnimConfig(gameObject, heroId, skinName)
    --- @type ClientHeroSfxAnimConfig
    local clientHeroSfxAnimConfig = self.heroSfxAnimConfigDict:Get(heroId)
    if clientHeroSfxAnimConfig == nil then
        clientHeroSfxAnimConfig = ClientHeroSfxAnimConfig()
        self.heroSfxAnimConfigDict:Add(heroId, clientHeroSfxAnimConfig)
    end
    return clientHeroSfxAnimConfig:GetSkinSfxAnimConfig(gameObject, skinName)
end

return ClientHeroConfig