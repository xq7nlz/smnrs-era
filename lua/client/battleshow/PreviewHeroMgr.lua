--- @class PreviewHeroMgr
PreviewHeroMgr = Class(PreviewHeroMgr)

function PreviewHeroMgr:Ctor()
    --- @type List {}
    self.previewHeroList = List()
end

function PreviewHeroMgr:AddPreviewHeroInfo(prefabName)
    if self.previewHeroList:IsContainValue(prefabName) == false then
        self.previewHeroList:Add(prefabName)
    end
end

function PreviewHeroMgr:ClearPool()
    local smartPool = SmartPool.Instance
    for i = 1, self.previewHeroList:Count() do
        --- @type string
        local prefabName = self.previewHeroList:Get(i)
        if self:_IsHeroCurrentlyUsed(prefabName) == false then
            smartPool:DestroyGameObjectByPoolTypeAndName(AssetType.Hero, prefabName)
        end
    end
    self.previewHeroList:Clear()
end

function PreviewHeroMgr:_IsHeroCurrentlyUsed(heroPrefabName)
    local checkHeroInMode = function(gameMode)
        --- @type TeamFormationInBound
        local teamFormationInBound = zg.playerData:GetFormationInBound().teamDict:Get(gameMode)
        if teamFormationInBound ~= nil then
            local listUsedPrefabName = teamFormationInBound:GetListHeroPrefabName()
            return listUsedPrefabName:IsContainValue(heroPrefabName)
        end
        return false
    end
    return checkHeroInMode(GameMode.CAMPAIGN)
            or checkHeroInMode(GameMode.ARENA)
            or checkHeroInMode(GameMode.TOWER)
            or checkHeroInMode(GameMode.TOWER_RECORD)
end
