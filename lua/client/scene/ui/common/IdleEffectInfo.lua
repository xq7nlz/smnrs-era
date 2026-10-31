--- @class IdleEffectInfo : RootIconView
IdleEffectInfo = Class(IdleEffectInfo, RootIconView)

--- @return void
function IdleEffectInfo:SetPrefabName()
    self.prefabName = 'idle_effect_info'
    self.uiPoolType = UIPoolType.IdleEffectInfo
end

---@param isNew boolean
function IdleEffectInfo:SetNew(isNew)
    self.config.new.gameObject:SetActive(isNew)
end

---@param isNew boolean
function IdleEffectInfo:SetChoosen(isChoose)
    self.config.border.gameObject:SetActive(isChoose)
end

--- @return void
function IdleEffectInfo:ReturnPool()
    RootIconView.ReturnPool(self)
    self:SetChoosen(false)
end

--- @return void
--- @param transform UnityEngine_RectTransform
function IdleEffectInfo:SetConfig(transform)
    RootIconView.SetConfig(self, transform)
    --- @type UnityEngine_RectTransform
    self.config.new =  transform:Find("new"):GetComponent(ComponentName.UnityEngine_RectTransform)
    self.config.border =  transform:Find("border"):GetComponent(ComponentName.UnityEngine_RectTransform)
end

return IdleEffectInfo

