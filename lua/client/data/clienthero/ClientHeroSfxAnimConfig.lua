require "lua.client.data.ClientHero.ClientHeroSkinSfxAnimConfig"

--- @class ClientHeroSfxAnimConfig
ClientHeroSfxAnimConfig = Class(ClientHeroSfxAnimConfig)

function ClientHeroSfxAnimConfig:Ctor()
    --- @type Dictionary -- skinName, ClientHeroSkinSfxAnimConfig
    self.skinSfxAnimConfig = Dictionary()
end

--- @return Dictionary
--- @param gameObject UnityEngine_GameObject
--- @param skinName string
function ClientHeroSfxAnimConfig:GetSkinSfxAnimConfig(gameObject, skinName)
    --- @type ClientHeroSkinSfxAnimConfig
    local clientHeroSkinSfxAnimConfig = self.skinSfxAnimConfig:Get(skinName)
    if clientHeroSkinSfxAnimConfig == nil then
        clientHeroSkinSfxAnimConfig = ClientHeroSkinSfxAnimConfig(gameObject)
        self.skinSfxAnimConfig:Add(skinName, clientHeroSkinSfxAnimConfig)
    end
    return clientHeroSkinSfxAnimConfig:GetSoundFrameEffectData()
end