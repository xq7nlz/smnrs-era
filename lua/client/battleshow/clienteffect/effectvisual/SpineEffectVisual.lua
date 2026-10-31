--- @class SpineEffectVisual : ClientEffectVisual
SpineEffectVisual = Class(SpineEffectVisual, ClientEffectVisual)

--- @return void
--- @param root UnityEngine_Transform
--- @param childPath string
--- @param isSyncSortingLayerId boolean
--- @param isSyncSortingOrder boolean
--- @param offsetSortingOrder number
function SpineEffectVisual:Ctor(root, childPath,
                                 isSyncSortingLayerId,
                                 isSyncSortingOrder,
                                 offsetSortingOrder)
    ClientEffectVisual.Ctor(self, root, childPath,
            isSyncSortingLayerId,
            isSyncSortingOrder,
            offsetSortingOrder)

    self.meshRenderer = self.gameObject:GetComponent(ComponentName.UnityEngine_MeshRenderer)
end

--- @param layerId number
function SpineEffectVisual:SyncSortingLayerId(layerId)
    self.meshRenderer.sortingLayerID = layerId
end

--- @param sortingOrder number
function SpineEffectVisual:SyncSortingOrder(sortingOrder)
    self.meshRenderer.sortingOrder = sortingOrder + self.offsetSortingOrder
end