--- @class ClientHeroEffectFileConfig
ClientHeroEffectFileConfig = Class(ClientHeroEffectFileConfig)

--- @param heroId number
function ClientHeroEffectFileConfig:Ctor(heroId)
    --- @type number
    self.heroId = heroId
    --- @type List<string>
    self.generalEffect = List()
    --- @type Dictionary<string, List<string>>
    self.skinEffectDict = Dictionary()
end

--- @param generalEffectFile table<list<string>>
function ClientHeroEffectFileConfig:AddGeneralEffectFile(generalEffectFile)
    for i = 1, #generalEffectFile do
        if self.generalEffect:IsContainValue(generalEffectFile[i]) == false then
            self.generalEffect:Add(generalEffectFile[i])
        end
    end
end

--- @param skinName string
function ClientHeroEffectFileConfig:AddSkinEffectFile(skinName, effectFileName)
    if self.skinEffectDict:IsContainKey(skinName) == false then
        local listEffectFile = List()
        for i = 1, #effectFileName do
            listEffectFile:Add(effectFileName[i])
        end
        self.skinEffectDict:Add(skinName, listEffectFile)
    end
end
