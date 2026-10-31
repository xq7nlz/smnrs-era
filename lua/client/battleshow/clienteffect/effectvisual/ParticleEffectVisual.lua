--- @class ParticleEffectVisual : ClientEffectVisual
ParticleEffectVisual = Class(ParticleEffectVisual, ClientEffectVisual)

--- @return void
--- @param root UnityEngine_Transform
--- @param childPath string
--- @param isSyncSortingLayerId boolean
--- @param isSyncSortingOrder boolean
--- @param offsetSortingOrder number
function ParticleEffectVisual:Ctor(root, childPath,
                                isSyncSortingLayerId,
                                isSyncSortingOrder,
                                offsetSortingOrder)
    ClientEffectVisual.Ctor(self, root, childPath,
            isSyncSortingLayerId,
            isSyncSortingOrder,
            offsetSortingOrder)
    self.particleRenderer = self.gameObject:GetComponent(ComponentName.UnityEngine_ParticleSystemRenderer)
end

--- @param layerId number
function ParticleEffectVisual:SyncSortingLayerId(layerId)
    self.particleRenderer.sortingLayerID = layerId
end

--- @param sortingOrder number
function ParticleEffectVisual:SyncSortingOrder(sortingOrder)
    self.particleRenderer.sortingOrder = sortingOrder + self.offsetSortingOrder
end