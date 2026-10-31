--- @class SpriteEffectVisual : ClientEffectVisual
SpriteEffectVisual = Class(SpriteEffectVisual, ClientEffectVisual)

--- @return void
--- @param root UnityEngine_Transform
--- @param childPath string
--- @param isSyncSortingLayerId boolean
--- @param isSyncSortingOrder boolean
--- @param offsetSortingOrder number
function SpriteEffectVisual:Ctor(root, childPath,
                                isSyncSortingLayerId,
                                isSyncSortingOrder,
                                offsetSortingOrder)
    ClientEffectVisual.Ctor(self, root, childPath,
            isSyncSortingLayerId,
            isSyncSortingOrder,
            offsetSortingOrder)

    self.spriteRenderer = self.gameObject:GetComponent(ComponentName.UnityEngine_SpriteRenderer)
end

--- @param layerId number
function SpriteEffectVisual:SyncSortingLayerId(layerId)
    self.spriteRenderer.sortingLayerID = layerId
end

--- @param sortingOrder number
function SpriteEffectVisual:SyncSortingOrder(sortingOrder)
    self.spriteRenderer.sortingOrder = sortingOrder + self.offsetSortingOrder
end