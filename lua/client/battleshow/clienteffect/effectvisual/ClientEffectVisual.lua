--- @class ClientEffectVisual
ClientEffectVisual = Class(ClientEffectVisual)

--- @return void
--- @param root UnityEngine_Transform
--- @param childPath string
--- @param isSyncSortingLayerId boolean
--- @param isSyncSortingOrder boolean
--- @param offsetSortingOrder number
function ClientEffectVisual:Ctor(root, childPath,
                                 isSyncSortingLayerId,
                                 isSyncSortingOrder,
                                 offsetSortingOrder)
    --- @type UnityEngine_GameObject
    self.gameObject = root:Find(childPath)
    --- @type boolean
    self.isSyncSortingLayerId = isSyncSortingLayerId
    --- @type boolean
    self.isSyncSortingOrder = isSyncSortingOrder
    --- @type number
    self.offsetSortingOrder = offsetSortingOrder
end

--- @param gameObject UnityEngine_GameObject
function ClientEffectVisual:SetGameObject(gameObject)
    self.gameObject = gameObject
end

--- @param clientHero ClientHero
function ClientEffectVisual:OnTargetLayerChanged(clientHero)
    local sortingLayerId, sortingOrder = clientHero.animation:GetHeroVisualLayer()
    if self.isSyncSortingLayerId == true then
        self:SyncSortingLayerId(sortingLayerId)
    end
    if self.isSyncSortingOrder == true then
        self:SyncSortingOrder(sortingOrder)
    end
end

--- @param layerId number
function ClientEffectVisual:SyncSortingLayerId(layerId)

end

--- @param sortingOrder number
function ClientEffectVisual:SyncSortingOrder(sortingOrder)

end

--- @param sortingLayerId number
--- @param sortingOrder number
function ClientEffectVisual:SyncLayerByParams(sortingLayerId, sortingOrder)
    if self.isSyncSortingLayerId == true then
        self:SyncSortingLayerId(sortingLayerId)
    end
    if self.isSyncSortingOrder == true then
        self:SyncSortingOrder(sortingOrder)
    end
end