require "lua.client.data.ClientHero.ClientHeroSkinFxAnimConfig"

--- @class ClientHeroFxAnimConfig
ClientHeroFxAnimConfig = Class(ClientHeroFxAnimConfig)

function ClientHeroFxAnimConfig:Ctor()
    --- @type Dictionary -- skinName, ClientHeroSkinFxAnimConfig
    self.skinFxAnimConfig = Dictionary()
end

--- @return Dictionary
--- @param gameObject UnityEngine_GameObject
--- @param skinName string
function ClientHeroFxAnimConfig:GetSkinFxAnimConfig(gameObject, skinName)
    --- @type ClientHeroSkinFxAnimConfig
    local clientHeroSkinFxAnimConfig = self.skinFxAnimConfig:Get(skinName)
    if clientHeroSkinFxAnimConfig == nil then
        clientHeroSkinFxAnimConfig = ClientHeroSkinFxAnimConfig(gameObject)
        self.skinFxAnimConfig:Add(skinName, clientHeroSkinFxAnimConfig)
    end
    return clientHeroSkinFxAnimConfig:GetAnimFrameEffectData()
end